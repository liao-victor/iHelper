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
    <div class="title">$title <button type="button" onclick="window.location.href='leavereq.php?type=only'">GO BACK</button></div>
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
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr><td>Job ID:</td><td>' . oci_result($_sqlsts, 1) . '</td></tr>';
        print '<tr><td>Job Name:</td><td>' . oci_result($_sqlsts, 2) . '</td></tr>';
        print '<tr><td>Student ID:</td><td>' . oci_result($_sqlsts, 3) . '</td></tr>';
        print '<tr><td>Reason:</td><td>' . oci_result($_sqlsts, 4) . '</td></tr>';
        print '<tr><td>Start Date:</td><td>' . oci_result($_sqlsts, 5) . '</td></tr>';
        print '<tr><td>End Date:</td><td>' . oci_result($_sqlsts, 6) . '</td></tr>';
        if(oci_result($_sqlsts, 7)=='P') {
            print '</table><form action="updatelr.php" method="post"><input type="hidden" name="id" value=' . $_GET["id"] . '><br>Request result:<br>' . print_result(oci_result($_sqlsts, 7));
            print'<br><input type="submit" value="Update request result"></form>';
        }
        else
            print '<tr><td>Request result:</td><td>' . oci_result($_sqlsts, 7) . '</td></tr></table>';
    }
}

function print_result($data){
    $out='<input type="radio" name="result" value="P"';
    if($data=='P') $out=$out.'checked';
    $out=$out.'> Pending<br>
  <input type="radio" name="result" value="Y" ';
    if($data=='Y') $out=$out.'checked';
    $out=$out.'> Yes<br>
  <input type="radio" name="result" value="N" ';
    if($data=='N') $out=$out.'checked';
    $out=$out.'>No';
    return $out;
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