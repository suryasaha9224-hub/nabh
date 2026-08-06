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
$admin_id = $_POST['admin_id'] ?? '';

// 1. Manual Single Addition
if ($action === 'manual') {
    $name = $conn->real_escape_string($_POST['item_name'] ?? '');
    $model = $conn->real_escape_string($_POST['item_model'] ?? '');
    $manu = $conn->real_escape_string($_POST['item_manufacturer'] ?? '');
    $serial = $conn->real_escape_string($_POST['serial_number'] ?? '');

    $sql = "INSERT INTO item_table (item_name, item_model, item_manufacturer, serial_number) 
            VALUES ('$name', '$model', '$manu', '$serial')";

    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Item added successfully.']);
    } else {
        if ($conn->errno == 1062) {
            echo json_encode(['status' => 'error', 'message' => 'Error: Serial number already exists.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
        }
    }
} 

// 2. Bulk CSV Import
elseif ($action === 'bulk') {
    if (!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(['status' => 'error', 'message' => 'File upload failed.']);
        exit;
    }

    $file = $_FILES['csv_file']['tmp_name'];
    $handle = fopen($file, "r");
    
    // Skip the first line (headers)
    fgetcsv($handle);

    $inserted = 0;
    $errors = 0;

    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
        if (count($data) < 4) continue; // Basic validation

        $name = $conn->real_escape_string($data[0]);
        $model = $conn->real_escape_string($data[1]);
        $manu = $conn->real_escape_string($data[2]);
        $serial = $conn->real_escape_string($data[3]);

        $sql = "INSERT INTO item_table (item_name, item_model, item_manufacturer, serial_number) 
                VALUES ('$name', '$model', '$manu', '$serial')";
        
        if ($conn->query($sql)) {
            $inserted++;
        } else {
            $errors++;
        }
    }
    fclose($handle);

    echo json_encode([
        'status' => 'success', 
        'message' => "Import Complete. Success: $inserted, Failed: $errors (duplicates likely)."
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action.']);
}

$conn->close();
?>