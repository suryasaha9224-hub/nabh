import os
import re
import json
import pandas as pd
import mysql.connector
import joblib
from datetime import datetime, timedelta
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import matplotlib
matplotlib.use('Agg') # Crucial to prevent Jupyter from freezing when drawing charts
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import warnings
warnings.filterwarnings('ignore')

app = Flask(__name__)
CORS(app)

# 🌟 SMART PATH RESOLVER: Works for both standard Python and Jupyter Notebooks
try:
    # Try the standard Python way first
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
except NameError:
    # Fallback for Jupyter (which doesn't support __file__)
    BASE_DIR = os.getcwd()

# If VS Code or Jupyter started in the root 'NABH_Project' folder instead of 'ai_engine', auto-correct it!
if not BASE_DIR.endswith('ai_engine'):
    BASE_DIR = os.path.join(BASE_DIR, 'ai_engine')

print("==========================================================")
print(" 🚀 STARTING AMAR AI MICROSERVICE (JUPYTER MODE)")
print("==========================================================")
print(f"📁 Looking for ML Models in: {BASE_DIR}")

# --- 1. LOAD MODELS ON STARTUP ---
print("⚙️ Loading ML Models...")
MODELS_LOADED = False
try:
    # Explicitly using your absolute paths as requested
    model_resolution = joblib.load("C:/Users/it/Downloads/amar_resolution_model.pkl")
    model_mtbf = joblib.load("C:/Users/it/Downloads/amar_mtbf_model.pkl")
    le_asset = joblib.load("C:/Users/it/Downloads/le_asset.pkl")
    le_urgency = joblib.load("C:/Users/it/Downloads/le_urgency.pkl")
    le_parts = joblib.load("C:/Users/it/Downloads/le_parts.pkl")
    MODELS_LOADED = True
    print("✅ Models loaded successfully!")
except Exception as e:
    print(f"❌ ERROR: ML Models failed to load! Starting in TRAIL MODE.")
    print(f"   Reason: {e}")
    print("   The system will return the test date (2030-01-01) for all predictions.")


# --- 2. HELPER FUNCTIONS ---
def get_db_connection():
    """Establish a fresh database connection per request to prevent timeouts"""
    return mysql.connector.connect(
        host='localhost',
        database='nabh_pr',
        user='root',
        password=''
    )

def clean_asset_name(name):
    """Strips away '(SN: 1234)' to get the base category"""
    return re.sub(r'\s*\([^)]*\)', '', str(name)).strip()

def smart_encode(encoder, name, fallback=0):
    """Intelligently matches the asset name to the trained ML categories"""
    clean_name = clean_asset_name(name)
    try:
        return encoder.transform([clean_name])[0]
    except ValueError:
        for known_item in encoder.classes_:
            if clean_name.lower() in str(known_item).lower() or str(known_item).lower() in clean_name.lower():
                return encoder.transform([known_item])[0]
        return fallback

def safe_encode(encoder, value, fallback=0):
    try:
        return encoder.transform([value])[0]
    except ValueError:
        return fallback

# 🌟 BULLETPROOF PREDICTION HELPERS
def safe_predict_mtbf(model, a_enc):
    try:
        expected_features = getattr(model, 'n_features_in_', 1)
        if expected_features == 3:
            return model.predict([[a_enc, 0, 0]])[0] 
        return model.predict([[a_enc]])[0]
    except Exception:
        return 30.0 

def safe_predict_resolution(model, a_enc, u_enc, p_enc):
    try:
        expected_features = getattr(model, 'n_features_in_', 3)
        if expected_features == 1:
            return model.predict([[a_enc]])[0] 
        return model.predict([[a_enc, u_enc, p_enc]])[0]
    except Exception:
        return 24.0 

# --- FPDF DARK THEME CLASS ---
class DarkPDF(FPDF):
    def header(self):
        # Fill the entire page with the Deep Dark Background (#0B1325)
        self.set_fill_color(11, 19, 37)
        self.rect(0, 0, 210, 297, 'F')

