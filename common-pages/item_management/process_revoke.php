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

// 1. Fetch Assignments
if ($action === 'fetch_active') {
    $sql = "SELECT ia.assign_id, ia.item_id, ia.dept_id, ia.date_assigned, it.item_name, it.item_model, it.item_manufacturer, it.serial_number, d.dept_name
            FROM item_assigneds ia
            JOIN item_table it ON ia.item_id = it.item_id
            JOIN departments d ON ia.dept_id = d.dept_id
            WHERE ia.date_revoked = 'nan'
            ORDER BY ia.date_assigned DESC";
    $result = $conn->query($sql);
    $data = [];
    if($result) {
        while($row = $result->fetch_assoc()) { $data[] = $row; }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// 2. Bulk Actions (Handles both Revoke and Discard in batch)
elseif ($action === 'revoke_bulk' || $action === 'discard_bulk') {
    $batch_data = json_decode($_POST['batch_data'] ?? '[]', true);
    
    if (empty($batch_data)) {
        echo json_encode(['status' => 'error', 'message' => 'No items selected for operation.']);
        exit;
    }

    $conn->begin_transaction();
    $success = 0;
    $now = date('Y-m-d H:i:s');

    try {
        foreach ($batch_data as $row) {
            $assign_id = $conn->real_escape_string($row['assign_id']);
            $item_id = $conn->real_escape_string($row['item_id']);
            $dept_id = $conn->real_escape_string($row['dept_id']);

            if ($action === 'revoke_bulk') {
                // JUST REVOKE: Item goes back to store
                $conn->query("UPDATE item_assigneds SET date_revoked = '$now' WHERE assign_id = '$assign_id'");
            } 
            elseif ($action === 'discard_bulk') {
                // DISCARD: Update both revoked date AND discarded date in history
                $conn->query("UPDATE item_assigneds SET date_revoked = '$now', discarded_date = '$now' WHERE assign_id = '$assign_id'");

                // Archive into discarded_items table
                $archive = "INSERT INTO discarded_items (item_id, item_name, item_model, item_manufacturer, serial_number, discarded_from_dept, original_added_date)
                            SELECT item_id, item_name, item_model, item_manufacturer, serial_number, '$dept_id', date_added 
                            FROM item_table WHERE item_id = '$item_id'";
                $conn->query($archive);

                // Delete from master inventory
                $conn->query("DELETE FROM item_table WHERE item_id = '$item_id'");
            }
            $success++;
        }
        
        $conn->commit();
        $msg = ($action === 'revoke_bulk') ? "Successfully revoked $success item(s)." : "Successfully discarded $success item(s). History updated.";
        echo json_encode(['status' => 'success', 'message' => $msg]);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Operation failed: ' . $e->getMessage()]);
    }
}

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action requested.']);
}

$conn->close();
?>