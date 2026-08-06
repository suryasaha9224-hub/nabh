<?php
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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $serial = $conn->real_escape_string(trim($_POST['serial_number'] ?? ''));

    if (empty($serial)) {
        echo json_encode(['status' => 'error', 'message' => 'Serial number is missing.']);
        exit;
    }

    $asset_data = [];

    // 1. Fetch Master Inventory Data
    $master_sql = "SELECT * FROM item_table WHERE serial_number = '$serial' LIMIT 1";
    $master_res = $conn->query($master_sql);
    if ($master_res && $master_res->num_rows > 0) {
        $asset_data['master'] = $master_res->fetch_assoc();
        $item_id = $asset_data['master']['item_id'];
        
        // 2. Fetch Active Assignment
        $assign_sql = "SELECT ia.date_assigned, d.dept_name, d.dept_id 
                       FROM item_assigneds ia 
                       LEFT JOIN departments d ON ia.dept_id = d.dept_id 
                       WHERE ia.item_id = '$item_id' AND ia.date_revoked = 'nan' LIMIT 1";
        $assign_res = $conn->query($assign_sql);
        $asset_data['assignment'] = ($assign_res && $assign_res->num_rows > 0) ? $assign_res->fetch_assoc() : null;

        // 3. Fetch Purchase Info
        $purchase_sql = "SELECT date_purchased, user_id as purchaser_id FROM purchased_items WHERE serial_number = '$serial' LIMIT 1";
        $purchase_res = $conn->query($purchase_sql);
        $asset_data['purchase'] = ($purchase_res && $purchase_res->num_rows > 0) ? $purchase_res->fetch_assoc() : null;

        // 4. Fetch Asset History JSON
        $history_sql = "SELECT allocation FROM asset_history WHERE item_id = '$item_id' LIMIT 1";
        $history_res = $conn->query($history_sql);
        $asset_data['history'] = ($history_res && $history_res->num_rows > 0) ? $history_res->fetch_assoc()['allocation'] : '{}';

    } else {
        echo json_encode(['status' => 'error', 'message' => 'Asset not found in the master inventory.']);
        exit;
    }

    $item_name = $conn->real_escape_string($asset_data['master']['item_name'] ?? '');

    // 5. Fetch Maintenance Ticket History
    $reports_sql = "SELECT * FROM asset_report WHERE asset_name = '$item_name' OR asset_name LIKE '%$serial%' ORDER BY report_date DESC";
    $reports_res = $conn->query($reports_sql);
    $asset_data['maintenance_reports'] = [];
    if ($reports_res && $reports_res->num_rows > 0) {
        while ($row = $reports_res->fetch_assoc()) {
            $asset_data['maintenance_reports'][] = $row;
        }
    }

    echo json_encode([
        'status' => 'success',
        'data' => $asset_data
    ]);

} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>