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
$admin_id = $conn->real_escape_string($_POST['admin_id'] ?? '');

if (empty($admin_id)) {
    echo json_encode(['status' => 'error', 'message' => 'Admin ID is missing. Authorization failed.']);
    exit;
}

// Get the Admin's Department
$dept_sql = "SELECT dept_id FROM user_dataset WHERE user_id = '$admin_id'";
$dept_res = $conn->query($dept_sql);
if (!$dept_res || $dept_res->num_rows === 0) {
    echo json_encode(['status' => 'error', 'message' => 'Admin department not found.']);
    exit;
}
$admin_dept = $dept_res->fetch_assoc()['dept_id'];

// --- 0. FAST UNREAD COUNT (For Dashboard Notification Dots) ---
if ($action === 'get_unread_count') {
    $total_unread = 0;

    // Sum unread messages from Users
    $q1 = $conn->query("SELECT SUM(admin_unread) as total FROM dept_user_queries WHERE dept_id = '$admin_dept'");
    if ($q1 && $row = $q1->fetch_assoc()) {
        $total_unread += (int)$row['total'];
    }

    // Sum unread messages from Purchase
    $q2 = $conn->query("SELECT SUM(admin_unread) as total FROM admin_purchase_queries WHERE dept_id = '$admin_dept'");
    if ($q2 && $row = $q2->fetch_assoc()) {
        $total_unread += (int)$row['total'];
    }

    echo json_encode(['status' => 'success', 'unread_count' => $total_unread]);
    exit;
}

// --- 1. Fetch User Conversations List (Now Includes Role & Dept Data) ---
elseif ($action === 'fetch_conversations') {
    $sql = "SELECT q.*, u.user_name, u.user_role, u.dept_id as user_dept 
            FROM dept_user_queries q 
            LEFT JOIN user_dataset u ON q.user_id = u.user_id 
            WHERE q.dept_id = '$admin_dept' 
            ORDER BY q.last_updated DESC";
    $result = $conn->query($sql);
    
    $data = [];
    if ($result && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // Process the JSON roles to find the primary permission level
            $roleData = [];
            if (!empty($row['user_role'])) {
                $roleData = json_decode($row['user_role'], true) ?: [];
            }
            
            $primary_role = 'Standard User';
            if (isset($roleData['admin']) && ($roleData['admin'] == '1' || $roleData['admin'] === 1)) {
                $primary_role = 'Admin';
            } elseif (isset($roleData['purchase']) && ($roleData['purchase'] == '1' || $roleData['purchase'] === 1)) {
                $primary_role = 'Purchase Officer';
            }
            
            $row['primary_role'] = $primary_role;
            
            // Unset raw JSON role data to keep the payload clean
            unset($row['user_role']);
            
            $data[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
} 

// --- 2. Mark User Chat as Read ---
elseif ($action === 'mark_user_read') {
    $conv_id = $conn->real_escape_string($_POST['conversation_id'] ?? '');
    $conn->query("UPDATE dept_user_queries SET admin_unread = 0 WHERE conversation_id = '$conv_id' AND dept_id = '$admin_dept'");
    echo json_encode(['status' => 'success']);
}

// --- 3. Mark Purchase Chat as Read ---
elseif ($action === 'mark_purchase_read') {
    $conn->query("UPDATE admin_purchase_queries SET admin_unread = 0 WHERE dept_id = '$admin_dept'");
    echo json_encode(['status' => 'success']);
}

// --- 4. Send Reply to User ---
elseif ($action === 'send_reply') {
    $conv_id = $conn->real_escape_string($_POST['conversation_id'] ?? '');
    $message = $conn->real_escape_string(trim($_POST['message'] ?? ''));
    
    if (empty($conv_id) || empty($message)) {
        echo json_encode(['status' => 'error', 'message' => 'Conversation ID or message missing.']);
        exit;
    }

    $now = date('Y-m-d H:i:s');
    $new_msg_array = ['datetime' => $now, 'message' => $message];

    $check_sql = "SELECT admin_chat FROM dept_user_queries WHERE conversation_id = '$conv_id' AND dept_id = '$admin_dept'";
    $check_res = $conn->query($check_sql);

    if ($check_res && $check_res->num_rows > 0) {
        $row = $check_res->fetch_assoc();
        $existing_chat = json_decode($row['admin_chat'], true);
        if (!is_array($existing_chat)) $existing_chat = [];
        
        $existing_chat[] = $new_msg_array;
        $updated_chat_json = $conn->real_escape_string(json_encode($existing_chat));

        // Increment user_unread so user sees the dot
        $update_sql = "UPDATE dept_user_queries 
                       SET admin_chat = '$updated_chat_json', last_updated = '$now', user_unread = user_unread + 1 
                       WHERE conversation_id = '$conv_id'";
                       
        if ($conn->query($update_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Reply sent successfully.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Conversation not found or unauthorized.']);
    }
} 

// --- 5. Fetch Purchase Chat Thread ---
elseif ($action === 'fetch_purchase_chat') {
    $sql = "SELECT * FROM admin_purchase_queries WHERE dept_id = '$admin_dept' LIMIT 1";
    $result = $conn->query($sql);
    
    if ($result && $result->num_rows > 0) {
        echo json_encode(['status' => 'success', 'data' => $result->fetch_assoc()]);
    } else {
        echo json_encode(['status' => 'success', 'data' => null]);
    }
}

// --- 6. Send Standard Message to Purchase ---
elseif ($action === 'send_purchase_msg') {
    $message = $conn->real_escape_string(trim($_POST['message'] ?? ''));
    
    if (empty($message)) {
        echo json_encode(['status' => 'error', 'message' => 'Message cannot be empty.']);
        exit;
    }

    $now = date('Y-m-d H:i:s');
    $new_msg_array = ['datetime' => $now, 'message' => $message];

    $check_sql = "SELECT conversation_id, admin_chat FROM admin_purchase_queries WHERE dept_id = '$admin_dept' LIMIT 1";
    $check_res = $conn->query($check_sql);

    if ($check_res && $check_res->num_rows > 0) {
        $row = $check_res->fetch_assoc();
        $conv_id = $row['conversation_id'];
        
        $existing_chat = json_decode($row['admin_chat'], true);
        if (!is_array($existing_chat)) $existing_chat = [];
        
        $existing_chat[] = $new_msg_array;
        $updated_chat_json = $conn->real_escape_string(json_encode($existing_chat));

        $update_sql = "UPDATE admin_purchase_queries 
                       SET admin_chat = '$updated_chat_json', last_updated = '$now', purchase_unread = purchase_unread + 1 
                       WHERE conversation_id = '$conv_id'";
                       
        if ($conn->query($update_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Message sent to Purchase.']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $conn->error]);
        }
    } else {
        $initial_chat_json = $conn->real_escape_string(json_encode([$new_msg_array]));
        $insert_sql = "INSERT INTO admin_purchase_queries (admin_id, dept_id, admin_chat, purchase_chat, created_at, last_updated, purchase_unread) 
                       VALUES ('$admin_id', '$admin_dept', '$initial_chat_json', '[]', '$now', '$now', 1)";
                       
        if ($conn->query($insert_sql)) {
            echo json_encode(['status' => 'success', 'message' => 'Conversation started with Purchase.']);
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