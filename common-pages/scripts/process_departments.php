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

// Basic Admin Security Check
$check_admin = "SELECT user_role FROM user_dataset WHERE user_id = '$admin_id'";
$admin_res = $conn->query($check_admin);
if ($admin_res && $admin_res->num_rows > 0) {
    $roles = json_decode($admin_res->fetch_assoc()['user_role'], true);
    if (!isset($roles['admin']) || ($roles['admin'] !== '1' && $roles['admin'] !== 1)) {
        echo json_encode(['status' => 'error', 'message' => 'Access Denied: Admin role required.']);
        exit;
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Authorization failed.']);
    exit;
}

// 1. Fetch List
if ($action === 'fetch') {
    $sql = "SELECT dept_id, dept_name, date_created FROM departments ORDER BY date_created DESC";
    $result = $conn->query($sql);
    $data = [];
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// 2. Add Department
elseif ($action === 'add') {
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? '');
    $dept_name = $conn->real_escape_string($_POST['dept_name'] ?? '');

    if (empty($dept_id) || empty($dept_name)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields are required.']);
        exit;
    }

    $sql = "INSERT INTO departments (dept_id, dept_name) VALUES ('$dept_id', '$dept_name')";
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Department registered successfully.']);
    } else {
        if ($conn->errno == 1062) {
            echo json_encode(['status' => 'error', 'message' => 'Error: Department ID already exists.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'DB Error: ' . $conn->error]);
        }
    }
}

// 3. Delete Department
elseif ($action === 'delete') {
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? '');

    $sql = "DELETE FROM departments WHERE dept_id = '$dept_id'";
    if ($conn->query($sql)) {
        echo json_encode(['status' => 'success', 'message' => 'Department removed.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Delete failed: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action.']);
}

$conn->close();
?>