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
<link rel="stylesheet" type="text/css" href="godlong-list.css">
<title>$title - iHelper</title>
</head>
<body>
<div class="header">
    <div class="title">$title</div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_optionbox($Int_Info,$Sub_Info,$App_Res){
    echo '
<div>
<form action="" method="get">
<table>
  <tr>
    <td><b>View interview status? </b></td>
  <td><label for="VIS_Yes">Yes</label>
  <input type="radio" name="Int_Info" id="VIS_Yes" value="2" </td>
  <td><label for="VIS_No">No</label>
  <input type="radio" name="Int_Info" id="VIS_No" value="1" </td>
   </tr>
    
  <tr><td><b>View interview result?</b></td>
  <td><label for="VIR_Yes">Yes</label>
  <input type="radio" name="Int_Res" id="VIR_Yes" value="2" </td>
  <td><label for="VIR_No">No</label>
  <input type="radio" name="Int_Res" id="VIR_No" value="1" </td>
  </tr>
  
  <tr><td><b>Choose Interview session?</b></td>
  <td><label for="CIS_Yes">Yes</label>
  <input type="radio" name="Cho_Int" id="CIS_Yes" value="2"</td>
  <td><label for="CIS_No">No</label>
  <input type="radio" name="Cho_Int" id="CIS_No" value="1" </td>
  </tr>
</table>
Session ID：<input type="number" name="Ses_ID" ><br>
<input type="submit" value="Submit" >
</form>
</div>
';

}

function ui_print_job_list1($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>Interview Arrangement</p>
  <table class="joblist">
  <tr>
    <th></th>
    <th>Date</th>
    <th>Venue</th>
  </tr>
  <tr>
END;
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

function ui_print_job_list2($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p> Interview Result</p>
  <table class="joblist">
  <tr>
    <th>Score</th>
    <th>Remark</th>
  </tr>
  <tr>
END;
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