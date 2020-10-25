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
    <div class="title">$title <button type="button" onclick="window.location.href='jobrecord.php?id=
END;
    print $_GET["jobid"].'\'">GO BACK</button>';
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
    <th>Objection ID</th>
    <th>Record ID</th>
    <th>From(A:Student B:Supervisor)</th>
    <th>Reason</th>
    <th>Reply</th>
  </tr>
  <tr>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr>';
        for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++) {
            if(oci_result($_sqlsts, 3)=='A')
                print '<td><a href="view1obj.php?id=' . oci_result($_sqlsts, 1) . '&jobid=' . $_GET["jobid"] . '&recid=' . $_GET["id"] . '">' . oci_result($_sqlsts, $i) . '</a></td>';
            else
                print '<td>'.oci_result($_sqlsts, $i).'</td>';
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

?>