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
    // Only target the user making the request
    $target_user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $user_name = $conn->real_escape_string($_POST['user_name'] ?? '');
    $user_mail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $user_password = $conn->real_escape_string($_POST['user_password'] ?? '');

    if (empty($target_user_id) || empty($user_name) || empty($user_mail)) {
        echo json_encode(['status' => 'error', 'message' => 'Name and Email are required.']);
        exit;
    }

    // If password is provided, update it. Otherwise, leave it exactly as it is.
    if (!empty($user_password)) {
        $sql = "UPDATE user_dataset SET 
                user_name = '$user_name', 
                user_mail = '$user_mail', 
                user_password = '$user_password' 
                WHERE user_id = '$target_user_id'";
    } else {
        $sql = "UPDATE user_dataset SET 
                user_name = '$user_name', 
                user_mail = '$user_mail' 
                WHERE user_id = '$target_user_id'";
    }
    
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Profile updated successfully!']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>