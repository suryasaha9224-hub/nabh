<?php
// Prevent stray text/warnings from breaking the JSON response
ob_start();
error_reporting(E_ALL);
ini_set('display_errors', 0); 
header('Content-Type: application/json');

try {
    $host = 'localhost';
    $db   = 'nabh_pr';
    $user = 'root';
    $pass = '';

    $conn = new mysqli($host, $user, $pass, $db);

    if ($conn->connect_error) {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]);
        exit;
    }

    $action = $_POST['action'] ?? '';
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    
    if (empty($user_id)) {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'Authorization failed. User ID missing.']);
        exit;
    }

    // --- 1. EDIT PURCHASED ITEM ---
    if ($action === 'edit') {

        $orig_sn = $conn->real_escape_string($_POST['original_serial_number'] ?? '');
        $new_sn = $conn->real_escape_string($_POST['serial_number'] ?? '');
        $name = $conn->real_escape_string($_POST['item_name'] ?? '');
        $model = $conn->real_escape_string($_POST['item_model'] ?? '');
        $manu = $conn->real_escape_string($_POST['item_manufacturer'] ?? '');
        $date_purchased = $conn->real_escape_string($_POST['date_purchased'] ?? '');

        if(empty($sn) || empty($name)) { 
            ob_clean(); 
            echo json_encode(['status'=>'error', 'message'=>'Serial Number and Item Name are mandatory.']); 
            exit; 
        }

// Update the master purchased_items table
        $sql1 = "UPDATE purchased_items 
                SET serial_number='$new_sn', item_name='$name', item_model='$model', item_manufacturer='$manu', date_purchased='$date_purchased' 
                WHERE serial_number='$orig_sn'";

// Keep the forwarded_items table in sync if it exists there
        $sql2 = "UPDATE forwarded_items 
                SET serial_number='$new_sn', item_name='$name', item_model='$model' 
                WHERE serial_number='$orig_sn'";

        if($conn->query($sql1)) {
            $conn->query($sql2); 
            ob_clean();
            echo json_encode(['status' => 'success', 'message' => 'Purchase details updated successfully.']);
        } else {
            throw new Exception($conn->error);
        }
    }
    
    // --- 2. DELETE PURCHASED ITEM ---
    elseif ($action === 'delete') {
        $sn = $conn->real_escape_string($_POST['serial_number'] ?? '');
        if(empty($sn)) { 
            ob_clean(); 
            echo json_encode(['status'=>'error', 'message'=>'Serial Number missing.']); 
            exit; 
        }

        $sql1 = "DELETE FROM purchased_items WHERE serial_number='$sn'";
        $sql2 = "DELETE FROM forwarded_items WHERE serial_number='$sn'";

        $conn->query($sql2); // Explicitly delete dependent table first to prevent constraints
        if($conn->query($sql1)) {
            ob_clean();
            echo json_encode(['status' => 'success', 'message' => 'Purchased item permanently deleted.']);
        } else {
            throw new Exception($conn->error);
        }
    }
    
    // --- 3. ROLLBACK FORWARD (24H Limit) ---
    elseif ($action === 'rollback') {
        $sn = $conn->real_escape_string($_POST['serial_number'] ?? '');
        if(empty($sn)) { 
            ob_clean(); 
            echo json_encode(['status'=>'error', 'message'=>'Serial Number missing.']); 
            exit; 
        }

        // Check exact timestamp in the forwarded_items table
        $check = $conn->query("SELECT date_forwarded FROM forwarded_items WHERE serial_number='$sn'");
        
        if ($check && $check->num_rows > 0) {
            $row = $check->fetch_assoc();
            $fwd_time = strtotime($row['date_forwarded']);
            $diff_hours = (time() - $fwd_time) / 3600;

            if ($diff_hours <= 24) {
                // Delete from forwarded items queue
                $conn->query("DELETE FROM forwarded_items WHERE serial_number='$sn'");
                // Reset the master flags on purchased_items (both forward & inventory dates)
                $conn->query("UPDATE purchased_items SET date_forwarded='nan', date_added_to_inventory='nan' WHERE serial_number='$sn'");
                
                ob_clean();
                echo json_encode(['status' => 'success', 'message' => 'Forward rolled back. Item returned to pending queue.']);
            } else {
                ob_clean();
                echo json_encode(['status' => 'error', 'message' => 'Time limit exceeded. Forward actions can only be rolled back within 24 hours.']);
            }
        } else {
            ob_clean();
            echo json_encode(['status' => 'error', 'message' => 'Item not found in the forwarded database.']);
        }
    } else {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'Invalid action.']);
    }
} catch(Throwable $e) {
    ob_clean();
    echo json_encode(['status' => 'error', 'message' => 'Server Error: ' . $e->getMessage()]);
}
?>