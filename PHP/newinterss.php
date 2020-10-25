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


    if (!isset($_POST["id"]))
        echo 'Error.';
    else {
        if (preg_match("/^[12]\d{3}\-(?:0[0-9]|1[012])\-(?:[0-2][0-9]|3[01]) (?:[01][0-9]|2[0-3]):(?:[0-5][0-9]):(?:[0-5][0-9])$/", $_POST['date']) == 0)
            echo "The input format of the application deadline is incorrect! Example: 2017-07-07 23:00:00";
        else {
            ui_print_header('Create new interview session', $_SESSION['curUser']);
            try {
                $stmt = "BEGIN AINTERSS(" . $_POST["id"] . ", '" . $_POST["date"] . "','" . $_POST["venue"] . "'," . $_POST["quota"] . ", '" . $_POST["hours"] . "'); END;";
                $sc = oci_parse($conn, $stmt);
                oci_execute($sc);
                print 'Create Successfully.';
            } catch (exception $e) {
                print 'Error. Try later or connect for support.';
            }
        }
        print '<br><button type="button" onclick="window.location.href=\'jobinter.php?id='.$_POST["id"].'\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:s'));
    }
    oci_close($conn);
}
