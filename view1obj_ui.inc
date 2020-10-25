<?php

function ui_print_header($title, $curUser)
{
    $title = htmlentities($title);
    echo <<<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
 "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type"
      content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="list.css">
<title>$title - iHelper</title>
</head>
<body>
<div class="header">
    <div class="title">$title <button type="button" onclick="window.location.href='viewobj.php?id=
END;
    print $_GET["recid"].'&jobid='.$_GET["jobid"].'\'">GO BACK</button>';
    echo <<<END
     </div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
  <table>
  <form action="updateobj.php" method="post"><input type="hidden" name="jobid" value="
END;
    print $_GET["jobid"].'">';
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr><td>Objection ID:</td><td><input type="number" name="id" value="' . oci_result($_sqlsts, 1) . '" readonly></td></tr>';
        print '<tr><td>Record ID:</td><td><input type="number" name="recid" value="' . oci_result($_sqlsts, 2) . '" readonly></td></tr>';
        print '<tr><td>Reason:</td><td>' . oci_result($_sqlsts, 4) . '</td></tr>';
        print '<tr><td>Reply:</td><td><textarea name="reply" rows="6" cols="50">' . oci_result($_sqlsts, 5) . '</textarea></td></tr><br>';
    }
    print '</table><input type="submit" value="Update reply"></form>';
}

function ui_print_footer($date)
{
    $date = htmlentities($date);
    echo <<<END
  <div class="footer">
    <div class="date">$date</div>
    <div class="company">iHelper</div>
  </div>
</body>
</html>
END;
}

?>