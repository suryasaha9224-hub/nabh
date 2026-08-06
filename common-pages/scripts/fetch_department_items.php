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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

    if (empty($user_id)) {
        echo json_encode(['status' => 'error', 'message' => 'User ID is missing.']);
        exit;
    }

    // 1. Fetch the user's assigned department ID
    $user_sql = "SELECT dept_id FROM user_dataset WHERE user_id = '$user_id'";
    $user_res = $conn->query($user_sql);
    
    if (!$user_res || $user_res->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'User not found in the system.']);
        exit;
    }

    $user_data = $user_res->fetch_assoc();
    $dept_id = $user_data['dept_id'];

    // If the user has no specific department assigned
    if (empty($dept_id) || $dept_id === 'nan') {
        echo json_encode([
            'status' => 'success', 
            'dept_name' => 'General / Unassigned', 
            'dept_id' => 'NAN',
            'data' => []
        ]);
        exit;
    }

    // 2. Fetch the actual Department Name
    $dept_name = $dept_id; // Default fallback
    $dept_sql = "SELECT dept_name FROM departments WHERE dept_id = '$dept_id'";
    $dept_res = $conn->query($dept_sql);
    if ($dept_res && $dept_res->num_rows > 0) {
        $dept_name = $dept_res->fetch_assoc()['dept_name'];
    }

    // 3. Fetch all items with subqueries to pull the latest breakdown/resolved dates
    $items_sql = "SELECT 
                    it.item_id, 
                    it.item_name, 
                    it.item_model, 
                    it.item_manufacturer, 
                    it.serial_number, 
                    ia.date_assigned,
                    (SELECT MAX(report_date) FROM asset_report WHERE asset_name LIKE CONCAT('%', it.serial_number, '%')) as last_report_date,
                    (SELECT resolved_date FROM asset_report WHERE asset_name LIKE CONCAT('%', it.serial_number, '%') ORDER BY report_date DESC LIMIT 1) as last_resolved_date
                  FROM item_assigneds ia
                  JOIN item_table it ON ia.item_id = it.item_id
                  WHERE ia.dept_id = '$dept_id' AND ia.date_revoked = 'nan'
                  ORDER BY ia.date_assigned DESC";
                  
    $items_res = $conn->query($items_sql);
    $items = [];
    
    if ($items_res) {
        while ($row = $items_res->fetch_assoc()) {
            $items[] = $row;
        }
    }

    echo json_encode([
        'status' => 'success',
        'dept_name' => $dept_name,
        'dept_id' => $dept_id,
        'data' => $items
    ]);

} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>