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


    if (!isset($_POST["inid"]))
        echo 'Error.';
    else {
        ui_print_header('Interview Score and Remark Update', $_SESSION['curUser']);
        if(isset($_POST["score"]))
            try {
                $stmt = "BEGIN job_apply.score_interview(" . $_POST["inid"] . ", " . $_POST["score"] . ", '" . $_POST["remark"] . "'); END;";
                $sc = oci_parse($conn, $stmt);
                oci_execute($sc);
                print 'Update Successfully.';
            }
            catch(exception $e){
            print 'Error. Try later or connect for support.';
        }
        print '<br><button type="button" onclick="window.location.href=\'interdetail.php?id='.$_POST["id"].'&inid='.$_POST["inid"].'&appid='.$_POST["appid"].'&jobid='.$_POST["jobid"].'\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:s'));
    }
    oci_close($conn);
}
