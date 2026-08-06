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

    // Check if POST data is completely empty (Usually indicates a wrong fetch URL or blocked payload)
    if (empty($_POST)) {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'No data received by the server. Check your JavaScript fetch() path.']);
        exit;
    }

    $active_user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $items_json = $_POST['items'] ?? '[]';
    $items = json_decode($items_json, true);

    if (empty($active_user_id)) {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'User ID is missing. Authorization failed.']);
        exit;
    }

    if (empty($items) || !is_array($items)) {
        ob_clean();
        echo json_encode(['status' => 'error', 'message' => 'No valid items provided for forwarding.']);
        exit;
    }

    $success = 0;
    $errors = 0;
    $today = date('Y-m-d'); // Short format date

    foreach ($items as $item) {
        $sn = $conn->real_escape_string($item['serial_number'] ?? '');
        $name = $conn->real_escape_string($item['item_name'] ?? '');
        $model = $conn->real_escape_string($item['item_model'] ?? '');
        $orig_user = $conn->real_escape_string($item['user_id'] ?? ''); // Original Purchaser

        if (empty($sn)) continue;

        // 1. Update purchased_items table (REMOVED forwarded_by_user_id)
        $sql1 = "UPDATE purchased_items 
                 SET date_forwarded = '$today' 
                 WHERE serial_number = '$sn'";
        
        // 2. Insert into forwarded_items table
        $sql2 = "INSERT INTO forwarded_items (serial_number, item_name, item_model, user_id, forwarded_by_user_id) 
                 VALUES ('$sn', '$name', '$model', '$orig_user', '$active_user_id')
                 ON DUPLICATE KEY UPDATE 
                 forwarded_by_user_id = '$active_user_id', 
                 date_forwarded = CURRENT_TIMESTAMP";

        if ($conn->query($sql1) && $conn->query($sql2)) {
            $success++;
        } else {
            $errors++;
        }
    }

    ob_clean(); // Ensure buffer is empty before final JSON output
    if ($errors > 0 && $success == 0) {
        echo json_encode(['status' => 'error', 'message' => 'Database error while forwarding items: ' . $conn->error]);
    } else {
        echo json_encode(['status' => 'success', 'message' => "Successfully forwarded $success items to Admin."]);
    }

    $conn->close();

} catch (Throwable $e) {
    ob_clean(); // Catch fatal server errors and convert to JSON
    echo json_encode(['status' => 'error', 'message' => 'Fatal Server Error: ' . $e->getMessage()]);
}
?>