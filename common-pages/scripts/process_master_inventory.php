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

// --- 1. Fetch Item Details & History ---
if ($action === 'get_details') {
    $item_id = $conn->real_escape_string($_POST['item_id'] ?? '');

    if (empty($item_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Item ID missing.']);
        exit;
    }

    // Try to fetch the extended history from the asset_history table
    $history_sql = "SELECT date_purchased, allocation FROM asset_history WHERE item_id = '$item_id'";
    $history_res = $conn->query($history_sql);
    
    $response_data = [
        'date_purchased' => 'nan',
        'allocation' => '{}'
    ];

    if ($history_res && $history_res->num_rows > 0) {
        $h_row = $history_res->fetch_assoc();
        $response_data['date_purchased'] = $h_row['date_purchased'] ?: 'nan';
        $response_data['allocation'] = $h_row['allocation'] ?: '{}';
    } else {
        // Fallback: Create a mock JSON representation if no history exists in asset_history yet.
        // We look at item_assigneds to see if there is an active allocation.
        $assign_sql = "SELECT d.dept_name, ia.date_assigned 
                       FROM item_assigneds ia 
                       JOIN departments d ON ia.dept_id = d.dept_id 
                       WHERE ia.item_id = '$item_id' AND ia.date_revoked = 'nan' LIMIT 1";
        $assign_res = $conn->query($assign_sql);
        
        if ($assign_res && $assign_res->num_rows > 0) {
            $a_row = $assign_res->fetch_assoc();
            $dept_name = $a_row['dept_name'];
            $date_assigned = $a_row['date_assigned'];
            $response_data['allocation'] = json_encode([
                $dept_name => [
                    "allocation_date" => $date_assigned,
                    "revoke_date" => "nan"
                ]
            ]);
        }
    }

    echo json_encode(['status' => 'success', 'data' => $response_data]);
}

// --- 2. Edit Item Details ---
elseif ($action === 'edit_item') {
    $admin_id = $conn->real_escape_string($_POST['admin_id'] ?? '');
    
    // Security Check: Verify admin
    $admin_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
    $admin_result = $conn->query($admin_check_sql);
    
    if ($admin_result && $admin_result->num_rows > 0) {
        $roles = json_decode($admin_result->fetch_assoc()['user_role'], true);
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied: Admin privileges required.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Authorization failed.']);
        exit;
    }

    // Get Data
    $item_id = $conn->real_escape_string($_POST['item_id'] ?? '');
    $item_name = $conn->real_escape_string($_POST['item_name'] ?? '');
    $item_model = $conn->real_escape_string($_POST['item_model'] ?? '');
    $item_mfr = $conn->real_escape_string($_POST['item_manufacturer'] ?? '');
    $serial_number = $conn->real_escape_string($_POST['serial_number'] ?? '');
    $allocation_json = trim($_POST['allocation_json'] ?? '');

    if (empty($item_id) || empty($item_name) || empty($serial_number)) {
        echo json_encode(['status' => 'error', 'message' => 'Core item details are required.']);
        exit;
    }

    $conn->begin_transaction();

    try {
        // 1. Update Master Table
        $update_sql = "UPDATE item_table SET 
                       item_name = '$item_name', 
                       item_model = '$item_model', 
                       item_manufacturer = '$item_mfr', 
                       serial_number = '$serial_number' 
                       WHERE item_id = '$item_id'";
        if (!$conn->query($update_sql)) {
            throw new Exception("Failed to update item_table: " . $conn->error);
        }

        // 2. Update asset_history JSON if valid JSON is provided
        if (!empty($allocation_json)) {
            // Simple validation to ensure it's JSON
            json_decode($allocation_json);
            if (json_last_error() === JSON_ERROR_NONE) {
                $safe_json = $conn->real_escape_string($allocation_json);
                
                // UPSERT the history table
                $hist_sql = "INSERT INTO asset_history (item_id, item_name, allocation) 
                             VALUES ('$item_id', '$item_name', '$safe_json')
                             ON DUPLICATE KEY UPDATE 
                             item_name = VALUES(item_name),
                             allocation = VALUES(allocation)";
                
                if (!$conn->query($hist_sql)) {
                     throw new Exception("Failed to update JSON history: " . $conn->error);
                }
            } else {
                 throw new Exception("Invalid JSON format provided.");
            }
        } else {
            // Update name in history table just in case it was changed
            $conn->query("UPDATE asset_history SET item_name = '$item_name' WHERE item_id = '$item_id'");
        }

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Item and history updated successfully.']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action.']);
}

$conn->close();
?>