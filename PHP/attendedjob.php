<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("attendedjobdb.inc");
    include("job_cn.inc");
    include("attendedjobui.inc");

    if ($_SESSION['userType'] != 'STUD') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }

    $conn = db_connect();
    $Job_Ses = !isset($_GET['Job_Ses']) ? 0 : intval($_GET['Job_Ses']);
    $Job_Att = !isset($_GET['Job_Att']) ? 0 : intval($_GET['Job_Att']);
    $Job_Ann = !isset($_GET['Job_Ann']) ? 0 : intval($_GET['Job_Ann']);
    $Job_Con = !isset($_GET['Job_Con']) ? 0 : intval($_GET['Job_Con']);
    $Job_Sal = !isset($_GET['Job_Sal']) ? 0 : intval($_GET['Job_Sal']);
    $Sub_Lap = !isset($_GET['Sub_Lap']) ? 0 : intval($_GET['Sub_Lap']);
    $Per_Rev = !isset($_GET['Per_Rev']) ? 0 : intval($_GET['Per_Rev']);
    $Sta_Dat = !isset($_GET['Sta_Dat']) ? 0 : $_GET['Sta_Dat'];
    $End_Dat = !isset($_GET['End_Dat']) ? 0 : $_GET['End_Dat'];
    $Job_ID = !isset($_GET['Job_ID']) ? 0 : intval($_GET['Job_ID']);
    $Lev_Res = !isset($_GET['Lev_Res']) ? 0 : $_GET['Lev_Res'];
    $Std_ID = $_SESSION['curUser'];

    $table_ref= db_evaluate($conn,$Job_Ses,$Job_Att,$Job_Ann,$Job_Con,$Sub_Lap,$Job_Sal,$Per_Rev,$Std_ID,$Sta_Dat,$End_Dat,$Job_ID,$Lev_Res);

    ui_print_header('Attended jobs For You', $_SESSION['curUser']);
    ui_print_optionbox();
    if($table_ref[0] != 0)
        ui_print_job_list1($table_ref[0]);
    if($table_ref[1] != 0)
        ui_print_job_list2($table_ref[1]);
    if($table_ref[2] != 0)
        ui_print_job_list3($table_ref[2]);
    if($table_ref[3] != 0)
        ui_print_job_list4($table_ref[3]);
    if($table_ref[4] != 0)
        ui_print_job_list5($table_ref[4]);
    if($table_ref[5] != 0)
        ui_print_job_list6($table_ref[5]);
    ui_print_footer(date('Y-m-d H:i:s'));
}
oci_close($conn);
