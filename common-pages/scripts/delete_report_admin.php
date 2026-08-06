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

    if (empty($admin_id) || empty($report_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Required parameters missing.']);
        exit;
    }

    // Security Check: Verify that the person requesting the delete is actually an Admin
    $user_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $user_result = $conn->query($user_check_sql);
    
    if ($user_result && $user_result->num_rows > 0) {
        $roles = json_decode($user_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied. Administrator privileges required.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin authorization failed.']);
        exit;
    }

    // Delete the report from the main asset_reports table
    $sql = "DELETE FROM asset_report WHERE report_id = '$report_id'";
    
    if ($conn->query($sql)) {
        if ($conn->affected_rows > 0) {
            // Optional cleanup: Also delete it from forwarded_reports if it was forwarded
            $conn->query("DELETE FROM forwarded_reports WHERE report_id = '$report_id'");
            
            echo json_encode(['status' => 'success', 'message' => 'Report permanently deleted.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Report not found.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>