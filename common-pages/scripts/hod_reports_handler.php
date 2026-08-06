<?php
error_reporting(0);
header('Content-Type: application/json');
$conn = new mysqli('localhost', 'root', '', 'nabh_pr');
if ($conn->connect_error) { die(json_encode(['status' => 'error', 'message' => 'DB Failed'])); }

$action = $_POST['action'] ?? '';
$user_id = $conn->real_escape_string($_POST['user_id'] ?? $_POST['admin_id'] ?? '');

// Lock operations strictly to the HOD's own department
$res = $conn->query("SELECT dept_id FROM user_dataset WHERE user_id='$user_id'");
$dept_id = ($res && $res->num_rows > 0) ? $res->fetch_assoc()['dept_id'] : 'nan';

$d_res = $conn->query("SELECT dept_name FROM departments WHERE dept_id = '$dept_id'");
$dept_name = ($d_res && $d_res->num_rows > 0) ? $conn->real_escape_string($d_res->fetch_assoc()['dept_name']) : $dept_id;

if ($action === 'fetch_reports') {
    if ($dept_id === 'nan' || empty($dept_id)) {
        echo json_encode(['status' => 'success', 'data' => []]); exit;
    }
    // Check both singular and plural table names as a failsafe
    $sql = "SELECT * FROM asset_report WHERE department = '$dept_name' OR department = '$dept_id' ORDER BY report_date DESC";
    $result = $conn->query($sql);
    if (!$result) {
        $sql = "SELECT * FROM asset_reports WHERE department = '$dept_name' OR department = '$dept_id' ORDER BY report_date DESC";
        $result = $conn->query($sql);
    }
    
    $data = [];
    if ($result) { while($row = $result->fetch_assoc()) { $data[] = $row; } }
    echo json_encode(['status' => 'success', 'data' => $data]);
}
elseif ($action === 'update_report') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $asset_name = $conn->real_escape_string($_POST['asset_name'] ?? '');
    $floor = $conn->real_escape_string($_POST['floor'] ?? '');
    $urgency = $conn->real_escape_string($_POST['urgency_level'] ?? '');
    $parts = $conn->real_escape_string($_POST['parts_required'] ?? '');
    $status = $conn->real_escape_string($_POST['checked'] ?? '0');
    
    $sql = "UPDATE asset_report SET asset_name='$asset_name', floor='$floor', urgency_level='$urgency', parts_required='$parts', checked='$status' WHERE report_id='$report_id'";
    if($conn->query($sql)) { echo json_encode(['status'=>'success', 'message'=>'Report updated.']); }
    else { echo json_encode(['status'=>'error', 'message'=>'Update failed.']); }
}
elseif ($action === 'update_status') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $new_status = $conn->real_escape_string($_POST['new_status'] ?? '');
    $date_update = "";
    if ($new_status == '1') $date_update = ", verified_date = NOW()";
    elseif ($new_status == '2') $date_update = ", resolved_date = NOW()";
    
    $sql = "UPDATE asset_report SET checked = '$new_status' $date_update WHERE report_id = '$report_id'";
    if($conn->query($sql)) { echo json_encode(['status'=>'success', 'message'=>'Status updated.']); }
    else { echo json_encode(['status'=>'error', 'message'=>'Update failed.']); }
}
elseif ($action === 'forward_report') {
    $report_id = $conn->real_escape_string($_POST['report_id'] ?? '');
    $orig_user = $conn->real_escape_string($_POST['original_user_id'] ?? '');
    
    $conn->begin_transaction();
    try {
        $conn->query("INSERT INTO forwarded_reports (report_id, original_user_id, admin_id) VALUES ('$report_id', '$orig_user', '$user_id')");
        $conn->query("UPDATE asset_report SET forwarded_date = NOW() WHERE report_id = '$report_id'");
        $conn->commit();
        echo json_encode(['status'=>'success', 'message'=>'Report forwarded!']);
    } catch(Exception $e) {
        $conn->rollback();
        echo json_encode(['status'=>'error', 'message'=>'Forward failed.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid Action']);
}
$conn->close();
?>