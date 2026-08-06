<?php
// Set header to return JSON responses
header('Content-Type: application/json');

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

// Check if request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // Retrieve and sanitize inputs
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $password = $conn->real_escape_string($_POST['password'] ?? '');

    // Validate empty fields
    if (empty($user_id) || empty($password)) {
        echo json_encode(['status' => 'error', 'message' => 'Please provide both User ID and Password.']);
        exit;
    }

    // Query the database for the user
    $sql = "SELECT user_password, user_role FROM user_dataset WHERE user_id = '$user_id'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        
        // Verify the password 
        // Note: For production, you should use password_hash() on registration and password_verify() here.
        if ($password === $row['user_password']) {
            
            // Decode the JSON stored in the database
            // Expected DB format: {"user": "1", "admin": "0", "purchase": "0"}
            $roles = json_decode($row['user_role'], true);
            
            // Send success response with roles AND the user_id
            echo json_encode([
                'status' => 'success',
                'message' => 'Login successful',
                'user_id' => $user_id, // We are sending the ID back to the frontend
                'roles' => $roles
            ]);
            
        } else {
            // Password did not match
            echo json_encode(['status' => 'error', 'message' => 'Invalid Password.']);
        }
    } else {
        // User ID was not found
        echo json_encode(['status' => 'error', 'message' => 'Staff ID not found.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

$conn->close();
?>