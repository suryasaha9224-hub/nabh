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

    if (empty($admin_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Admin ID is missing.']);
        exit;
    }

    // Security Check: Verify admin privileges
    $user_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $user_result = $conn->query($user_check_sql);
    
    if ($user_result && $user_result->num_rows > 0) {
        $roles = json_decode($user_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied: Admin role required.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin authorization failed.']);
        exit;
    }

    // Fetch ALL items from item_table, and join with item_assigneds if currently assigned
    // We also join departments to get the real department name instead of just the ID
    $sql = "SELECT 
                it.item_id, 
                it.item_name, 
                it.item_model, 
                it.item_manufacturer, 
                it.serial_number, 
                it.date_added,
                ia.assign_id, 
                ia.dept_id, 
                ia.date_assigned,
                d.dept_name
            FROM item_table it
            LEFT JOIN item_assigneds ia ON it.item_id = ia.item_id AND ia.date_revoked = 'nan'
            LEFT JOIN departments d ON ia.dept_id = d.dept_id
            ORDER BY it.item_id DESC";
            
    $result = $conn->query($sql);
    
    $items = [];
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $items[] = $row;
        }
    }

    echo json_encode([
        'status' => 'success',
        'data' => $items
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>