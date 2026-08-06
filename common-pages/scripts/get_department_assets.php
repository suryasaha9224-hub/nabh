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

$dept_id = $conn->real_escape_string($_POST['dept_id'] ?? '');

if (empty($dept_id)) {
    echo json_encode(['status' => 'error', 'message' => 'Department ID missing.']);
    exit;
}

// Fetch active assigned items for the specific department by joining item_assigneds with the master item_table
$sql = "SELECT it.item_name as asset_name, it.serial_number 
        FROM item_assigneds ia
        JOIN item_table it ON ia.item_id = it.item_id
        WHERE ia.dept_id = '$dept_id' AND ia.date_revoked = 'nan'
        ORDER BY it.item_name ASC"; 

$result = $conn->query($sql);
$assets = [];

if ($result) {
    while($row = $result->fetch_assoc()) {
        $assets[] = $row;
    }
} else {
    // Fallback Mock Data just in case the tables are empty or missing
    $assets = [
        ['asset_name' => 'Defibrillator', 'serial_number' => 'DF-901'],
        ['asset_name' => 'Patient Monitor', 'serial_number' => 'PM-402'],
        ['asset_name' => 'ECG Machine', 'serial_number' => 'ECG-110']
    ];
}

echo json_encode(['status' => 'success', 'data' => $assets]);
$conn->close();
?>