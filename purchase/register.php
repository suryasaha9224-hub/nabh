<?php
// Set header to return JSON responses
header('Content-Type: application/json');
error_reporting(0);

// Database configuration for XAMPP
$host = 'localhost';
$db   = 'nabh_pr';
$user = 'root'; // Default XAMPP username
$pass = '';     // Default XAMPP password is empty

// Create database connection
$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]));
}

// Handle fetching departments for the registration dropdown (Public Access)
if (isset($_GET['action']) && $_GET['action'] === 'get_departments') {
    $sql = "SELECT dept_id, dept_name FROM departments ORDER BY dept_name ASC";
    $result = $conn->query($sql);
    $data = [];
    if ($result) {
        while($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
    $conn->close();
    exit;
}

// Handle Registration Submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // Sanitize user inputs to prevent SQL Injection
    $user_id = $conn->real_escape_string($_POST['staff_id'] ?? '');
    $user_name = $conn->real_escape_string($_POST['staff_name'] ?? '');
    $user_mail = $conn->real_escape_string($_POST['staff_email'] ?? '');
    $user_password = $conn->real_escape_string($_POST['password'] ?? ''); 
    $dept_id = $conn->real_escape_string($_POST['dept_id'] ?? 'nan'); // Capture the selected department
    
    // Prepare JSON data for user_role
    $user_role = json_encode(['user' => '0', 'admin' => '0', 'purchase' => '0']);
    
    // Get the current date in YYYY-MM-DD format
    $date_created = date('Y-m-d');

    // 1. Check if the user_id already exists to prevent duplicate primary keys
    $check_sql = "SELECT user_id FROM user_dataset WHERE user_id = '$user_id'";
    $result = $conn->query($check_sql);

    if ($result->num_rows > 0) {
        echo json_encode(['status' => 'error', 'message' => 'Registration Failed: Staff ID already exists!']);
    } else {
        // 2. Insert new user into dataset including dept_id
        $sql = "INSERT INTO user_dataset (user_name, user_id, user_mail, user_password, user_role, date_created, dept_id) 
                VALUES ('$user_name', '$user_id', '$user_mail', '$user_password', '$user_role', '$date_created', '$dept_id')";
        
        if ($conn->query($sql) === TRUE) {
            echo json_encode(['status' => 'success', 'message' => 'Registration successful!']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
        }
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

$conn->close();
?>