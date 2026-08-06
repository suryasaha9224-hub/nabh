<?php
// Prevent PHP warnings from breaking the JSON response
error_reporting(0);
header('Content-Type: application/json');

$host = 'localhost';
$db   = 'nabh_pr';
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed.']);
    exit;
}

$stats = [
    'total_assets' => 0,
    'assigned' => 0,
    'pending_tickets' => 0,
    'discarded' => 0,
    'recent_devices' => []
];

// 1. Total Active Assets in Master Inventory
$res = $conn->query("SELECT COUNT(*) as c FROM item_table");
if ($res) $stats['total_assets'] = $res->fetch_assoc()['c'];

// 2. Currently Assigned Assets
$res = $conn->query("SELECT COUNT(*) as c FROM item_assigneds WHERE date_revoked = 'nan'");
if ($res) $stats['assigned'] = $res->fetch_assoc()['c'];

// 3. Pending Maintenance Tickets (Unverified)
$res = $conn->query("SELECT COUNT(*) as c FROM asset_report WHERE checked = 0");
if ($res) $stats['pending_tickets'] = $res->fetch_assoc()['c'];

// 4. Permanently Discarded Assets
$res = $conn->query("SELECT COUNT(*) as c FROM discarded_items");
if ($res) $stats['discarded'] = $res->fetch_assoc()['c'];

// 5. Fetch 4 Recent Devices to populate the Live Dashboard Preview
$sql = "SELECT it.item_name, it.serial_number, d.dept_name,
        (SELECT checked FROM asset_report ar WHERE ar.asset_name LIKE CONCAT('%', it.serial_number, '%') ORDER BY report_date DESC LIMIT 1) as ticket_status
        FROM item_table it
        LEFT JOIN item_assigneds ia ON it.item_id = ia.item_id AND ia.date_revoked = 'nan'
        LEFT JOIN departments d ON ia.dept_id = d.dept_id
        ORDER BY it.date_added DESC LIMIT 4";
        
$res = $conn->query($sql);
if ($res && $res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        $status = 'IN STORE';
        $statusClass = 'status-online'; // Blueish text
        $iconType = 'store';

        if ($row['dept_name']) {
            $status = 'ACTIVE';
            $statusClass = 'status-online';
            $iconType = 'active';
        }

        if ($row['ticket_status'] === '0') {
            $status = 'PENDING VERIFICATION';
            $statusClass = 'status-warning';
            $iconType = 'warning';
        } elseif ($row['ticket_status'] === '1') {
            $status = 'MAINTENANCE';
            $statusClass = 'status-offline'; 
            $iconType = 'offline';
        }

        $stats['recent_devices'][] = [
            'name' => $row['item_name'],
            'serial' => $row['serial_number'],
            'dept' => $row['dept_name'] ? $row['dept_name'] : 'General Store',
            'status' => $status,
            'status_class' => $statusClass,
            'icon_type' => $iconType
        ];
    }
} else {
    // Failsafe Mock Data if DB is empty
    $stats['recent_devices'] = [
        ['name' => 'Ventilator V-102', 'serial' => 'SN-99882', 'dept' => 'DEPT-ICU', 'status' => 'ACTIVE', 'status_class' => 'status-online', 'icon_type' => 'active'],
        ['name' => 'Patient Monitor', 'serial' => 'SN-10293', 'dept' => 'DEPT-ER', 'status' => 'NEEDS VERIFICATION', 'status_class' => 'status-warning', 'icon_type' => 'warning'],
        ['name' => 'ECG Machine', 'serial' => 'SN-88211', 'dept' => 'DEPT-CARD', 'status' => 'MAINTENANCE', 'status_class' => 'status-offline', 'icon_type' => 'offline'],
        ['name' => 'Server Switch', 'serial' => 'SN-75323', 'dept' => 'DEPT-IT', 'status' => 'IN STORE', 'status_class' => 'status-online', 'icon_type' => 'store']
    ];
}

echo json_encode(['status' => 'success', 'data' => $stats]);
$conn->close();
?>