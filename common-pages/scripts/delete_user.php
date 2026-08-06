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
    $target_user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

    if (empty($admin_id) || empty($target_user_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Required parameters missing.']);
        exit;
    }

    // Prevent admin from accidentally deleting themselves
    if ($admin_id === $target_user_id) {
        echo json_encode(['status' => 'error', 'message' => 'You cannot delete your own admin account.']);
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

    // Delete the user
    $sql = "DELETE FROM user_dataset WHERE user_id = '$target_user_id'";
    
    if ($conn->query($sql)) {
        if ($conn->affected_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => "User '$target_user_id' has been permanently deleted."]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'User not found.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>