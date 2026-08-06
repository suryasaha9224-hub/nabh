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

$action = $_POST['action'] ?? '';

// 1. Fetch Departments
if ($action === 'fetch_depts') {
    $sql = "SELECT dept_id, dept_name FROM departments ORDER BY dept_name ASC";
    $result = $conn->query($sql);
    $data = [];
    while($row = $result->fetch_assoc()) { $data[] = $row; }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// 2. Fetch UNASSIGNED items (Items where current record is revoked or never assigned)
elseif ($action === 'fetch_unassigned') {
    $sql = "SELECT * FROM item_table 
            WHERE item_id NOT IN (
                SELECT item_id FROM item_assigneds 
                WHERE date_revoked = 'nan'
            )
            ORDER BY item_name ASC";
            
    $result = $conn->query($sql);
    $data = [];
    while($row = $result->fetch_assoc()) { $data[] = $row; }
    echo json_encode(['status' => 'success', 'data' => $data]);
}

// 3. Process Bulk Assignment
elseif ($action === 'assign_bulk') {
    $item_ids = json_decode($_POST['item_ids'] ?? '[]', true);
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? '');

    if (empty($item_ids) || empty($dept_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid parameters. Dept ID: ' . $dept_id . ' Items: ' . count($item_ids)]);
        exit;
    }

    $conn->begin_transaction();
    try {
        foreach ($item_ids as $id) {
            $id_clean = $conn->real_escape_string($id);
            // Double check availability inside loop
            $check = $conn->query("SELECT assign_id FROM item_assigneds WHERE item_id = '$id_clean' AND date_revoked = 'nan'");
            if ($check->num_rows > 0) continue; 

            $sql = "INSERT INTO item_assigneds (item_id, dept_id, date_assigned, date_revoked) 
                    VALUES ('$id_clean', '$dept_id', NOW(), 'nan')";
            $conn->query($sql);
        }
        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Assignment completed successfully!']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Database failure: ' . $e->getMessage()]);
    }
} 

else {
    echo json_encode(['status' => 'error', 'message' => "Invalid action requested: '$action'"]);
}

$conn->close();
?>