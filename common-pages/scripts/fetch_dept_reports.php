<?php
// Ensure no warnings/errors break the JSON output, but we catch them internally
error_reporting(E_ALL);
ini_set('display_errors', 0);
header('Content-Type: application/json');

try {
    $host = 'localhost';
    $db   = 'nabh_pr';
    $user = 'root';
    $pass = '';

    // Tell mysqli to throw exceptions on errors so we can catch them cleanly
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    $conn = new mysqli($host, $user, $pass, $db);

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

        if (empty($user_id)) {
            echo json_encode(['status' => 'error', 'message' => 'User ID is missing.']);
            exit;
        }

        // 1. Get the user's assigned dept_id
        $u_res = $conn->query("SELECT dept_id FROM user_dataset WHERE user_id = '$user_id'");
        $dept_id = 'nan';
        if ($u_res && $u_res->num_rows > 0) {
            $dept_id = $u_res->fetch_assoc()['dept_id'];
        }

        if (empty($dept_id) || $dept_id === 'nan') {
            echo json_encode(['status' => 'success', 'data' => []]);
            exit;
        }

        // 2. Resolve the exact department name
        $d_res = $conn->query("SELECT dept_name FROM departments WHERE dept_id = '$dept_id'");
        $dept_name = $dept_id;
        if ($d_res && $d_res->num_rows > 0) {
            $dept_name = $conn->real_escape_string($d_res->fetch_assoc()['dept_name']);
        }

        // 3. Fetch all reports matching this department
        $reports = [];
        
        try {
            // Try singular table name first (standard based on your other scripts)
            $sql = "SELECT * FROM asset_report WHERE department = '$dept_name' OR department = '$dept_id' ORDER BY report_date DESC";
            $result = $conn->query($sql);
        } catch (Exception $e) {
            // If singular fails (table doesn't exist), gracefully fallback to plural table name
            $sql = "SELECT * FROM asset_reports WHERE department = '$dept_name' OR department = '$dept_id' ORDER BY report_date DESC";
            $result = $conn->query($sql);
        }

        if (isset($result) && $result->num_rows > 0) {
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

} catch (Throwable $e) {
    // If ANY fatal error occurs in the entire script, output it as safe JSON
    echo json_encode([
        'status' => 'error', 
        'message' => 'Server Error: ' . $e->getMessage()
    ]);
}
?>