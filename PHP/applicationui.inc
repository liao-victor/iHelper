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

function ui_print_optionbox(){
    echo '
<div>
<form action="" method="get">
<table>
  <tr>
    <td><b>Submit Application? </b></td>
  <td><label for="App_Yes">Yes</label>
  <input type="radio" name="Sub_App" id="App_Yes" value="2" </td>
  <td><label for="App_No">No</label>
  <input type="radio" name="Sub_App" id="App_No" value="1" </td>
   </tr>
    
  <tr><td><b>View Submitted Information?</b></td>
  <td><label for="VSI_Yes">Yes</label>
  <input type="radio" name="App_Info" id="VSI_Yes" value="2" </td>
  <td><label for="VSI_No">No</label>
  <input type="radio" name="App_Info" id="VSI_No" value="1" </td>
  </tr>
  
  <tr><td><b>View Application Result?</b></td>
  <td><label for="VAR_Yes">Yes</label>
  <input type="radio" name="App_Res" id="VAR_Yes" value="2"</td>
  <td><label for="VAR_No">No</label>
  <input type="radio" name="App_Res" id="VAR_No" value="1" </td>
  </tr>
</table>
AppID：<input type="number" name="App_ID" ><br>
JobID：<input type="number" name="Job_ID" ><br>
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
    <p>Application Information</p>
  <table class="joblist">
  <tr>
    <th>AppID</th>
    <th>JobID</th>
    <th>StudentID</th>
    <th>CoverLetter</th>
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
    <p>Application Result</p>
  <table class="joblist">
  <tr>
    <th>Score</th>
    <th>IsSucessful</th>
    <th>IsValid</th>
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