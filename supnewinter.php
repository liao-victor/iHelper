<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("supnewinter_ui.inc");
    include("myjob_cn.inc");
    include("supnewinter_db.inc");

    $conn = db_connect();
    if ($_SESSION['userType'] != 'SUPE') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }
    ui_print_header('The interviews', $_SESSION['curUser']);

    echo <<<END
    <form action="newinterss.php" method="post">
    <input type="hidden" name="id" value="
END;
    print $_GET["id"];
    echo <<<END
">
    Date and Time: <input type="text" name="date" required><br>
    Venue: <input type="text" name="venue" required><br>
    Quota: <input type="number" name="quota" required><br>
    Hours: <input tyep="number" name="hours" required><br>
<input type="submit" value="Create"></form>
END;

    ui_print_footer(date('Y-m-d H:i:s'));
    oci_close($conn);
}
