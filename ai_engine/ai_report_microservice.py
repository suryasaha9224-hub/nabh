import os
import re
import pandas as pd
import mysql.connector
import joblib
from datetime import datetime, timedelta
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import matplotlib
matplotlib.use('Agg') # Crucial to prevent crashes on servers without a display
import matplotlib.pyplot as plt
import seaborn as sns
from fpdf import FPDF
import warnings
warnings.filterwarnings('ignore')

app = Flask(__name__)
CORS(app)

print("==========================================================")
print(" 🚀 STARTING AMAR AI MICROSERVICE")
print("==========================================================")

# --- 1. LOAD MODELS ON STARTUP ---
print("⚙️ Loading ML Models...")
try:
    model_resolution = joblib.load('amar_resolution_model.pkl')
    model_mtbf = joblib.load('amar_mtbf_model.pkl')
    le_asset = joblib.load('le_asset.pkl')
    le_urgency = joblib.load('le_urgency.pkl')
    le_parts = joblib.load('le_parts.pkl')
    print("✅ Models loaded successfully!")
except Exception as e:
    print("❌ Error loading models. Did you run the training script first?", e)

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
    """Strips away '(SN: 1234)' or '(1234)' to get the base category"""
    return re.sub(r'\s*\([^)]*\)', '', str(name)).strip()

def smart_encode(encoder, name, fallback=0):
    """Intelligently matches the asset name to the trained ML categories"""
    clean_name = clean_asset_name(name)
    try:
        return encoder.transform([clean_name])[0]
    except ValueError:
        # Fallback: Try finding a partial match in our trained classes
        for known_item in encoder.classes_:
            if clean_name.lower() in str(known_item).lower() or str(known_item).lower() in clean_name.lower():
                return encoder.transform([known_item])[0]
        return fallback

def safe_encode(encoder, value, fallback=0):
    """Safely encodes basic categorical features like Urgency and Parts"""
    try:
        return encoder.transform([value])[0]
    except ValueError:
        return fallback


# --- 3. API ENDPOINTS ---

@app.route('/get_prediction', methods=['GET'])
def get_prediction():
    """
    Endpoint for the web dashboard.
    Takes an asset name (and optional serial), cleans it, and returns the MTBF and Resolution predictions.
    """
    asset = request.args.get('asset', '')
    serial = request.args.get('serial', '')

    # Combine input as it might be passed from the QR scanner
    user_input = f"{asset} {serial}".strip()
    base_name = clean_asset_name(user_input)

    if not base_name:
        return jsonify({'status': 'error', 'message': 'No asset provided.'})

    conn = get_db_connection()
    try:
        # 1. Fetch historical breakdown data for this specific asset family
        query = f"SELECT MAX(report_date) as last_breakdown FROM asset_report WHERE asset_name LIKE '%{base_name}%'"
        df_hist = pd.read_sql(query, conn)
        
        last_breakdown_raw = df_hist['last_breakdown'].iloc[0]
        
        # 2. Determine Baseline Date (Fallback to TODAY if no history exists)
        if pd.isna(last_breakdown_raw):
            last_breakdown = datetime.now()
        else:
            last_breakdown = pd.to_datetime(last_breakdown_raw)

        # 3. Encode the Asset
        a_enc = smart_encode(le_asset, base_name)
        
        # 4. PREDICT MTBF: When will it break next?
        predicted_days_to_fail = model_mtbf.predict([[a_enc]])[0]
        next_failure_date = last_breakdown + timedelta(days=predicted_days_to_fail)
        
        # 5. PREDICT RESOLUTION TIME: Best vs Worst Case Scenarios
        u_low = safe_encode(le_urgency, 'low')
        p_no = safe_encode(le_parts, 'n')
        
        u_crit = safe_encode(le_urgency, 'critical')
        p_yes = safe_encode(le_parts, 'y')
        
        best_case_hrs = model_resolution.predict([[a_enc, u_low, p_no]])[0]
        worst_case_hrs = model_resolution.predict([[a_enc, u_crit, p_yes]])[0]

        # Log prediction to terminal for monitoring
        print(f"🤖 AI Prediction sent for '{base_name}': Fail Date -> {next_failure_date.strftime('%Y-%m-%d')}")

        return jsonify({
            'status': 'success',
            'asset_analyzed': base_name,
            'predicted_mtbf_days': round(predicted_days_to_fail),
            'next_failure_date': next_failure_date.strftime('%Y-%m-%d'),
            'best_case_hrs': round(best_case_hrs, 1),
            'worst_case_hrs': round(worst_case_hrs, 1)
        })

    except Exception as e:
        print(f"❌ Error during prediction: {e}")
        return jsonify({'status': 'error', 'message': str(e)})
    finally:
        conn.close()


