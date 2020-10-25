<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("applicationui.inc");
    include("job_cn.inc");
    include("applicationdb.inc");

    $conn = db_connect();

    if ($_SESSION['userType'] != 'SUPE') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }

    $Sub_App = !isset($_GET['Sub_App']) ? 0 : intval($_GET['Sub_App']);
    $App_Info = !isset($_GET['App_Info']) ? 0 : intval($_GET['App_Info']);
    $App_Res = !isset($_GET['App_Res']) ? 0 : intval($_GET['App_Res']);
    $Job_ID = !isset($_GET['Job_ID']) ? 0 : intval($_GET['Job_ID']);
    $App_ID = !isset($_GET['App_ID']) ? 0 : intval($_GET['App_ID']);
    $Cov_Let = !isset($_GET['CL']) ? '0' : $_GET['CL'];
    $Std_ID = $_SESSION['curUser'];

    $table_ref= db_evaluate($conn,$Sub_App,$App_Info,$App_Res, $App_ID,$Job_ID,$Cov_Let,$Std_ID);

    ui_print_header('Job Applications For You', $_SESSION['curUser']);
    ui_print_optionbox($Sub_App,$App_Info,$App_Res,$Job_ID,$Cov_Let,$App_ID);
    if($table_ref[0] != 0)
        ui_print_job_list1($table_ref[0]);
    if($table_ref[1] != 0)
        ui_print_job_list2($table_ref[1]);
    ui_print_footer(date('Y-m-d H:i:s'));
    oci_close($conn);
}
