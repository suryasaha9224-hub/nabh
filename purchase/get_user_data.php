<?php
// Suppress default PHP errors from breaking the JSON response
error_reporting(0);

// Set header to explicitly return JSON
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
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]);
    exit;
}

// Check if request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve user ID from POST data sent by the dashboard
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

    if (empty($user_id)) {
        echo json_encode(['status' => 'error', 'message' => 'User ID is missing in the request.']);
        exit;
    }

    // Query the database for the user's details based on your table structure
    $sql = "SELECT user_name, user_id, user_mail, user_role, date_created FROM user_dataset WHERE user_id = '$user_id'";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        
        // Decode the JSON role format you are using (e.g., {"user": "1", "admin": "0", "purchase": "0"})
        $roles = json_decode($row['user_role'], true);
        
        // Attach the decoded roles to our data payload
        $row['roles_decoded'] = $roles ? $roles : ['user' => '1', 'admin' => '0', 'purchase' => '0'];

        // Return the fetched data
        echo json_encode([
            'status' => 'success',
            'data' => $row
        ]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'User not found in the nabh_pr dataset.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

$conn->close();
?>