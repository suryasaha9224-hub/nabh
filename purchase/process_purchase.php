<?php
// Prevent PHP warnings from breaking JSON responses
error_reporting(0);
header('Content-Type: application/json');

// Database configuration
$host = 'localhost';
$db   = 'nabh_pr';
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]);
    exit;
}

$action = $_POST['action'] ?? '';

// 1. Fetch data directly from asset_report where forwarded_date IS NOT NULL
if ($action === 'fetch_forwarded') {
    // Filter out reports that are already approved or disapproved
    $sql = "SELECT * FROM asset_report 
            WHERE forwarded_date IS NOT NULL 
            AND forwarded_date != 'nan'
            AND approved_date = 'nan' 
            AND (disapprove_date = 'nan' OR disapprove_date IS NULL)
            ORDER BY forwarded_date DESC";
            
    $result = $conn->query($sql);
    
    if (!$result) {
        echo json_encode(['status' => 'error', 'message' => 'Query Error: ' . $conn->error]);
        exit;
    }

    $data = [];
    while($row = $result->fetch_assoc()) { 
        $data[] = $row; 
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// 2. Fetch Signed History (Approved & Disapproved Reports)
elseif ($action === 'fetch_history') {
    // Fetch reports that have either been approved OR disapproved
    $sql = "SELECT * FROM asset_report 
            WHERE approved_date != 'nan' OR (disapprove_date != 'nan' AND disapprove_date IS NOT NULL)
            ORDER BY report_id DESC";
            
    $result = $conn->query($sql);
    $data = [];
    if ($result) {
        while($row = $result->fetch_assoc()) { 
            $data[] = $row; 
        }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
}

// 3. Approve Action: Dual Update
elseif ($action === 'approve_report') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');

    if (empty($report_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Ticket ID missing.']);
        exit;
    }

    $now = date('Y-m-d H:i:s');
    $conn->begin_transaction();

    try {
        $conn->query("UPDATE asset_report SET approved_date = '$now', disapprove_date = 'nan' WHERE report_id = '$report_id'");
        $conn->query("UPDATE forwarded_reports SET approved_date = '$now', disapprove_date = 'nan' WHERE report_id = '$report_id'");

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Approval processed and signed.']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Operation failed: ' . $e->getMessage()]);
    }
}

// 4. Disapprove Action: Dual Update
elseif ($action === 'disapprove_report') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');

    if (empty($report_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Ticket ID missing.']);
        exit;
    }

    $now = date('Y-m-d H:i:s');
    $conn->begin_transaction();

    try {
        $conn->query("UPDATE asset_report SET disapprove_date = '$now', approved_date = 'nan' WHERE report_id = '$report_id'");
        $conn->query("UPDATE forwarded_reports SET disapprove_date = '$now', approved_date = 'nan' WHERE report_id = '$report_id'");

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Report disapproved and archived.']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Operation failed: ' . $e->getMessage()]);
    }
}

// 5. Rollback Action (Allowed within 24 hours for both)
elseif ($action === 'rollback_approval') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');

    // Server-side security check for the 24-hour limit on either signature
    $check_sql = "SELECT approved_date, disapprove_date FROM asset_report WHERE report_id = '$report_id'";
    $check_res = $conn->query($check_sql);
    $check = $check_res->fetch_assoc();
    
    if (!$check || ($check['approved_date'] === 'nan' && ($check['disapprove_date'] === 'nan' || $check['disapprove_date'] === null))) {
        echo json_encode(['status' => 'error', 'message' => 'Report not found or already in pending state.']);
        exit;
    }

    // Grab the date that was actually signed to evaluate the 24h window
    $target_date = ($check['approved_date'] !== 'nan') ? $check['approved_date'] : $check['disapprove_date'];
    $signed_time = strtotime($target_date);
    $diff_hours = (time() - $signed_time) / 3600;

    if ($diff_hours > 24) {
        echo json_encode(['status' => 'error', 'message' => 'Rollback forbidden: Signature is older than 24 hours.']);
        exit;
    }

    $conn->begin_transaction();
    try {
        $conn->query("UPDATE asset_report SET approved_date = 'nan', disapprove_date = 'nan' WHERE report_id = '$report_id'");
        $conn->query("UPDATE forwarded_reports SET approved_date = 'nan', disapprove_date = 'nan' WHERE report_id = '$report_id'");
        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Signature rolled back. Ticket returned to Pending.']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Rollback failed.']);
    }
}

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action requested.']);
}

$conn->close();
?>