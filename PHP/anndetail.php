<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("anndetail_ui.inc");
    include("myjob_cn.inc");
    include("anndetail_db.inc");

    $conn = db_connect();
    if ($_SESSION['userType'] != 'SUPE') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }

    $table_ref = db_get_table($conn,$_GET['id']);

    ui_print_header('Edit announcement', $_SESSION['curUser']);
    ui_print_job_list($table_ref);
    ui_print_footer(date('Y-m-d H:i:s'));
    oci_close($conn);
}
