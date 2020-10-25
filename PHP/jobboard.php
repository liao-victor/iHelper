<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    header('Location: portal.php');
} else {
    include("job_ui.inc");
    include("job_cn.inc");
    include("job_db.inc");

    $conn = db_connect();
    $page = !isset($_GET['page']) ? 1 : intval($_GET['page']);
    $FIL_REQIV = !isset($_GET['fil_reqiv']) ? 0 : intval($_GET['fil_reqiv']);
    $FIL_ISCON = !isset($_GET['fil_iscon']) ? 0 : intval($_GET['fil_iscon']);
    $SRT_HRSLR = !isset($_GET['srt_hrslr']) ? 0 : intval($_GET['srt_hrslr']);

    $start_pos = ($page - 1) * RECORD_PER_PAGE + 1;
    $count = db_get_job_count($conn, $_SESSION['curUser'], $FIL_REQIV, $FIL_ISCON, 1);

    if ($count == 0)
        echo 'Error: No record found. Please try again. ';
    elseif ($start_pos > $count)
        echo 'Error: page range exceeded. ';
    else {
        $table_ref = db_get_table($conn, $start_pos, RECORD_PER_PAGE, $_SESSION['curUser'], $FIL_REQIV, $FIL_ISCON, 1, $SRT_HRSLR);

        ui_print_header('Available Jobs', $_SESSION['curUser']);
        ui_print_optionbox($FIL_REQIV, $FIL_ISCON, $SRT_HRSLR);
        ui_print_job_list($table_ref);
        ui_print_pagingbox($page, $count);
        ui_print_footer(date('Y-m-d H:i:s'));
    }
    oci_close($conn);
}
