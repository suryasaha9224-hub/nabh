<?php
error_reporting(0);
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
$admin_id = $_POST['admin_id'] ?? '';

if (empty($admin_id)) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized Access. Admin ID missing.']);
    exit;
}

// --- 1. FETCH FORWARDED ITEMS ---
if ($action === 'fetch') {
    // Join with purchased_items to get the manufacturer and original purchase date
    $sql = "SELECT f.serial_number, f.item_name, f.item_model, f.date_forwarded, f.forwarded_by_user_id, p.item_manufacturer, p.date_purchased 
            FROM forwarded_items f
            LEFT JOIN purchased_items p ON f.serial_number = p.serial_number
            ORDER BY f.date_forwarded DESC";
            
    $result = $conn->query($sql);
    $data = [];
    
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
}

// --- 2. MOVE TO STORE (SINGLE OR BULK) ---
elseif ($action === 'move_to_store') {
    $serials_json = $_POST['serials'] ?? '[]';
    $serials = json_decode($serials_json, true);
    
    if (empty($serials) || !is_array($serials)) {
        echo json_encode(['status' => 'error', 'message' => 'No items selected to move.']);
        exit;
    }

    $conn->begin_transaction();
    $success_count = 0;
    $error_count = 0;
    $now = date('Y-m-d H:i:s');

    try {
        foreach ($serials as $sn) {
            $safe_sn = $conn->real_escape_string($sn);
            
            // Check if it somehow already exists in item_table to prevent duplicates
            $check = $conn->query("SELECT item_id FROM item_table WHERE serial_number = '$safe_sn'");
            if ($check && $check->num_rows > 0) {
                $error_count++;
                continue; 
            }

            // Fetch the full metadata for the item before moving it
            $meta_sql = "SELECT f.item_name, f.item_model, p.item_manufacturer, p.date_purchased 
                         FROM forwarded_items f 
                         LEFT JOIN purchased_items p ON f.serial_number = p.serial_number 
                         WHERE f.serial_number = '$safe_sn'";
            $meta_res = $conn->query($meta_sql);
            
            if ($meta_res && $meta_res->num_rows > 0) {
                $row = $meta_res->fetch_assoc();
                $name = $conn->real_escape_string($row['item_name']);
                $model = $conn->real_escape_string($row['item_model']);
                $mfr = $conn->real_escape_string($row['item_manufacturer'] ?? 'Unknown');
                $date_purchased = $conn->real_escape_string($row['date_purchased'] ?? 'nan');

                // A. Insert into Master Inventory (item_table)
                $conn->query("INSERT INTO item_table (item_name, item_model, item_manufacturer, serial_number, date_added) 
                              VALUES ('$name', '$model', '$mfr', '$safe_sn', '$now')");
                $new_item_id = $conn->insert_id;

                // B. Initialize Asset History
                $conn->query("INSERT INTO asset_history (item_id, item_name, date_purchased, date_added_to_inventory, allocation) 
                              VALUES ('$new_item_id', '$name', '$date_purchased', '$now', '{}')");

                // C. Update Purchased Items Log
                $conn->query("UPDATE purchased_items SET date_added_to_inventory = '$now' WHERE serial_number = '$safe_sn'");

                // D. Remove from Pending Forwarded Queue
                $conn->query("DELETE FROM forwarded_items WHERE serial_number = '$safe_sn'");
                
                $success_count++;
            } else {
                $error_count++;
            }
        }
        
        $conn->commit();
        $msg = "Successfully moved $success_count item(s) into the master inventory.";
        if ($error_count > 0) $msg .= " ($error_count skipped).";
        
        echo json_encode(['status' => 'success', 'message' => $msg]);
    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['status' => 'error', 'message' => 'Operation failed: ' . $e->getMessage()]);
    }
}

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action.']);
}

$conn->close();
?>