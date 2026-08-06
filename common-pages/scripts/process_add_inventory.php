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

// --- 1. Fetch Pending Forwarded Items ---
if ($action === 'fetch_forwarded') {
    // Fetch from forwarded_items table where the serial number is NOT already in the main item_table
    // (This ensures we only show items that haven't been added to the master inventory yet)
    $sql = "SELECT f.* FROM forwarded_items f 
            LEFT JOIN item_table it ON f.serial_number = it.serial_number 
            WHERE it.serial_number IS NULL 
            ORDER BY f.id DESC";
            
    $result = $conn->query($sql);
    $data = [];
    
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }
    
    echo json_encode(['status' => 'success', 'data' => $data]);
}

// --- 2. Add Single Item Manually ---
elseif ($action === 'add_manual') {
    $item_name = $conn->real_escape_string($_POST['item_name'] ?? '');
    $item_model = $conn->real_escape_string($_POST['item_model'] ?? '');
    $item_mfr = $conn->real_escape_string($_POST['item_manufacturer'] ?? '');
    $serial_number = $conn->real_escape_string($_POST['serial_number'] ?? '');
    
    if(empty($item_name) || empty($serial_number)) {
        echo json_encode(['status' => 'error', 'message' => 'Item name and serial number are required.']);
        exit;
    }
    
    // Check if serial already exists
    $check = $conn->query("SELECT item_id FROM item_table WHERE serial_number = '$serial_number'");
    if($check && $check->num_rows > 0) {
        echo json_encode(['status' => 'error', 'message' => 'An item with this Serial Number already exists!']);
        exit;
    }

    $conn->begin_transaction();
    $now = date('Y-m-d H:i:s');

    try {
        // 1. Insert into item_table
        $insert_sql = "INSERT INTO item_table (item_name, item_model, item_manufacturer, serial_number, date_added) 
                       VALUES ('$item_name', '$item_model', '$item_mfr', '$serial_number', '$now')";
        
        if (!$conn->query($insert_sql)) throw new Exception("Failed to add to master inventory.");
        
        $new_item_id = $conn->insert_id;

        // 2. Initialize in asset_history (Manual adds have no purchase date yet, so we use 'nan')
        $hist_sql = "INSERT INTO asset_history (item_id, item_name, date_purchased, date_added_to_inventory, allocation) 
                     VALUES ('$new_item_id', '$item_name', 'nan', '$now', '{}')";
                     
        if (!$conn->query($hist_sql)) throw new Exception("Failed to initialize asset history.");

        $conn->commit();
        echo json_encode(['status' => 'success', 'message' => 'Item successfully added to inventory.']);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
}

// --- 3. Add Bulk Forwarded Items ---
elseif ($action === 'add_bulk_forwarded') {
    $items_json = $_POST['items'] ?? '[]';
    $items = json_decode($items_json, true);
    
    if (empty($items) || !is_array($items)) {
        echo json_encode(['status' => 'error', 'message' => 'No items selected to import.']);
        exit;
    }

    $conn->begin_transaction();
    $now = date('Y-m-d H:i:s');
    $success_count = 0;
    $skip_count = 0;

    try {
        foreach ($items as $item) {
            $name = $conn->real_escape_string($item['item_name']);
            $model = $conn->real_escape_string($item['item_model']);
            $mfr = $conn->real_escape_string($item['item_manufacturer']);
            $serial = $conn->real_escape_string($item['serial_number']);
            // If the table uses a different column name for the forward/purchase date, adjust it here.
            $purchased_date = $conn->real_escape_string($item['date_forwarded'] ?? $item['purchase_date'] ?? 'nan');

            // Skip if serial already exists in item_table
            $check = $conn->query("SELECT item_id FROM item_table WHERE serial_number = '$serial'");
            if ($check && $check->num_rows > 0) {
                $skip_count++;
                continue; 
            }

            // 1. Insert into item_table
            $insert_sql = "INSERT INTO item_table (item_name, item_model, item_manufacturer, serial_number, date_added) 
                           VALUES ('$name', '$model', '$mfr', '$serial', '$now')";
            if (!$conn->query($insert_sql)) throw new Exception("Insertion failed for SN: $serial");
            
            $new_item_id = $conn->insert_id;

            // 2. Initialize in asset_history (Using the purchase/forward date from the forwarded table)
            $hist_sql = "INSERT INTO asset_history (item_id, item_name, date_purchased, date_added_to_inventory, allocation) 
                         VALUES ('$new_item_id', '$name', '$purchased_date', '$now', '{}')";
            if (!$conn->query($hist_sql)) throw new Exception("History init failed for SN: $serial");

            // Optional: Mark as processed in forwarded_items table (e.g., set status = 1)
            // $conn->query("UPDATE forwarded_items SET status = 1 WHERE serial_number = '$serial'");

            $success_count++;
        }
        
        $conn->commit();
        $msg = "Successfully added $success_count item(s) to inventory.";
        if ($skip_count > 0) $msg .= " ($skip_count skipped due to duplicate Serial Numbers).";
        
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