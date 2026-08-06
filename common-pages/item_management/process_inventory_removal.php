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

// 1. Fetch Master List with Assignment Context
if ($action === 'fetch_removal_list') {
    /**
     * Fetch all items and LEFT JOIN with active assignments only.
     * This allows us to see if an item is "In Store" or assigned.
     */
    $sql = "SELECT it.*, ia.dept_id, d.dept_name, ia.assign_id
            FROM item_table it
            LEFT JOIN item_assigneds ia ON it.item_id = ia.item_id AND ia.date_revoked = 'nan'
            LEFT JOIN departments d ON ia.dept_id = d.dept_id
            ORDER BY it.item_name ASC";
            
    $result = $conn->query($sql);
    $data = [];
    if($result) {
        while($row = $result->fetch_assoc()) { $data[] = $row; }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// 2. Comprehensive Delete Logic
elseif ($action === 'delete_item') {
    $item_id = $conn->real_escape_string($_POST['item_id'] ?? '');
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? 'NAN');

    if (empty($item_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Item ID required.']);
        exit;
    }

    $conn->begin_transaction();
    $now = date('Y-m-d H:i:s');

    try {
        // STEP A: Archive the item metadata first
        $archive_sql = "INSERT INTO discarded_items (item_id, item_name, item_model, item_manufacturer, serial_number, discarded_from_dept, original_added_date)
                        SELECT item_id, item_name, item_model, item_manufacturer, serial_number, '$dept_id', date_added 
                        FROM item_table WHERE item_id = '$item_id'";
        if (!$conn->query($archive_sql)) throw new Exception("Failed to archive item details.");

        // STEP B: Update active assignment (if exists) to preserve history
        // We set both revoked and discarded dates to NOW()
        $update_history = "UPDATE item_assigneds 
                           SET date_revoked = '$now', discarded_date = '$now' 
                           WHERE item_id = '$item_id' AND date_revoked = 'nan'";
        $conn->query($update_history);

        // STEP C: Delete from master inventory
        // (Note: Foreign keys should be ON DELETE SET NULL to preserve history in item_assigneds)
        $delete_sql = "DELETE FROM item_table WHERE item_id = '$item_id'";
        if (!$conn->query($delete_sql)) throw new Exception("Database constraint prevented deletion.");

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Item permanently removed and history archived.']);
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