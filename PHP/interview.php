<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("interviewdb.inc");
    include("job_cn.inc");
    include("interviewui.inc");

    $conn = db_connect();
    if ($_SESSION['userType'] != 'STUD') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }
    $Int_Info = !isset($_GET['Int_Info']) ? 0 : intval($_GET['Int_Info']);
    $Int_Res = !isset($_GET['Int_Res']) ? 0 : intval($_GET['Int_Res']);
    $Cho_Int = !isset($_GET['Cho_Int']) ? 0 : intval($_GET['Cho_Int']);
    $Ses_ID = !isset($_GET['Ses_ID']) ? 0 : intval($_GET['Ses_ID']);
    $Std_ID = $_SESSION['curUser'];

    $table_ref= db_evaluate($conn,$Int_Info,$Int_Res,$Cho_Int,$Std_ID,$Ses_ID);

    ui_print_header('Job Interviews For You', $_SESSION['curUser']);
    ui_print_optionbox($conn,$Int_Info,$Int_Res,$Cho_Int,$Ses_ID);
    if($table_ref[0] != 0)
        ui_print_job_list1($table_ref[0]);
    if($table_ref[1] != 0)
        ui_print_job_list2($table_ref[1]);
    ui_print_footer(date('Y-m-d H:i:s'));
}
oci_close($conn);

