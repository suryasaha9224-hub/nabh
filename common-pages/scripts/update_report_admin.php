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
    
    // Edit Fields
    $asset_name = $conn->real_escape_string($_POST['asset_name'] ?? '');
    $urgency_level = $conn->real_escape_string($_POST['urgency_level'] ?? '');
    $department = $conn->real_escape_string($_POST['department'] ?? '');
    $floor = $conn->real_escape_string($_POST['floor'] ?? '');
    $parts_required = $conn->real_escape_string($_POST['parts_required'] ?? 'n');
    $checked = $conn->real_escape_string($_POST['checked'] ?? '0');

    if (empty($admin_id) || empty($report_id) || empty($asset_name)) {
        echo json_encode(['status' => 'error', 'message' => 'Required parameters missing.']);
        exit;
    }

    // Security Check: Verify admin
    $user_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $user_result = $conn->query($user_check_sql);
    
    if ($user_result && $user_result->num_rows > 0) {
        $roles = json_decode($user_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied.']);
            exit;
        }
    }

    // Update the entire report
    $sql = "UPDATE asset_report SET 
            asset_name = '$asset_name', 
            urgency_level = '$urgency_level', 
            department = '$department', 
            floor = '$floor', 
            parts_required = '$parts_required', 
            checked = '$checked' 
            WHERE report_id = '$report_id'";
    
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Report fully updated successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>