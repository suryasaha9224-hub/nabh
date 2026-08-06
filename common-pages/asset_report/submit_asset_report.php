<?php
// Suppress warnings for clean JSON output
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

// Handle fetching departments for the reporting dropdown (Public/GET Access)
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

// Handle POST request for submitting the actual report
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 1. Sanitize text inputs
    $user_id = $conn->real_escape_string($_POST['user_id'] ?? '');
    $asset_name = $conn->real_escape_string($_POST['asset_name'] ?? '');
    $urgency_level = $conn->real_escape_string($_POST['urgency_level'] ?? '');
    $department = $conn->real_escape_string($_POST['department'] ?? '');
    $floor = $conn->real_escape_string($_POST['floor'] ?? '');
    $description = $conn->real_escape_string($_POST['description'] ?? '');
    
    // Checkbox returns 'true' if checked, otherwise it might not be set
    $parts_required_raw = $_POST['parts_required'] ?? 'false';
    $parts_required = ($parts_required_raw === 'true') ? 'y' : 'n';

    if (empty($user_id) || empty($asset_name)) {
        echo json_encode(['status' => 'error', 'message' => 'User ID and Asset Name are required.']);
        exit;
    }

    // 2. Handle Image Uploads
    $uploadDir = 'uploads/'; // Ensure this folder exists or let PHP create it
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $uploadedFiles = [];

    if (isset($_FILES['final_asset_photos'])) {
        $fileArray = $_FILES['final_asset_photos'];
        
        for ($i = 0; $i < count($fileArray['name']); $i++) {
            if ($fileArray['error'][$i] === UPLOAD_ERR_OK) {
                $originalName = basename($fileArray['name'][$i]);
                $fileExt = strtolower(pathinfo($originalName, PATHINFO_EXTENSION));
                
                // Generate a unique file name to avoid overwriting existing files
                $newFileName = uniqid('asset_') . '_' . time() . '.' . $fileExt;
                $destPath = $uploadDir . $newFileName;
                
                // Move the file from temp storage to the uploads folder
                if (move_uploaded_file($fileArray['tmp_name'][$i], $destPath)) {
                    $uploadedFiles[] = $newFileName; // Save filename to array
                }
            }
        }
    }

    // Convert the array of filenames into a JSON string to store in the text column
    $photosJson = $conn->real_escape_string(json_encode($uploadedFiles));

    // 3. Insert data into the asset_report table
    $sql = "INSERT INTO asset_report (user_id, asset_name, urgency_level, department, floor, description, parts_required, photos, checked) 
            VALUES ('$user_id', '$asset_name', '$urgency_level', '$department', '$floor', '$description', '$parts_required', '$photosJson', 0)";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'Asset issue logged successfully.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database Error: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request.']);
}

$conn->close();
?>