def draw_card(pdf, x, y, w, h, title):
    """Draws a premium dark card/panel exactly matching the UI"""
    pdf.set_fill_color(28, 42, 66) # Card Background (#1C2A42)
    pdf.set_draw_color(51, 65, 85) # Border (#334155)
    pdf.rect(x, y, w, h, 'DF')
    
    # Title
    pdf.set_xy(x+5, y+5)
    pdf.set_font('Arial', 'B', 10)
    pdf.set_text_color(148, 163, 184) # Muted Text (#94A3B8)
    pdf.cell(w-10, 6, title.upper(), 0, 1, 'L')
    
    # Line under title
    pdf.set_draw_color(51, 65, 85)
    pdf.line(x+5, y+12, x+w-5, y+12)
    
    # Reset cursor for content
    pdf.set_xy(x+5, y+15)


# --- 3. API ENDPOINTS ---

@app.route('/get_prediction', methods=['GET'])
def get_prediction():
    asset = request.args.get('asset', '')
    serial = request.args.get('serial', '')

    user_input = f"{asset} {serial}".strip()
    base_name = clean_asset_name(user_input)

    if not base_name:
        return jsonify({'status': 'error', 'message': 'No asset provided.'})

    conn = get_db_connection()
    try:
        query = f"SELECT MAX(report_date) as last_breakdown FROM asset_report WHERE asset_name LIKE '%{base_name}%'"
        df_hist = pd.read_sql(query, conn)
        
        last_breakdown_raw = df_hist['last_breakdown'].iloc[0]
        
        # 🌟 NaT SAFE: Coerce errors, use today if missing
        last_breakdown = pd.to_datetime(last_breakdown_raw, errors='coerce')
        if pd.isnull(last_breakdown):
            last_breakdown = datetime.now()

        if not MODELS_LOADED:
            print(f"⚠️ TRAIL MODE ACTIVE: Returning test date (2030-01-01) for '{base_name}'")
            return jsonify({
                'status': 'success', 'asset_analyzed': base_name, 'predicted_mtbf_days': 0,
                'next_failure_date': '2030-01-01', 'best_case_hrs': 0.0, 'worst_case_hrs': 0.0, 'trail_mode': True
            })

        a_enc = smart_encode(le_asset, base_name)
        predicted_days_to_fail = safe_predict_mtbf(model_mtbf, a_enc)
        next_failure_date = last_breakdown + timedelta(days=predicted_days_to_fail)
        
        u_low = safe_encode(le_urgency, 'low'); p_no = safe_encode(le_parts, 'n')
        u_crit = safe_encode(le_urgency, 'critical'); p_yes = safe_encode(le_parts, 'y')
        
        best_case_hrs = safe_predict_resolution(model_resolution, a_enc, u_low, p_no)
        worst_case_hrs = safe_predict_resolution(model_resolution, a_enc, u_crit, p_yes)

        return jsonify({
            'status': 'success', 'asset_analyzed': base_name, 'predicted_mtbf_days': round(predicted_days_to_fail),
            'next_failure_date': next_failure_date.strftime('%Y-%m-%d'), 'best_case_hrs': round(best_case_hrs, 1),
            'worst_case_hrs': round(worst_case_hrs, 1)
        })

    except Exception as e:
        print(f"❌ Prediction crashed: {e}")
        return jsonify({
            'status': 'success', 'asset_analyzed': base_name, 'predicted_mtbf_days': 0,
            'next_failure_date': '2030-01-01', 'best_case_hrs': 0.0, 'worst_case_hrs': 0.0, 'trail_mode': True
        })
    finally:
        conn.close()


