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

// --- FETCH DEPARTMENTS ---
if ($action === 'fetch_depts') {
    $res = $conn->query("SELECT dept_id, dept_name FROM departments ORDER BY dept_name ASC");
    $depts = [];
    if ($res && $res->num_rows > 0) {
        while ($row = $res->fetch_assoc()) {
            $depts[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $depts]);
}

// --- FETCH UNASSIGNED ITEMS ---
elseif ($action === 'fetch_unassigned') {
    // Find items that DO NOT have an active assignment (where date_revoked is 'nan')
    $sql = "SELECT i.item_id, i.item_name, i.item_model, i.serial_number, i.item_manufacturer 
            FROM item_table i 
            LEFT JOIN item_assigneds ia ON i.item_id = ia.item_id AND ia.date_revoked = 'nan'
            WHERE ia.item_id IS NULL";
            
    $res = $conn->query($sql);
    $items = [];
    if ($res && $res->num_rows > 0) {
        while ($row = $res->fetch_assoc()) {
            $items[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $items]);
}

// --- BULK ASSIGN ITEMS (UPDATES BOTH TABLES) ---
elseif ($action === 'assign_bulk') {
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? '');
    $item_ids_json = $_POST['item_ids'] ?? '[]';
    
    $item_ids = json_decode($item_ids_json, true);

    if (empty($dept_id) || empty($item_ids) || !is_array($item_ids)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid parameters provided.']);
        exit;
    }

    $date_assigned = date('Y-m-d H:i:s');
    $success_count = 0;
    $error_count = 0;

    $conn->begin_transaction();

    try {
        foreach ($item_ids as $id) {
            $clean_id = $conn->real_escape_string($id);

            // 1. Insert into active item_assigneds table
            $assign_sql = "INSERT INTO item_assigneds (item_id, dept_id, date_assigned, date_revoked) 
                           VALUES ('$clean_id', '$dept_id', '$date_assigned', 'nan')";
            
            if (!$conn->query($assign_sql)) {
                throw new Exception("Failed to update assigned table for Item: $clean_id");
            }

            // 2. Fetch Item Name (needed for history table)
            $item_res = $conn->query("SELECT item_name FROM item_table WHERE item_id = '$clean_id'");
            $item_name = ($item_res && $item_res->num_rows > 0) ? $conn->real_escape_string($item_res->fetch_assoc()['item_name']) : 'Unknown Asset';

            // 3. Fetch existing asset_history to append the JSON
            $hist_check = $conn->query("SELECT allocation FROM asset_history WHERE item_id = '$clean_id'");
            
            $allocation_array = [];
            
            if ($hist_check && $hist_check->num_rows > 0) {
                // Asset history exists, decode current JSON
                $row = $hist_check->fetch_assoc();
                $allocation_array = json_decode($row['allocation'], true) ?: [];
            } else {
                // Asset history doesn't exist, create row first
                $conn->query("INSERT INTO asset_history (item_id, item_name, allocation) VALUES ('$clean_id', '$item_name', '{}')");
            }

            // 4. Inject the new allocation record into the JSON array
            $allocation_array[$dept_id] = [
                "allocation_date" => $date_assigned,
                "revoke_date" => "nan"
            ];
            
            $new_allocation_json = $conn->real_escape_string(json_encode($allocation_array));

            // 5. Update the asset_history table
            $hist_update = "UPDATE asset_history SET allocation = '$new_allocation_json' WHERE item_id = '$clean_id'";
            if (!$conn->query($hist_update)) {
                throw new Exception("Failed to update history JSON for Item: $clean_id");
            }

            $success_count++;
        }
        
        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => "Successfully allocated $success_count item(s) to the department."]);
        
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Transaction failed: ' . $e->getMessage()]);
    }
} 

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action.']);
}

$conn->close();
?>