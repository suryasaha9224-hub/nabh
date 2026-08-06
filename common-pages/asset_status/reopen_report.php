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
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? ''); 

    if (empty($report_id) || empty($user_id)) {
        echo json_encode(['status' => 'error', 'message' => 'Report ID or User ID missing.']);
        exit;
    }

    // Verify ownership and fetch the current resolution date
    $sql_check = "SELECT resolved_date, checked FROM asset_report WHERE report_id = '$report_id' AND user_id = '$user_id'";
    $result = $conn->query($sql_check);
    
    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        
        // Ensure it is actually marked as resolved
        if ($row['checked'] != 2) {
            echo json_encode(['status' => 'error', 'message' => 'Report is not currently resolved.']);
            exit;
        }

        // Prevent reopening if resolved_date is missing or invalid
        if ($row['resolved_date'] === 'nan') {
            echo json_encode(['status' => 'error', 'message' => 'Cannot verify the original resolution time.']);
            exit;
        }

        // Verify the 24-hour limit strictly on the server-side
        $resolved_time = strtotime($row['resolved_date']);
        $diff_hours = (time() - $resolved_time) / 3600;

        if ($diff_hours > 24) {
            echo json_encode(['status' => 'error', 'message' => 'You can only reopen reports within 24 hours of resolution.']);
            exit;
        }

        // Update report: Send it back to the active queue (checked = 1) and reset the resolved date
        $update_sql = "UPDATE asset_report SET checked = 1, resolved_date = 'nan' WHERE report_id = '$report_id'";
        if ($conn->query($update_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Report reopened successfully. It is now active again.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database update failed: ' . $conn->error]);
        }
        
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Report not found or you lack permission to alter it.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request format.']);
}

$conn->close();
?>