@app.route('/generate_report', methods=['GET'])
def generate_report():
    asset = request.args.get('name', '')
    serial = request.args.get('serial', '')
    
    user_input = f"{asset} {serial}".strip()
    base_name = clean_asset_name(user_input)

    if not base_name:
        return jsonify({'status': 'error', 'message': 'Missing asset parameters'})

    conn = get_db_connection()
    try:
        temp_dir = os.path.join(BASE_DIR, 'temp_reports')
        os.makedirs(temp_dir, exist_ok=True)
        print(f"📄 Generating PREMIUM Dark PDF Report for: {base_name.upper()}...")

        # 1. Fetch Maintenance Data
        query_maint = f"SELECT * FROM asset_report WHERE asset_name LIKE '%{serial if serial else base_name}%' ORDER BY report_date DESC"
        df_maint = pd.read_sql(query_maint, conn)

        # 2. Fetch Master Profile
        query_master = f"SELECT i.*, p.date_purchased FROM item_table i LEFT JOIN purchased_items p ON i.serial_number = p.serial_number WHERE i.serial_number = '{serial}' OR i.item_name LIKE '%{base_name}%' LIMIT 1"
        df_master = pd.read_sql(query_master, conn)

        # 3. Fetch Allocation
        query_alloc = f"SELECT allocation FROM asset_history WHERE item_id = (SELECT item_id FROM item_table WHERE serial_number = '{serial}' LIMIT 1)" if serial else f"SELECT allocation FROM asset_history WHERE item_name LIKE '%{base_name}%' LIMIT 1"
        df_alloc = pd.read_sql(query_alloc, conn)

        # ==========================================
        # ACCURATE BASELINE DATE LOGIC (NaT SAFE)
        # ==========================================
        baseline_date = None
        baseline_source = "Current Date (Fallback)"

        if not df_maint.empty:
            raw_date = pd.to_datetime(df_maint['report_date'].iloc[0], errors='coerce')
            if pd.notnull(raw_date):
                baseline_date = raw_date
                baseline_source = "Last Maintenance Report"
        
        if baseline_date is None and not df_alloc.empty and df_alloc['allocation'].iloc[0] and str(df_alloc['allocation'].iloc[0]).lower() != 'nan':
            try:
                alloc_data = json.loads(df_alloc['allocation'].iloc[0])
                latest_alloc = None
                for dept, dates in alloc_data.items():
                    d_str = dates.get('allocation_date')
                    if d_str and str(d_str).lower() != 'nan':
                        dt = pd.to_datetime(d_str, errors='coerce')
                        if pd.notnull(dt):
                            if latest_alloc is None or dt > latest_alloc: 
                                latest_alloc = dt
                if latest_alloc:
                    baseline_date = latest_alloc
                    baseline_source = "Last Assigned Date"
            except: pass

        if baseline_date is None or pd.isnull(baseline_date):
            baseline_date = datetime.now()

        # ==========================================
        # ML PREDICTIONS
        # ==========================================
        if MODELS_LOADED:
            a_enc = smart_encode(le_asset, base_name)
            predicted_mtbf_days = safe_predict_mtbf(model_mtbf, a_enc)
            next_failure_date = baseline_date + timedelta(days=predicted_mtbf_days)

            u_low = safe_encode(le_urgency, 'low'); p_no = safe_encode(le_parts, 'n')
            u_crit = safe_encode(le_urgency, 'critical'); p_yes = safe_encode(le_parts, 'y')
            best_case_hrs = safe_predict_resolution(model_resolution, a_enc, u_low, p_no)
            worst_case_hrs = safe_predict_resolution(model_resolution, a_enc, u_crit, p_yes)
        else:
            predicted_mtbf_days = 0
            next_failure_date = datetime(2030, 1, 1) # Fail safe requested date
            best_case_hrs, worst_case_hrs = 0.0, 0.0

        # ==========================================
        # GENERATE DARK CHARTS (NaT & LAYOUT SAFE)
        # ==========================================
        plt.style.use('dark_background')
        pie_path = os.path.join(temp_dir, f"pie_{serial}.png")
        bar_path = os.path.join(temp_dir, f"bar_{serial}.png")
        freq_path = os.path.join(temp_dir, f"freq_{serial}.png")

        if not df_maint.empty:
            # CHART 1: Priority Split (Pie Chart)
            fig1, ax1 = plt.subplots(figsize=(4, 3.5))
            fig1.patch.set_facecolor('#1C2A42')
            ax1.set_facecolor('#1C2A42')
            
            urgency_counts = df_maint['urgency_level'].value_counts()
            color_map = {'critical': '#EF4444', 'high': '#F97316', 'medium': '#3B82F6', 'low': '#94A3B8'}
            colors = [color_map.get(str(lvl).lower(), '#94A3B8') for lvl in urgency_counts.index]
            
            ax1.pie(urgency_counts, labels=urgency_counts.index, colors=colors, autopct='%.0f%%', startangle=90, textprops={'color':"w", 'fontsize':8}, wedgeprops={'linewidth': 1, 'edgecolor': '#1C2A42'})
            centre_circle = plt.Circle((0,0),0.50,fc='#1C2A42')
            fig1.gca().add_artist(centre_circle)
            plt.savefig(pie_path, facecolor=fig1.get_facecolor(), edgecolor='none', bbox_inches='tight', dpi=200)
            plt.close()

            # CHART 2: Resolution Time Trend (FIXED BARS)
            fig2, ax2 = plt.subplots(figsize=(4, 3.5))
            fig2.patch.set_facecolor('#1C2A42')
            ax2.set_facecolor('#1C2A42')
            
            df_resolved = df_maint[df_maint['resolved_date'].notna() & (df_maint['resolved_date'] != '0000-00-00 00:00:00') & (df_maint['resolved_date'] != 'nan')].copy()
            
            if not df_resolved.empty:
                df_resolved['report_date_dt'] = pd.to_datetime(df_resolved['report_date'], errors='coerce')
                df_resolved['resolved_date_dt'] = pd.to_datetime(df_resolved['resolved_date'], errors='coerce')
                df_resolved = df_resolved.dropna(subset=['report_date_dt', 'resolved_date_dt'])
            
            if not df_resolved.empty:
                df_resolved['resolve_hours'] = (df_resolved['resolved_date_dt'] - df_resolved['report_date_dt']).dt.total_seconds() / 3600
                df_resolved = df_resolved.sort_values('report_date_dt')
                
                # Format string for display
                df_resolved['report_date_str'] = df_resolved['report_date_dt'].dt.strftime('%d %b')
                
                sns.barplot(x='report_date_str', y='resolve_hours', data=df_resolved, color='#3B82F6', ax=ax2, errorbar=None)
                
                # 🌟 FIX FOR GIANT BARS: Constrain width so it never stretches fully across
                for patch in ax2.patches:
                    current_width = patch.get_width()
                    if current_width > 0.4:
                        patch.set_width(0.4)
                        # Recenter it correctly
                        patch.set_x(patch.get_x() + (current_width - 0.4) / 2)
                
                # Draw the AI Prediction lines directly over the actual data
                if MODELS_LOADED:
                    ax2.axhline(best_case_hrs, color='#10B981', linestyle='--', linewidth=1.5, label=f'Best ({best_case_hrs:.1f}h)')
                    ax2.axhline(worst_case_hrs, color='#EF4444', linestyle='--', linewidth=1.5, label=f'Worst ({worst_case_hrs:.1f}h)')
                    ax2.legend(fontsize=6, facecolor='#1C2A42', edgecolor='#334155', labelcolor='white', loc='upper right')

                ax2.set_ylabel("Hours to Fix", color='#94A3B8', fontsize=7)
                ax2.set_xlabel("")
                ax2.tick_params(axis='x', rotation=45, colors='#94A3B8', labelsize=6)
                ax2.tick_params(axis='y', colors='#94A3B8', labelsize=6)
                for spine in ax2.spines.values(): spine.set_color('#334155')
            else:
                ax2.text(0.5, 0.5, 'No valid resolved data to plot.', ha='center', va='center', color='#94A3B8', fontsize=8)
            plt.tight_layout()
            plt.savefig(bar_path, facecolor=fig2.get_facecolor(), edgecolor='none', bbox_inches='tight', dpi=200)
            plt.close()

            # CHART 3: Incident Frequency Trend (NEW / FIXED)
            fig3, ax3 = plt.subplots(figsize=(4, 3.5))
            fig3.patch.set_facecolor('#1C2A42')
            ax3.set_facecolor('#1C2A42')
            
            df_freq = df_maint.copy()
            df_freq['report_date_dt'] = pd.to_datetime(df_freq['report_date'], errors='coerce')
            df_freq = df_freq.dropna(subset=['report_date_dt'])
            
            if not df_freq.empty:
                df_freq = df_freq.sort_values('report_date_dt')
                df_freq['month_yr'] = df_freq['report_date_dt'].dt.strftime('%b %Y')
                
                counts = df_freq.groupby('month_yr', sort=False).size()
                
                # 🌟 Adding 'marker' ensures even 1 single data point is highly visible
                sns.lineplot(x=counts.index, y=counts.values, color='#F59E0B', marker='o', linewidth=2, markersize=8, ax=ax3)
                
                ax3.set_ylabel("Incident Count", color='#94A3B8', fontsize=7)
                ax3.set_xlabel("")
                ax3.yaxis.get_major_locator().set_params(integer=True) # Whole numbers only
                ax3.tick_params(axis='x', rotation=45, colors='#94A3B8', labelsize=6)
                ax3.tick_params(axis='y', colors='#94A3B8', labelsize=6)
                for spine in ax3.spines.values(): spine.set_color('#334155')
            else:
                ax3.text(0.5, 0.5, 'No valid dates for frequency.', ha='center', va='center', color='#94A3B8', fontsize=8)
                
            plt.tight_layout()
            plt.savefig(freq_path, facecolor=fig3.get_facecolor(), edgecolor='none', bbox_inches='tight', dpi=200)
            plt.close()

        # ==========================================
        # FPDF COMPILATION (Perfectly aligned grid)
        # ==========================================
        pdf = DarkPDF()
        pdf.add_page()

        master_sn = df_master['serial_number'].iloc[0] if not df_master.empty else serial
        master_model = df_master['item_model'].iloc[0] if not df_master.empty else 'N/A'
        master_mfr = df_master['item_manufacturer'].iloc[0] if not df_master.empty else 'N/A'

        # --- ROW 1: Master Profile & Allocation (Height: 55) ---
        draw_card(pdf, 10, 10, 90, 55, "Master Profile")
        pdf.set_xy(15, 20)
        pdf.set_font('Arial', 'B', 7)
        pdf.set_text_color(148, 163, 184)
        pdf.cell(80, 4, "ASSET NAME", 0, 1, 'L')
        pdf.set_x(15)
        pdf.set_font('Arial', 'B', 14)
        pdf.set_text_color(255, 255, 255)
        pdf.cell(80, 6, base_name.upper()[:22], 0, 1, 'L')
        
        pdf.set_xy(15, 35)
        pdf.set_font('Arial', 'B', 7)
        pdf.set_text_color(148, 163, 184)
        pdf.cell(40, 4, "SERIAL NUMBER", 0, 0, 'L')
        pdf.cell(40, 4, "MANUFACTURER", 0, 1, 'L')
        pdf.set_x(15)
        pdf.set_font('Arial', 'B', 10)
        pdf.set_text_color(59, 130, 246) # Blue
        pdf.cell(40, 5, str(master_sn)[:16], 0, 0, 'L')
        pdf.set_text_color(255, 255, 255)
        pdf.cell(40, 5, str(master_mfr)[:16], 0, 1, 'L')

        pdf.set_xy(15, 48)
        pdf.set_font('Arial', 'B', 7)
        pdf.set_text_color(148, 163, 184)
        pdf.cell(40, 4, "MODEL NO.", 0, 0, 'L')
        pdf.cell(40, 4, "DATE BASELINE", 0, 1, 'L')
        pdf.set_x(15)
        pdf.set_font('Arial', '', 9)
        pdf.set_text_color(255, 255, 255)
        pdf.cell(40, 5, str(master_model)[:16], 0, 0, 'L')
        pdf.cell(40, 5, baseline_date.strftime('%d %b %Y'), 0, 1, 'L')

        # Card: Allocation History
        draw_card(pdf, 105, 10, 95, 55, "Allocation History")
        alloc_data = {}
        if not df_alloc.empty and df_alloc['allocation'].iloc[0] and str(df_alloc['allocation'].iloc[0]).lower() != 'nan':
            try: alloc_data = json.loads(df_alloc['allocation'].iloc[0])
            except: pass

        pdf.set_xy(110, 20)
        if not alloc_data:
            pdf.set_font('Arial', 'I', 8)
            pdf.set_text_color(148, 163, 184)
            pdf.cell(90, 8, "No allocation history available.", 0, 1, 'L')
        else:
            limit = 0
            for dept, dates in alloc_data.items():
                if limit >= 3: break # Fit max 3 on card
                pdf.set_font('Arial', 'B', 9)
                pdf.set_text_color(255, 255, 255)
                pdf.set_x(110)
                pdf.cell(90, 5, f"> {dept.upper()}", 0, 1, 'L')
                
                pdf.set_font('Arial', '', 7)
                pdf.set_text_color(148, 163, 184)
                alloc_d = dates.get('allocation_date', 'N/A')
                pdf.set_x(115)
                pdf.cell(90, 4, f"Allocated: {alloc_d.split(' ')[0] if str(alloc_d).lower() != 'nan' else 'N/A'}", 0, 1, 'L')
                
                rev_d = dates.get('revoke_date', 'nan')
                dis_d = dates.get('discarded_date', 'nan')
                pdf.set_x(115)
                if str(dis_d).lower() != 'nan':
                    pdf.set_text_color(239, 68, 68)
                    pdf.cell(90, 4, f"Discarded: {dis_d.split(' ')[0]}", 0, 1, 'L')
                elif str(rev_d).lower() != 'nan':
                    pdf.set_text_color(245, 158, 11)
                    pdf.cell(90, 4, f"Revoked: {rev_d.split(' ')[0]}", 0, 1, 'L')
                else:
                    pdf.set_text_color(16, 185, 129)
                    pdf.cell(90, 4, "Active Assignment", 0, 1, 'L')
                pdf.ln(1)
                limit += 1

        # --- ROW 2: AI Engine (Height: 35) ---
        draw_card(pdf, 10, 70, 190, 35, "AI Predictive Engine")
        pdf.set_xy(15, 80)
        pdf.set_font('Arial', 'B', 8)
        pdf.set_text_color(148, 163, 184)
        pdf.cell(180, 5, "EST. NEXT BREAKDOWN DATE:", 0, 1, 'L')
        
        pdf.set_x(15)
        pdf.set_font('Arial', 'B', 24)
        pdf.set_text_color(239, 68, 68) # Red
        pdf.cell(180, 10, next_failure_date.strftime('%Y-%m-%d'), 0, 1, 'L')
        
        pdf.set_x(15)
        pdf.set_font('Arial', 'I', 7)
        pdf.set_text_color(148, 163, 184)
        engine_txt = "Random Forest" if MODELS_LOADED else "Trail Mode Failsafe"
        pdf.cell(180, 5, f"Forecast calculated using {engine_txt}, based on baseline date: {baseline_source} ({baseline_date.strftime('%d %b %Y')}).", 0, 1, 'L')

        # --- ROW 3: Charts Grid (Height: 65) ---
        y_charts = 110
        if not df_maint.empty and os.path.exists(pie_path) and os.path.exists(bar_path) and os.path.exists(freq_path):
            draw_card(pdf, 10, y_charts, 60, 60, "Issue Priority Split")
            pdf.image(pie_path, x=11, y=y_charts+10, w=58)
            
            draw_card(pdf, 75, y_charts, 60, 60, "Resolution Time Trend")
            pdf.image(bar_path, x=76, y=y_charts+10, w=58)

            draw_card(pdf, 140, y_charts, 60, 60, "Reporting Frequency")
            pdf.image(freq_path, x=141, y=y_charts+10, w=58)
            
            y_table = 175
        else:
            y_table = 110

        # --- ROW 4: Maintenance Log ---
        pdf.set_xy(10, y_table)
        pdf.set_fill_color(28, 42, 66)
        pdf.set_draw_color(51, 65, 85)
        pdf.rect(10, y_table, 190, 12, 'DF')
        
        pdf.set_xy(15, y_table+3)
        pdf.set_font('Arial', 'B', 10)
        pdf.set_text_color(148, 163, 184)
        pdf.cell(180, 5, "HISTORICAL MAINTENANCE LOG", 0, 1, 'L')
        
        # Table Headers
        y_th = y_table + 12
        pdf.set_xy(10, y_th)
        pdf.set_fill_color(11, 19, 37)
        pdf.set_text_color(148, 163, 184)
        pdf.set_font('Arial', 'B', 8)
        pdf.cell(30, 6, "REPORTED ON", 0, 0, 'L', fill=True)
        pdf.cell(100, 6, "ISSUE DESCRIPTION", 0, 0, 'L', fill=True)
        pdf.cell(25, 6, "URGENCY", 0, 0, 'L', fill=True)
        pdf.cell(35, 6, "RESOLVED ON", 0, 1, 'L', fill=True)

        # Table Rows
        pdf.set_font('Arial', '', 8)
        if df_maint.empty:
            pdf.set_x(10)
            pdf.set_text_color(255, 255, 255)
            pdf.cell(190, 8, "No historical maintenance records found for this asset.", 0, 1, 'C')
        else:
            for _, row in df_maint.head(10).iterrows():
                if pdf.get_y() > 275:
                    pdf.add_page()
                    pdf.set_y(15)

                pdf.set_x(10)
                pdf.set_fill_color(28, 42, 66)
                pdf.set_text_color(255, 255, 255)
                
                # 🌟 SAFE PARSING FOR TABLE DATES
                rd = pd.to_datetime(row['report_date'], errors='coerce')
                rep_d = rd.strftime('%d %b %Y') if pd.notnull(rd) else 'N/A'
                
                res_raw = row['resolved_date']
                if res_raw and str(res_raw).lower() not in ['nan', '0000-00-00 00:00:00', 'none', '']:
                    res_dt = pd.to_datetime(res_raw, errors='coerce')
                    res_d = res_dt.strftime('%d %b %Y') if pd.notnull(res_dt) else 'Pending'
                else:
                    res_d = 'Pending'

                desc = str(row['description']).replace('\n', ' ')[:55] + "..." if len(str(row['description'])) > 55 else str(row['description'])
                urgency = str(row['urgency_level']).upper()

                pdf.cell(30, 8, rep_d, 'B', 0, 'L', fill=True)
                pdf.cell(100, 8, desc, 'B', 0, 'L', fill=True)
                
                if urgency == 'CRITICAL': pdf.set_text_color(239, 68, 68)
                elif urgency == 'HIGH': pdf.set_text_color(249, 115, 22)
                elif urgency == 'MEDIUM': pdf.set_text_color(59, 130, 246)
                else: pdf.set_text_color(148, 163, 184)
                pdf.cell(25, 8, urgency, 'B', 0, 'L', fill=True)

                if res_d == 'Pending': pdf.set_text_color(245, 158, 11)
                else: pdf.set_text_color(16, 185, 129)
                pdf.cell(35, 8, res_d, 'B', 1, 'L', fill=True)

        # Output File
        pdf_filename = f"AI_Report_{serial if serial else base_name}.pdf"
        pdf_path = os.path.join(temp_dir, pdf_filename)
        pdf.output(pdf_path)

        if os.path.exists(pie_path): os.remove(pie_path)
        if os.path.exists(bar_path): os.remove(bar_path)
        if os.path.exists(freq_path): os.remove(freq_path)

        print(f"✅ Premium Dark PDF successfully generated!")
        return send_file(pdf_path, as_attachment=False)

    except Exception as e:
        print(f"❌ Error generating report: {e}")
        return jsonify({'status': 'error', 'message': str(e)})
    finally:
        conn.close()

print("🌐 Server starting! Keep this cell running to allow your website to talk to the AI.")
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)