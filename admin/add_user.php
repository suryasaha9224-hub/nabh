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
    
    // New user details
    $new_user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $user_name = $conn->real_escape_string($_POST['user_name'] ?? '');
    $user_mail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $user_password = $conn->real_escape_string($_POST['user_password'] ?? '');
    $user_role = $conn->real_escape_string($_POST['user_role'] ?? '');
    $date_created = date('Y-m-d');

    if (empty($admin_id) || empty($new_user_id) || empty($user_name) || empty($user_password)) {
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

    // Check if the new user_id already exists
    $exist_check = "SELECT user_id FROM user_dataset WHERE user_id = '$new_user_id'";
    if ($conn->query($exist_check)->num_rows > 0) {
        echo json_encode(['status' => 'error', 'message' => 'User ID already exists. Choose a unique ID.']);
        exit;
    }

    // Insert the new user
    $sql = "INSERT INTO user_dataset (user_id, user_name, user_mail, user_password, user_role, date_created) 
            VALUES ('$new_user_id', '$user_name', '$user_mail', '$user_password', '$user_role', '$date_created')";
    
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'User created successfully!']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>