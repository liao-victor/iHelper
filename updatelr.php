<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("myjob_ui.inc");
    include("myjob_cn.inc");
    include("myjob_db.inc");

    $conn = db_connect();

    if ($_SESSION['userType'] != 'SUPE') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }


    if (!isset($_POST["id"]))
        echo 'Error.';
    else {
        ui_print_header('Leave request result update', $_SESSION['curUser']);
        try {
            $stmt = "BEGIN APPROVE_LEAVE(" . $_POST["id"] . ", '" . $_POST["result"] . "'); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
            print 'Update Successfully.';
        }
        catch(exception $e) {
            print 'Error. Try later or connect for support.';
        }
        print '<br><button type="button" onclick="window.location.href=\'leavereq.php?type=only\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:s'));
    }
    oci_close($conn);
}
