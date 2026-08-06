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

    // Fetch reports ordered by most recent first
    $sql = "SELECT * FROM asset_report WHERE user_id = '$user_id' ORDER BY report_date DESC";
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