@app.route('/generate_report', methods=['GET'])
def generate_report():
    """
    Endpoint to generate the beautifully formatted PDF report containing AI analytics and charts.
    """
    asset = request.args.get('name', '')
    serial = request.args.get('serial', '')
    
    user_input = f"{asset} {serial}".strip()
    base_name = clean_asset_name(user_input)

    if not base_name:
        return jsonify({'status': 'error', 'message': 'Missing asset parameters'})

    conn = get_db_connection()
    try:
        # Create temp folder dynamically using Absolute Paths (prevents [WinError 3])
        current_dir = os.path.dirname(os.path.abspath(__file__))
        temp_dir = os.path.join(current_dir, 'temp_reports')
        os.makedirs(temp_dir, exist_ok=True)

        print(f"\n🔍 Generating PDF Report for: {base_name.upper()}...")

        # 1. Fetch Maintenance Data (Aggregated by base family name)
        query_maint = f"SELECT * FROM asset_report WHERE asset_name LIKE '%{base_name}%' ORDER BY report_date DESC"
        df_maint = pd.read_sql(query_maint, conn)

        # 2. Get Inventory Data (How many of these do we own?)
        query_inv = f"SELECT * FROM item_table WHERE item_name LIKE '%{base_name}%'"
        df_inv = pd.read_sql(query_inv, conn)
        total_owned = len(df_inv)

        # 3. AI Predictive Models
        a_enc = smart_encode(le_asset, base_name)

        if df_maint.empty:
            latest_breakdown = datetime.now()
        else:
            latest_breakdown = pd.to_datetime(df_maint['report_date'].iloc[0])

        predicted_mtbf_days = model_mtbf.predict([[a_enc]])[0]
        next_failure_date = latest_breakdown + timedelta(days=predicted_mtbf_days)

        u_low = safe_encode(le_urgency, 'low')
        p_no = safe_encode(le_parts, 'n')
        u_crit = safe_encode(le_urgency, 'critical')
        p_yes = safe_encode(le_parts, 'y')

        best_case_hrs = model_resolution.predict([[a_enc, u_low, p_no]])[0]
        worst_case_hrs = model_resolution.predict([[a_enc, u_crit, p_yes]])[0]

        # 4. Generate Visual Charts
        sns.set_theme(style="whitegrid")
        
        pie_path = os.path.join(temp_dir, f"pie_{serial}.png")
        bar_path = os.path.join(temp_dir, f"bar_{serial}.png")

        if not df_maint.empty:
            # Pie Chart
            plt.figure(figsize=(5, 5))
            urgency_counts = df_maint['urgency_level'].value_counts()
            colors = sns.color_palette("pastel")[0:len(urgency_counts)]
            plt.pie(urgency_counts, labels=urgency_counts.index, colors=colors, autopct='%.1f%%', startangle=140)
            plt.title('Historical Priority Breakdown')
            plt.savefig(pie_path, bbox_inches='tight')
            plt.close()

            # Bar Chart
            plt.figure(figsize=(7, 4))
            df_resolved = df_maint[df_maint['resolved_date'].notna() & (df_maint['resolved_date'] != '0000-00-00 00:00:00') & (df_maint['resolved_date'] != 'nan')].copy()
            if not df_resolved.empty:
                df_resolved['report_date'] = pd.to_datetime(df_resolved['report_date'])
                df_resolved['resolved_date'] = pd.to_datetime(df_resolved['resolved_date'])
                df_resolved['resolve_hours'] = (df_resolved['resolved_date'] - df_resolved['report_date']).dt.total_seconds() / 3600
                sns.barplot(x=df_resolved['report_date'].dt.strftime('%b %Y'), y=df_resolved['resolve_hours'], palette="Blues_d")
                plt.title('Resolution Time Trend (Hours)')
                plt.xticks(rotation=45)
            else:
                plt.text(0.5, 0.5, 'No resolved data available.', ha='center', va='center')
            plt.savefig(bar_path, bbox_inches='tight')
            plt.close()
        
        # 5. Compile PDF
        pdf = FPDF()
        pdf.add_page()

        # Header
        pdf.set_font("Arial", 'B', 22)
        pdf.set_text_color(30, 58, 138)
        pdf.cell(0, 15, "AMAR Intelligence Report", ln=True, align='C')
        
        pdf.set_font("Arial", 'I', 10)
        pdf.set_text_color(100, 100, 100)
        pdf.cell(0, 5, f"Asset Target: {base_name.upper()} | Serial/Ref: {serial}", ln=True, align='C')
        pdf.cell(0, 5, f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", ln=True, align='C')
        pdf.ln(10)

        # Section: AI Predictions
        pdf.set_font("Arial", 'B', 14)
        pdf.set_text_color(0, 0, 0)
        pdf.cell(0, 10, "1. Proactive AI Forecasting", ln=True, align='L')
        
        pdf.set_font("Arial", '', 12)
        pdf.cell(0, 8, f"Baseline Date (Last Failure): {latest_breakdown.strftime('%d %b %Y')}", ln=True)
        
        pdf.set_font("Arial", 'B', 12)
        pdf.set_text_color(220, 38, 38) # Red
        pdf.cell(0, 8, f"Predicted Next Failure: {next_failure_date.strftime('%d %b %Y')} (in ~{predicted_mtbf_days:.0f} days)", ln=True)
        
        pdf.set_text_color(0, 0, 0)
        pdf.set_font("Arial", '', 12)
        pdf.cell(0, 8, f"Best-Case Repair Time: {best_case_hrs:.1f} Hours (Routine, no parts)", ln=True)
        pdf.cell(0, 8, f"Worst-Case Repair Time: {worst_case_hrs:.1f} Hours (Critical, parts needed)", ln=True)
        pdf.ln(10)

        # Section: History & Analytics
        pdf.set_font("Arial", 'B', 14)
        pdf.cell(0, 10, "2. Historical Analytics", ln=True, align='L')
        pdf.set_font("Arial", '', 12)
        pdf.cell(0, 8, f"Total Registered in Inventory: {total_owned}", ln=True)
        pdf.cell(0, 8, f"Total Breakdowns Logged for Class: {len(df_maint)}", ln=True)
        pdf.ln(5)

        # Place charts if generated
        if not df_maint.empty and os.path.exists(pie_path) and os.path.exists(bar_path):
            pdf.image(pie_path, x=10, y=pdf.get_y(), w=85)
            pdf.image(bar_path, x=105, y=pdf.get_y(), w=95)

        pdf_filename = f"AI_Report_{serial if serial else base_name}.pdf"
        pdf_path = os.path.join(temp_dir, pdf_filename)
        pdf.output(pdf_path)

        # Clean up images
        if os.path.exists(pie_path): os.remove(pie_path)
        if os.path.exists(bar_path): os.remove(bar_path)

        print(f"✅ Report successfully generated at: {pdf_path}")
        
        # Send the file back to the browser
        return send_file(pdf_path, as_attachment=False)

    except Exception as e:
        print(f"❌ Error generating report: {e}")
        return jsonify({'status': 'error', 'message': str(e)})
    finally:
        conn.close()


if __name__ == '__main__':
    print("✅ AMAR API is actively listening for frontend requests...")
    app.run(debug=True, port=5000)