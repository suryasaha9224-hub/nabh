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
    $admin_id = $conn->real_escape_string($_POST['admin_id'] ?? '');
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $original_user_id = $conn->real_escape_string($_POST['original_user_id'] ?? '');

    if (empty($admin_id) || empty($report_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Required parameters missing.']);
        exit;
    }

    // 1. Record the forward action in the tracking table
    $fwd_sql = "INSERT INTO forwarded_reports (report_id, original_user_id, admin_id) 
                VALUES ('$report_id', '$original_user_id', '$admin_id')";
    
    // 2. Update the main report table with the forwarded timestamp
    $report_update_sql = "UPDATE asset_report SET forwarded_date = NOW() WHERE report_id = '$report_id'";
    
    // Execute both queries
    if ($conn->query($fwd_sql) && $conn->query($report_update_sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Report forwarded and timeline updated!']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>