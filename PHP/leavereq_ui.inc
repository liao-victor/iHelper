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
    <div class="title">$title <button type="button" onclick="window.location.href='myjobboard.php?'">GO BACK</button></div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list($_sqlsts)
{
    print '<form action="leavereq.php" method="get"><input type="radio" name="type" value="only"';
    if($_GET["type"]=='only') print ' checked';
    print "> Pending only <input type=\"radio\" name=\"type\" value=\"all\"";
    if($_GET["type"]=='all') print ' checked';
    print "> All ";
    // Open the HTML table.
    echo <<<END
    <input type="submit" value="Refresh"></form>
  <table class="joblist">
  <tr>
    <th>Job ID</th>
    <th>Job Name</th>
    <th>Student ID</th>
    <th>Start Date</th>
    <th>End Date</th>
    <th>Approve</th>
  </tr>
  <tr>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        if(oci_result($_sqlsts, 7)=='P'||$_GET["type"]=='all'){
            print '<tr>';
            for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++) {
                if($i!=4&&$i!=8)
                    print '<td><a href="lr_detail.php?id=' . oci_result($_sqlsts, 8) . '">' . oci_result($_sqlsts, $i) . '</a></td>';
            }
            print '</tr>';
        }
    }
    // Close the HTML table.
    print '</table>';
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

function ShowTable($_sqlsts)
{
    GLOBAL $c;
    // Open the HTML table.
    print '<table border="1" cellspacing="0" cellpadding="3">';
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr>';
        for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++)
            print '<td>' . oci_result($_sqlsts, $i) . '</td>';
        print '</tr>';
    }
    // Close the HTML table.
    print '</table>';
}

?>