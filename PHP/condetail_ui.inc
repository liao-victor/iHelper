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
    <div class="title">$title <button type="button" onclick="window.location.href='contracts.php?id=
END;
    print $_GET['id'];
    echo <<<END
     '">GO BACK</button></div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    while (oci_fetch($_sqlsts)) {
        if (oci_result($_sqlsts, 10) == '') {
            print
                '<form action="addcon.php" method="post">
        <table>
        <tr><td>Job ID:</td><td><input type="text" name="jobid" value="' . $_GET["id"] . '" readonly="readonly"></td></tr>
<tr><td>Student ID:</td><td><input type="text" name="stuid" value="' . $_GET["uid"] . '" readonly="readonly"></td></tr>
<tr><td>Supervisor ID:</td><td><input type="text" name="supid" value="' . $_SESSION["curUser"] . '" readonly="readonly"></td></tr>
<tr><td>Hour/Week:</td><td><input type="number" name="hw" required></td></tr>
<tr><td>Weeks:</td><td><input type="number" name="weeks" required></td></tr>
<tr><td>Start Date:</td><td><input type="text" name="sd" required></td></tr>
<tr><td>End Date:</td><td><input type="text" name="ed" required></td></tr>
<tr><td>Salary/Hour:</td><td><input type="number" name="hs" required></td></tr>
<tr><td>Remark:</td><td><textarea name="remark" rows="6" cols="50"></textarea></td></tr></table><input type="submit" value="Submit"></form>';
        } else {
            // Read fetched data.
            // use while loop
            // Print open and close HTML row tags and columns data.
            print '<table><tr><td>Job ID:</td><td>' . oci_result($_sqlsts, 1) . '</td></tr>';
            print '<tr><td>Student ID:</td><td>' . oci_result($_sqlsts, 2) . '</td></tr>';
            print '<tr><td>Supervisor ID:</td><td>' . oci_result($_sqlsts, 10) . '</td></tr>';
            print '<tr><td>Hour/Week:</td><td>' . oci_result($_sqlsts, 11) . '</td></tr>';
            print '<tr><td>Weeks:</td><td>' . oci_result($_sqlsts, 12) . '</td></tr>';
            print '<tr><td>Start Date:</td><td>' . oci_result($_sqlsts, 6) . '</td></tr>';
            print '<tr><td>End Date:</td><td>' . oci_result($_sqlsts, 7) . '</td></tr>';
            print '<tr><td>Salary/Hour:</td><td>' . oci_result($_sqlsts, 8) . '</td></tr>';
            print '<tr><td>Remark:</td><td>' . oci_result($_sqlsts, 9) . '</td></tr></table><button type="button" onclick="window.location.href=\'deletecon.php?id=' . oci_result($_sqlsts, 13).'&jobid='.$_GET['id'] . '&stuid=' . oci_result($_sqlsts, 2) .'\'">Terminate</button>';
        }
    }
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

function lang_hash_decode($hash) {
    $hash = intval($hash);
    $pref_ctn = floor($hash / 9);
    $hash -= 9 * floor($hash / 9);
    $pref_eng = floor($hash / 3);
    $hash -= 3 * floor($hash / 3);
    $pref_pth = $hash;
    return array("ctn" => $pref_ctn, "eng" => $pref_eng, "pth" => $pref_pth);
}

function lang_decode($code){
    if($code==2) return 'High';
    if($code==1) return 'Medium';
    return 'No';
}
?>