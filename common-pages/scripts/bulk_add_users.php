<?php
error_reporting(E_ALL);
ini_set('display_errors', 0); 
header('Content-Type: application/json');

try {
    $host = 'localhost';
    $db   = 'nabh_pr';
    $user = 'root';
    $pass = '';

    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    $conn = new mysqli($host, $user, $pass, $db);

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $admin_id = $conn->real_escape_string($_POST['admin_id'] ?? '');

        if (empty($admin_id)) {
            echo json_encode(['status' => 'error', 'message' => 'Admin ID is missing. Authorization failed.']);
            exit;
        }

        // Security Check: Verify admin performing the action
        $admin_check_sql = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
        $admin_result = $conn->query($admin_check_sql);
        
        if ($admin_result && $admin_result->num_rows > 0) {
            $roles = json_decode($admin_result->fetch_assoc()['user_role'], true);
            if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
                echo json_encode(['status' => 'error', 'message' => 'Access Denied: You lack admin privileges.']);
                exit;
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Admin authorization failed.']);
            exit;
        }

        // Validate File Upload
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
        $date_created = date('Y-m-d');

        while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
            
            // Handle potential semicolon separation from European Excel versions
            if (count($data) < 8) {
                if (count($data) == 1 && strpos($data[0], ';') !== false) {
                    $data = explode(';', $data[0]);
                }
                if (count($data) < 8) continue; // Skip invalid rows
            }

            // Expected format: user_id, user_name, user_mail, user_password, dept_id, role_user, role_admin, role_purchase
            $new_user_id = $conn->real_escape_string(trim($data[0]));
            $user_name = $conn->real_escape_string(trim($data[1]));
            $user_mail = $conn->real_escape_string(trim($data[2]));
            $user_password = $conn->real_escape_string(trim($data[3]));
            $dept_id = $conn->real_escape_string(trim($data[4]));
            
            if ($dept_id === '') $dept_id = 'nan';

            // Role formatting
            $roles = [
                'user' => (trim($data[5]) == '1' || strtolower(trim($data[5])) === 'true') ? 1 : 0,
                'admin' => (trim($data[6]) == '1' || strtolower(trim($data[6])) === 'true') ? 1 : 0,
                'purchase' => (trim($data[7]) == '1' || strtolower(trim($data[7])) === 'true') ? 1 : 0
            ];
            $user_role_json = $conn->real_escape_string(json_encode($roles));

            if (empty($new_user_id) || empty($user_name) || empty($user_password)) continue;

            // Upsert Logic: Insert if new, Update if already exists
            $sql = "INSERT INTO user_dataset (user_id, user_name, user_mail, user_password, user_role, date_created, dept_id) 
                    VALUES ('$new_user_id', '$user_name', '$user_mail', '$user_password', '$user_role_json', '$date_created', '$dept_id')
                    ON DUPLICATE KEY UPDATE 
                    user_name = VALUES(user_name), 
                    user_mail = VALUES(user_mail), 
                    user_role = VALUES(user_role),
                    dept_id = VALUES(dept_id),
                    user_password = VALUES(user_password)";
            
            if ($conn->query($sql)) {
                if ($conn->affected_rows == 1) {
                    $inserted++;
                } else {
                    $updated++;
                }
            } else {
                $errors++;
            }
        }
        fclose($handle);

        $total_success = $inserted + $updated;

        if ($errors > 0 && $total_success == 0) {
            echo json_encode(['status' => 'error', 'message' => "Import Failed. Encountered $errors database error(s). Ensure CSV matches format."]);
        } else {
            echo json_encode([
                'status' => 'success', 
                'message' => "Batch Import Complete! Added: $inserted, Updated: $updated, Failed: $errors."
            ]);
        }

    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid Request Method.']);
    }

    $conn->close();

} catch (Throwable $e) {
    echo json_encode(['status' => 'error', 'message' => 'Server Error: ' . $e->getMessage()]);
}
?>