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

    if (db_get_permission($conn, $_SESSION['curUser'], $_GET["jobid"]) != 1) {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }


    if (!isset($_GET["appid"]))
        echo 'Error.';
    else {
        ui_print_header('Add application to interview session', $_SESSION['curUser']);
        try {
            $rtn_value = -1;
            $stmt = "BEGIN INTERSS_CHECK(".$_GET["isid"]."," . $_GET["jobid"] . ", " . $_GET["appid"] . ", :OUT_COUNT); END;";
            $sc = oci_parse($conn, $stmt);
            oci_bind_by_name($sc, ':OUT_COUNT', $rtn_value);
            oci_execute($sc);
            if ($rtn_value != -1) {
                $stmt = "BEGIN dinter(" . $rtn_value . "); END;";
                $sc = oci_parse($conn, $stmt);
                oci_execute($sc);
            }
            $stmt = "BEGIN addinter(" . $_GET["appid"] . ",".$_GET["isid"]."); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
            print 'Add Successfully.';
        }
            catch(exception $e){
            print 'Error. Try later or connect for support.';
        }
        print '<br><button type="button" onclick="window.location.href=\'inter_session.php?id='.$_GET["isid"].'&jobid='.$_GET["jobid"].'\'">GO BACK</button>';
        ui_print_footer(date('Y-m-d H:i:s'));
    }
    oci_close($conn);
}
