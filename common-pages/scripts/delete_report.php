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
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? ''); // Extra security check

    if (empty($report_id) || empty($user_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Report ID or User ID missing.']);
        exit;
    }

    // ONLY delete if it belongs to the user AND it is unchecked (checked = 0)
    $sql = "DELETE FROM asset_report WHERE report_id = '$report_id' AND user_id = '$user_id' AND checked = 0";
    
    if ($conn->query($sql)) {
        if ($conn->affected_rows > 0) {
            echo json_encode(['status' => 'success', 'message' => 'Report deleted successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Cannot delete: Report not found or already checked by Admin.']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>