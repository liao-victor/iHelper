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
    <div class="title">$title</div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_optionbox($FIL_REQIV, $FIL_ISCON, $SRT_HRSLR) {
    echo '
<div>
<form action="" method="get">
<table style="display: inline-block;">
  <tr>
    <td><b>Require interview? </b></td>
  <td class="optionbox">
  <input type="radio" name="fil_reqiv" id="reqiv_yes" value="2" ';
    if ($FIL_REQIV == 2) echo 'checked';
    echo '><label for="reqiv_yes">Yes</label>
  <input type="radio" name="fil_reqiv" id="reqiv_no" value="1" ';
    if ($FIL_REQIV == 1) echo 'checked';
    echo '><label for="reqiv_no">No</label>
  <input type="radio" name="fil_reqiv" id="reqiv_na" value="0" ';
    if ($FIL_REQIV == 0) echo 'checked';
    echo '><label for="reqiv_na">Not applied</label></td>
    </tr>
  <tr><td><b>Is continuous? </b></td>
  <td class="optionbox">
  <input type="radio" name="fil_iscon" id="iscon_yes" value="2" ';
    if ($FIL_ISCON == 2) echo 'checked';
    echo '><label for="iscon_yes">Yes</label>
  <input type="radio" name="fil_iscon" id="iscon_no" value="1" ';
    if ($FIL_ISCON == 1) echo 'checked';
    echo '><label for="iscon_no">No</label>
  <input type="radio" name="fil_iscon" id="iscon_na" value="0" ';
    if ($FIL_ISCON == 0) echo 'checked';
    echo '><label for="iscon_na">Not applied</label></td></tr>
  <tr><td><b>Sort by hourly salary: </b></td>
  <td class="optionbox">
  <input type="radio" name="srt_hrslr" id="hrslr_yes" value="1" ';
    if ($SRT_HRSLR == 1) echo 'checked';
    echo '><label for="hrslr_yes">Yes</label>
  <input type="radio" name="srt_hrslr" id="hrslr_no" value="0" ';
    if ($SRT_HRSLR == 0) echo 'checked';
    echo '><label for="hrslr_no">Not applied</label></td></tr>
</table> <br>
<input type="submit" value="Apply">
</form>
</div>
';

}

function ui_print_job_list($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
  <table class="joblist">
  <tr>
    <th width="5%">JobID</th>
    <th width="75">Name</th>
    <th width="10%">Salary/hr</th>
    <th width="5%">Interview?</th>
    <th width="5%">Continuous?</th>
  </tr>
  <tr>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr>';
        for ($i = 1; $i <= oci_num_fields($_sqlsts); $i++)
            print '<td><a href="job_detail.php?id=' . oci_result($_sqlsts, 1) . '">' . oci_result($_sqlsts, $i) . '</a></td>';
        print '</tr>';
    }
    // Close the HTML table.
    print '</table>';
}

function ui_print_pagingbox ($page, $count) {
    $totalpages = ceil($count / RECORD_PER_PAGE);
    if ($totalpages > 1) {
        print '<div class="pagingbox">';
        for ($i = 1; $i <= $page - 1; $i++) {
            $new_get_query = $_GET;
            $new_get_query['page'] = $i;
            print '<a href="jobboard.php?' . http_build_query($new_get_query) . '"><div class="page">' . $i . '</div></a>';
        }
        print '<div class="page current">' . $page . '</div>';
        for ($i = $page + 1; $i <= $totalpages; $i++) {
            $new_get_query = $_GET;
            $new_get_query['page'] = $i;
            print '<a href="jobboard.php?' . http_build_query($new_get_query) . '"><div class="page">' . $i . '</div></a>';
        }
        print '</div>';
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