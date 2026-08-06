<?php
error_reporting(0);
// SET TIMEZONE TO INDIAN STANDARD TIME
date_default_timezone_set('Asia/Kolkata');
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
        // STEP A: Archive the item metadata first (Rule 3)
        $archive_sql = "INSERT INTO discarded_items (item_id, item_name, item_model, item_manufacturer, serial_number, discarded_from_dept, original_added_date)
                        SELECT item_id, item_name, item_model, item_manufacturer, serial_number, '$dept_id', date_added 
                        FROM item_table WHERE item_id = '$item_id'";
        if (!$conn->query($archive_sql)) throw new Exception("Failed to archive item details.");

        // STEP B: Update active assignment if it is assigned (Rule 1)
        if ($dept_id !== 'NAN') {
            $update_history = "UPDATE item_assigneds 
                               SET discarded_date = '$now' 
                               WHERE item_id = '$item_id' AND date_revoked = 'nan'";
            if (!$conn->query($update_history)) throw new Exception("Failed to update assignment discarded date.");
        }

        // STEP C: Record Dates in Asset History JSON (Rules 1 & 2)
        $hist_res = $conn->query("SELECT allocation FROM asset_history WHERE item_id = '$item_id'");
        if ($hist_res && $hist_res->num_rows > 0) {
            $hist_row = $hist_res->fetch_assoc();
            $allocation = json_decode($hist_row['allocation'], true) ?: [];
            
            if ($dept_id !== 'NAN') {
                // Rule 1: Assigned item discard logic
                if (isset($allocation[$dept_id])) {
                    unset($allocation[$dept_id]['revoke_date']); 
                    $allocation[$dept_id]['discarded_date'] = $now; 
                } else {
                    $allocation[$dept_id] = [
                        'allocation_date' => 'nan',
                        'discarded_date' => $now
                    ];
                }
            } else {
                // Rule 2: Unassigned item discard logic
                $allocation['NAN'] = [
                    'allocation_date' => 'nan',
                    'discarded_date' => $now
                ];
            }
            
            $new_alloc_json = $conn->real_escape_string(json_encode($allocation));
            
            $update_hist = "UPDATE asset_history SET allocation = '$new_alloc_json' WHERE item_id = '$item_id'";
            if (!$conn->query($update_hist)) {
                throw new Exception("Failed to update asset_history for Item: $item_id");
            }
        }

        // STEP D: Delete from master inventory (Bypass FK checks so assigned history is preserved)
        $conn->query("SET FOREIGN_KEY_CHECKS = 0");
        $delete_sql = "DELETE FROM item_table WHERE item_id = '$item_id'";
        if (!$conn->query($delete_sql)) throw new Exception("Database constraint prevented deletion.");
        $conn->query("SET FOREIGN_KEY_CHECKS = 1");

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Item permanently removed and history archived.']);
    } catch (Exception $e) {
        $conn->rollback();
        // Failsafe to ensure checks are re-enabled even if an error occurs mid-transaction
        $conn->query("SET FOREIGN_KEY_CHECKS = 1"); 
        echo json_encode(['status' => 'error', 'message' => 'Operation failed: ' . $e->getMessage()]);
    }
}

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action requested.']);
}

$conn->close();
?>