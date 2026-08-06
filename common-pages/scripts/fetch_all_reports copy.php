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

    // Security Check: Verify admin
    $user_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$user_id'";
    $user_result = $conn->query($user_check_sql);
    
    if ($user_result && $user_result->num_rows > 0) {
        $user_row = $user_result->fetch_assoc();
        $roles = json_decode($user_row['user_role'], true);
        
        if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
            echo json_encode(['status' => 'error', 'message' => 'Access Denied: You do not have admin privileges.']);
            exit;
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Admin user not found.']);
        exit;
    }

    // Fetch ALL reports AND check if they exist in the forwarded_reports table
    $sql = "SELECT a.*, 
                   (SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END 
                    FROM forwarded_reports f 
                    WHERE f.report_id = a.report_id) as is_forwarded
            FROM asset_report a 
            ORDER BY a.report_date DESC";
            
    $result = $conn->query($sql);

    $reports = [];
    if ($result && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $reports[] = $row;
        }
    }

    echo json_encode([
        'status' => 'success',
        'data' => $reports
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>