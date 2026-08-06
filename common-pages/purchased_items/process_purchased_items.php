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
$user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

if (empty($user_id)) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is missing. Authorization failed.']);
    exit;
}

// 1. Manual Single Addition
if ($action === 'manual') {
    $name = $conn->real_escape_string(trim($_POST['item_name'] ?? ''));
    $model = $conn->real_escape_string(trim($_POST['item_model'] ?? ''));
    $manu = $conn->real_escape_string(trim($_POST['item_manufacturer'] ?? ''));
    $serial = $conn->real_escape_string(trim($_POST['serial_number'] ?? ''));
    $date_purchased = $conn->real_escape_string(trim($_POST['date_purchased'] ?? ''));

    // Default to current date (YYYY-MM-DD) if date_purchased is blank
    if (empty($date_purchased)) {
        $date_purchased = date('Y-m-d');
    }

    if (empty($serial) || empty($name)) {
        echo json_encode(['status' => 'error', 'message' => 'Name and Serial Number are required.']);
        exit;
    }

    // Intelligent Insert: Updates the item if the serial number already exists (Primary Key)
    $sql = "INSERT INTO purchased_items (serial_number, item_name, item_model, item_manufacturer, user_id, date_purchased) 
            VALUES ('$serial', '$name', '$model', '$manu', '$user_id', '$date_purchased')
            ON DUPLICATE KEY UPDATE 
            item_name = VALUES(item_name), 
            item_model = VALUES(item_model), 
            item_manufacturer = VALUES(item_manufacturer),
            date_purchased = VALUES(date_purchased),
            user_id = VALUES(user_id)";

    if ($conn->query($sql)) {
        if ($conn->affected_rows == 1) {
            echo json_encode(['status' => 'success', 'message' => 'New purchased item logged successfully.']);
        } else {
            echo json_encode(['status' => 'success', 'message' => 'Existing purchased item updated successfully.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
    }
} 

// 2. Bulk CSV Import
elseif ($action === 'bulk') {
    if (!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(['status' => 'error', 'message' => 'File upload failed or file is corrupted.']);
        exit;
    }

    $file = $_FILES['csv_file']['tmp_name'];
    $handle = fopen($file, "r");
    
    // Skip the first line (headers)
    fgetcsv($handle);

    $inserted = 0;
    $updated = 0;
    $errors = 0;

    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        
        // Handle potential semicolon separation from European Excel versions
        if (count($data) < 4) {
            if (count($data) == 1 && strpos($data[0], ';') !== false) {
                $data = explode(';', $data[0]);
            }
            if (count($data) < 4) continue; // Skip invalid rows
        }

        $name = $conn->real_escape_string(trim($data[0]));
        $model = $conn->real_escape_string(trim($data[1]));
        $manu = $conn->real_escape_string(trim($data[2]));
        $serial = $conn->real_escape_string(trim($data[3]));
        
        // Parse date purchased if available, else default to today
        $date_purchased = isset($data[4]) ? $conn->real_escape_string(trim($data[4])) : '';
        if (empty($date_purchased)) {
            $date_purchased = date('Y-m-d');
        }

        if (empty($serial) || empty($name)) continue;

        // Intelligent Insert
        $sql = "INSERT INTO purchased_items (serial_number, item_name, item_model, item_manufacturer, user_id, date_purchased) 
                VALUES ('$serial', '$name', '$model', '$manu', '$user_id', '$date_purchased')
                ON DUPLICATE KEY UPDATE 
                item_name = VALUES(item_name), 
                item_model = VALUES(item_model), 
                item_manufacturer = VALUES(item_manufacturer),
                date_purchased = VALUES(date_purchased),
                user_id = VALUES(user_id)";
        
        if ($conn->query($sql)) {
            if ($conn->affected_rows == 1) {
                $inserted++;
            } else {
                // affected_rows is 2 for a changed update, 0 for an unchanged update
                $updated++;
            }
        } else {
            $errors++;
        }
    }
    fclose($handle);

    $total_success = $inserted + $updated;

    if ($errors > 0 && $total_success == 0) {
        echo json_encode(['status' => 'error', 'message' => "Import Failed. Encountered $errors database error(s)."]);
    } else {
        echo json_encode([
            'status' => 'success', 
            'message' => "Import Complete! Added: $inserted, Updated: $updated, Failed: $errors."
        ]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action.']);
}

$conn->close();
?>