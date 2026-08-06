<?php
error_reporting(0);
header('Content-Type: application/json');
$conn = new mysqli('localhost', 'root', '', 'nabh_pr');
if ($conn->connect_error) { die(json_encode(['status' => 'error', 'message' => 'DB Failed'])); }

$action = $_POST['action'] ?? '';
$user_id = $conn->real_escape_string($_POST['user_id'] ?? $_POST['admin_id'] ?? '');

if (empty($user_id)) {
    die(json_encode(['status' => 'error', 'message' => 'User ID missing']));
}

if ($action === 'get_unread_count') {
    $res = $conn->query("SELECT dept_id FROM user_dataset WHERE user_id='$user_id'");
    $dept_id = ($res && $res->num_rows > 0) ? $res->fetch_assoc()['dept_id'] : 'nan';
    $q = $conn->query("SELECT SUM(admin_unread) as total FROM dept_user_queries WHERE dept_id='$dept_id'");
    $total = ($q && $row = $q->fetch_assoc()) ? (int)$row['total'] : 0;
    echo json_encode(['status' => 'success', 'unread_count' => $total]);
} 
elseif ($action === 'fetch_profile') {
    $sql = "SELECT user_name, user_id, user_mail, user_role, date_created, dept_id FROM user_dataset WHERE user_id = '$user_id'";
    $result = $conn->query($sql);
    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(['status' => 'success', 'data' => $row]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'User not found.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
}
$conn->close();
?>