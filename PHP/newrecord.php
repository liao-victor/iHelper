<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("newrecord_ui.inc");

    if ($_SESSION['userType'] != 'SUPE') {
        die('Sorry but you have no permission to continue. ');
    }

    ui_print_header('Create record', $_SESSION['curUser']);
    ui_print_job_list();
    ui_print_footer(date('Y-m-d H:i:s'));
}
