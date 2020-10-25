<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("myjob_ui.inc");
    include("myjob_cn.inc");
    include("job_db.inc");

    $conn = db_connect();
    if (db_get_permission($conn, $_SESSION['curUser'], $_POST["jobid"]) != 1) {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }


    ui_print_header('Add Announcement', $_SESSION['curUser']);
            try {
                $stmt = "BEGIN JOB_MANAGE.ADD_ANNOUNCEMENT(" . $_POST["jobid"] . ", '" . $_SESSION['curUser'] . "', '".$_POST["msg"]."'); END;";
                $sc = oci_parse($conn, $stmt);
                oci_execute($sc);
                print 'Give Successfully.';
            }
            catch(exception $e){
            print 'Error. Try later or connect for support.';
        }
        print '<br><button type="button" onclick="window.location.href=\'jobann.php?id='.$_POST["jobid"].'\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:xs'));
    oci_close($conn);
    }

