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
    <div class="title">$title <button type="button" onclick="window.location.href='jobapp.php?id=
END;
    print $_GET["id"].'\'">GO BACK</button> <button type="button" onclick="window.location.href=\'newrecord.php?id='.$_GET["id"].'\'">Create Record</button>';
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
  <table class="joblist">
  <tr>
    <th>Record ID</th>
    <th>Student ID</th>
    <th>Date</th>
    <th>Type</th>
    <th>Payment</th>
    <th>IsValid</th>
    <th>Number of Objection</th>
  </tr>
  <tr>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        if(oci_result($_sqlsts, 9)!='N') {
            print '<tr>';
            for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++) {
                if ($i != 2 && $i != 4 && $i != 7)
                    if($i==10)
                        print '<td><a href="viewobj.php?id=' . oci_result($_sqlsts, 1) . '&jobid=' . $_GET["id"] . '">' . oci_result($_sqlsts, $i) . '</a></td>';
                    else
                        print '<td><a href="editrecord.php?id=' . oci_result($_sqlsts, 1) . '&jobid=' . $_GET["id"] . '">' . oci_result($_sqlsts, $i) . '</a></td>';
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