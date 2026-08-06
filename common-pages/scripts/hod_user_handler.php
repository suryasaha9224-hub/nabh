<?php
error_reporting(0);
header('Content-Type: application/json');
$conn = new mysqli('localhost', 'root', '', 'nabh_pr');
if ($conn->connect_error) { die(json_encode(['status' => 'error', 'message' => 'DB Failed'])); }

$action = $_POST['action'] ?? '';
$admin_id = $conn->real_escape_string($_POST['admin_id'] ?? $_POST['user_id'] ?? '');

$res = $conn->query("SELECT dept_id FROM user_dataset WHERE user_id='$admin_id'");
$dept_id = ($res && $res->num_rows > 0) ? $conn->real_escape_string($res->fetch_assoc()['dept_id']) : 'nan';

if ($action === 'fetch_users') {
    // Only fetch users that belong to this HOD's department
    $sql = "SELECT user_id, user_name, user_mail, user_role, date_created, dept_id FROM user_dataset WHERE dept_id = '$dept_id' ORDER BY date_created DESC";
    $result = $conn->query($sql);
    $data = [];
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $roleData = json_decode($row['user_role'], true) ?: [];
            $row['primary_role'] = (isset($roleData['admin']) && ($roleData['admin'] == '1' || $roleData['admin'] == 1)) ? 'Admin' : 'Standard User';
            $data[] = $row;
        }
    }
    echo json_encode(['status' => 'success', 'data' => $data]);
}
elseif ($action === 'add_user') {
    $new_uid = $conn->real_escape_string($_POST['user_id'] ?? '');
    $uname = $conn->real_escape_string($_POST['user_name'] ?? '');
    $umail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $upass = $conn->real_escape_string($_POST['user_password'] ?? '');
    $urole = $conn->real_escape_string($_POST['user_role'] ?? '');
    $date = date('Y-m-d');
    
    $check = $conn->query("SELECT user_id FROM user_dataset WHERE user_id='$new_uid'");
    if($check && $check->num_rows > 0) {
        echo json_encode(['status'=>'error', 'message'=>'User ID exists.']); exit;
    }
    
    $sql = "INSERT INTO user_dataset (user_id, user_name, user_mail, user_password, user_role, date_created, dept_id) VALUES ('$new_uid', '$uname', '$umail', '$upass', '$urole', '$date', '$dept_id')";
    if($conn->query($sql)) echo json_encode(['status'=>'success', 'message'=>'User created.']);
    else echo json_encode(['status'=>'error', 'message'=>'Failed.']);
}
elseif ($action === 'update_user') {
    $target_uid = $conn->real_escape_string($_POST['target_user_id'] ?? '');
    $uname = $conn->real_escape_string($_POST['user_name'] ?? '');
    $umail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $urole = $conn->real_escape_string($_POST['user_role'] ?? '');
    
    $sql = "UPDATE user_dataset SET user_name='$uname', user_mail='$umail', user_role='$urole' WHERE user_id='$target_uid' AND dept_id='$dept_id'";
    if($conn->query($sql)) echo json_encode(['status'=>'success', 'message'=>'User updated.']);
    else echo json_encode(['status'=>'error', 'message'=>'Update failed.']);
}
elseif ($action === 'update_profile') {
    $uname = $conn->real_escape_string($_POST['user_name'] ?? '');
    $umail = $conn->real_escape_string($_POST['user_mail'] ?? '');
    $upass = $conn->real_escape_string($_POST['user_password'] ?? '');
    
    if (!empty($upass)) {
        $sql = "UPDATE user_dataset SET user_name='$uname', user_mail='$umail', user_password='$upass' WHERE user_id='$admin_id'";
    } else {
        $sql = "UPDATE user_dataset SET user_name='$uname', user_mail='$umail' WHERE user_id='$admin_id'";
    }
    if($conn->query($sql)) echo json_encode(['status'=>'success', 'message'=>'Profile updated.']);
    else echo json_encode(['status'=>'error', 'message'=>'Update failed.']);
}
else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action']);
}
$conn->close();
?>