<?php
error_reporting(0);
date_default_timezone_set('Asia/Kolkata');
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
$user_id = $conn->real_escape_string($_POST['user_id'] ?? '');

if (empty($user_id)) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is missing. Authorization failed.']);
    exit;
}

// --- 1. Fetch Conversation ---
if ($action === 'fetch') {
    // 1A. Fetch the User's Department
    $dept_sql = "SELECT dept_id FROM user_dataset WHERE user_id = '$user_id'";
    $dept_res = $conn->query($dept_sql);
    $dept_id = 'nan';
    if ($dept_res && $dept_res->num_rows > 0) {
        $dept_id = $conn->real_escape_string($dept_res->fetch_assoc()['dept_id']);
    }

    // 1B. Fetch the specific Admin's Name for this Department
    $admin_name = "System Administrator"; // Fallback
    if ($dept_id !== 'nan') {
        $admin_sql = "SELECT user_name FROM user_dataset WHERE dept_id = '$dept_id' AND (user_role LIKE '%\"admin\":\"1\"%' OR user_role LIKE '%\"admin\": 1%' OR user_role LIKE '%\"admin\":1%') LIMIT 1";
        $admin_res = $conn->query($admin_sql);
        if ($admin_res && $admin_res->num_rows > 0) {
            $admin_name = $admin_res->fetch_assoc()['user_name'];
        }
    }

    // 1C. Fetch the single active conversation for this user
    $sql = "SELECT * FROM dept_user_queries WHERE user_id = '$user_id' ORDER BY last_updated DESC LIMIT 1";
    $result = $conn->query($sql);
    
    if ($result && $result->num_rows > 0) {
        $data = $result->fetch_assoc();
        $data['admin_name'] = $admin_name; // Attach admin name to payload
        
        // Reset the user's unread counter to 0 since they just opened/refreshed the chat
        $conn->query("UPDATE dept_user_queries SET user_unread = 0 WHERE user_id = '$user_id'");
        
        echo json_encode(['status' => 'success', 'data' => $data]);
    } else {
        // Return a skeleton payload with the admin name if no chat exists yet
        echo json_encode(['status' => 'success', 'data' => ['admin_name' => $admin_name, 'user_chat' => '[]', 'admin_chat' => '[]']]);
    }
} 

// --- 2. Send Message ---
elseif ($action === 'send') {
    $message = $conn->real_escape_string(trim($_POST['message'] ?? ''));
    
    if (empty($message)) {
        echo json_encode(['status' => 'error', 'message' => 'Message cannot be empty.']);
        exit;
    }

    // Get User's Department
    $dept_sql = "SELECT dept_id FROM user_dataset WHERE user_id = '$user_id'";
    $dept_res = $conn->query($dept_sql);
    $dept_id = 'nan';
    if ($dept_res && $dept_res->num_rows > 0) {
        $dept_id = $conn->real_escape_string($dept_res->fetch_assoc()['dept_id']);
    }

    $now = date('Y-m-d H:i:s');
    $new_msg_array = ['datetime' => $now, 'message' => $message];

    // Check if a conversation already exists
    $check_sql = "SELECT conversation_id, user_chat FROM dept_user_queries WHERE user_id = '$user_id' LIMIT 1";
    $check_res = $conn->query($check_sql);

    if ($check_res && $check_res->num_rows > 0) {
        $row = $check_res->fetch_assoc();
        $conv_id = $row['conversation_id'];
        
        $existing_chat = json_decode($row['user_chat'], true);
        if (!is_array($existing_chat)) $existing_chat = [];
        
        $existing_chat[] = $new_msg_array;
        $updated_chat_json = $conn->real_escape_string(json_encode($existing_chat));

        // Increment the admin_unread counter by 1
        $update_sql = "UPDATE dept_user_queries 
                       SET user_chat = '$updated_chat_json', last_updated = '$now', status = 'open', admin_unread = admin_unread + 1 
                       WHERE conversation_id = '$conv_id'";
                       
        if ($conn->query($update_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Message sent successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
        }
    } else {
        $initial_chat_json = $conn->real_escape_string(json_encode([$new_msg_array]));
        
        // Set admin_unread to 1 initially for the new conversation
        $insert_sql = "INSERT INTO dept_user_queries (user_id, dept_id, user_chat, admin_chat, status, created_at, last_updated, admin_unread, user_unread) 
                       VALUES ('$user_id', '$dept_id', '$initial_chat_json', '[]', 'open', '$now', '$now', 1, 0)";
                       
        if ($conn->query($insert_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Conversation started and message sent.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
        }
    }
} 

else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action.']);
}

$conn->close();
?>