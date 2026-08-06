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

    if (empty($admin_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Admin ID missing.']);
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
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin user not found.']);
        exit;
    }

    // Fetch all users
    $sql = "SELECT user_id, user_name, user_mail, user_role, date_created, dept_id FROM user_dataset ORDER BY date_created DESC";
    $result = $conn->query($sql);

    $users = [];
    if ($result && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // Simplify role for frontend
            $roleData = json_decode($row['user_role'], true);
            $row['primary_role'] = (isset($roleData['admin']) && ($roleData['admin'] == '1' || $roleData['admin'] == 1)) ? 'Admin' : 'Standard User';
            $users[] = $row;
        }
    }

    echo json_encode([
        'status' => 'success',
        'data' => $users
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>