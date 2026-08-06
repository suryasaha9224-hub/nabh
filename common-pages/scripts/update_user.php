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
    
    // User details to update
    $target_user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $user_name = $conn->real_escape_string($_POST['user_name'] ?? '');
    $user_mail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $user_role = $conn->real_escape_string($_POST['user_role'] ?? '');
    
    // Capture the department ID
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? 'nan');

    if (empty($admin_id) || empty($target_user_id) || empty($user_name)) {
        echo json_encode(['status' => 'error', 'message' => 'Required fields are missing.']);
        exit;
    }

    // Security Check: Verify admin performing the action
    $admin_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $admin_result = $conn->query($admin_check_sql);
    
    if ($admin_result && $admin_result->num_rows > 0) {
        $roles = json_decode($admin_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied: You lack admin privileges.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin authorization failed.']);
        exit;
    }

    // FIX: Included dept_id = '$dept_id' in the SQL Update Query
    $sql = "UPDATE user_dataset SET 
            user_name = '$user_name', 
            user_mail = '$user_mail', 
            user_role = '$user_role',
            dept_id = '$dept_id'
            WHERE user_id = '$target_user_id'";
    
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'User profile, roles, and department updated successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>