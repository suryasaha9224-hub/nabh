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

$user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

if (empty($user_id)) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is missing. Authorization failed.']);
    exit;
}

// Use a LEFT JOIN to pull forwarded_by_user_id from the forwarded_items table,
// since it conceptually does not exist in the purchased_items table.
$sql = "SELECT p.*, f.forwarded_by_user_id 
        FROM purchased_items p
        LEFT JOIN forwarded_items f ON p.serial_number = f.serial_number
        ORDER BY p.date_purchased DESC";
        
$result = $conn->query($sql);
$data = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode(['status' => 'success', 'data' => $data]);
$conn->close();
?>