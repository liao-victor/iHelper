<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
}

include("addann_ui.inc");
include("myjob_cn.inc");
$objConnect = db_connect();

if ($_SESSION['userType'] != 'SUPE') {
    oci_close($objConnect);
    die('Sorry but you have no permission to continue. ');
}
oci_close($objConnect);

ui_print_header('Add Announcements', $_SESSION['curUser']);
ui_print_job_list();
ui_print_footer(date('Y-m-d H:i:s'));
