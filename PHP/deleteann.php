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
    if ($_SESSION['userType'] != 'SUPE') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }


    if (!isset($_GET["id"]))
        echo 'Error.';
    else {
        ui_print_header('Announcement Update', $_SESSION['curUser']);
        try {
            $stmt = "BEGIN DESTROY.DANNOUNCEMENT(" . $_GET["id"] . "); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
            print 'Delete Successfully.';
        }
        catch(exception $e){
            print 'Error. Try later or connect for support.';
        }
        print '<br><button type="button" onclick="window.location.href=\'jobann.php?id='.$_GET["jobid"].'\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:xs'));
    }
    oci_close($conn);
}
