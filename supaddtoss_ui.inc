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
    <div class="title">$title <button type="button" onclick="window.location.href='inter_session.php?id=
END;
    print $_GET['id'].'&jobid='.$_GET['jobid'];
    echo <<<END
    '">GO BACK</button>
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
    <h1>Please click the student you want to add to this interview session:</h1>
  <table class="joblist">
  <tr>
    <th>Application ID</th>
    <th>Student ID</th>
    <th>FirstName</th>
    <th>LastName</th>
    <th>Major</th>
    <th>Entrance Year</th>
  </tr>
  <tr>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr>';
        for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++) {
            if($i%7!=0 && $i%8!=0 && $i%9!=0)
            print '<td><a href="addtoss.php?appid=' . oci_result($_sqlsts, 1) . '&isid='.$_GET["id"].'&jobid='.$_GET["jobid"].'">' . oci_result($_sqlsts, $i) . '</a></td>';
        }
        print '</tr>';

    }
    // Close the HTML table.
    print '</table>';
}

function ui_print_pagingbox ($page, $count) {
    $totalpages = ceil($count / RECORD_PER_PAGE);
    if ($totalpages > 1) {
        print '<table class="pagingbox"><tr>';
        for ($i = 1; $i <= $page - 1; $i++) {
            $new_get_query = $_GET;
            $new_get_query['page'] = $i;
            print '<td><a href="jobboard.php?' . http_build_query($new_get_query) . '">[' . $i . ']</a></td>';
        }
        print '<td>[' . $page . ']</td>';
        for ($i = $page + 1; $i <= $totalpages; $i++) {
            $new_get_query = $_GET;
            $new_get_query['page'] = $i;
            print '<td><a href="jobboard.php?' . http_build_query($new_get_query) . '">[' . $i . ']</a></td>';
        }
        print '</tr></table>';
    }
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