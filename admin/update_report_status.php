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
    $admin_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $new_status = $conn->real_escape_string($_POST['new_status'] ?? ''); 

    if (empty($admin_id) || empty($report_id) || empty($new_status)) {
        echo json_encode(['status' => 'error', 'message' => 'Required parameters missing.']);
        exit;
    }

    // Security Check: Verify admin
    $user_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $user_result = $conn->query($user_check_sql);
    
    if ($user_result && $user_result->num_rows > 0) {
        $roles = json_decode($user_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied. Admin privileges required.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin authorization failed.']);
        exit;
    }

    // Determine which date column to update based on the new status
    $date_update = "";
    if ($new_status == '1') {
        // Ticket is being verified
        $date_update = ", verified_date = NOW()";
    } elseif ($new_status == '2') {
        // Ticket is being resolved
        $date_update = ", resolved_date = NOW()";
    }

    // Update the ticket status and the corresponding timestamp
    $sql = "UPDATE asset_report SET checked = '$new_status' $date_update WHERE report_id = '$report_id'";
    
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Status and timeline updated successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>