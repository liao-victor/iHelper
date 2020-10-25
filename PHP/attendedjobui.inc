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
    <td><b>View session arrangement?</b></td>
  <td><label for="VSA_Yes">Yes</label>
  <input type="radio" name="Job_Ses" id="VSA_Yes" value="2" </td>
  <td><label for="VSA_No">No</label>
  <input type="radio" name="Job_Ses" id="VSA_No" value="1" </td>
   </tr>
    
  <tr><td><b>View job attendance record?</b></td>
  <td><label for="JAR_Yes">Yes</label>
  <input type="radio" name="Job_Att" id="JAR_Yes" value="2" </td>
  <td><label for="VAR_No">No</label>
  <input type="radio" name="Job_Att" id="JAR_No" value="1" </td>
  </tr>
    
  <tr><td><b>View job announcement?</b></td>
  <td><label for="VJA_Yes">Yes</label>
  <input type="radio" name="Job_Ann" id="VJA_Yes" value="2" </td>
  <td><label for="VJA_No">No</label>
  <input type="radio" name="Job_Ann" id="VJA_No" value="1" </td>
  </tr>
  
  <tr><td><b>View job contracts?</b></td>
  <td><label for="VJC_Yes">Yes</label>
  <input type="radio" name="Job_Con" id="VJC_Yes" value="2"</td>
  <td><label for="VJC_No">No</label>
  <input type="radio" name="Job_Con" id="VJC_No" value="1" </td>
  </tr>
  
  <tr><td><b>Submit leave application?</b></td>
  <td><label for="SLA_Yes">Yes</label>
  <input type="radio" name="Sub_Lap" id="SLA_Yes" value="2"</td>
  <td><label for="SLA_No">No</label>
  <input type="radio" name="Sub_Lap" id="SLA_No" value="1" </td>
  </tr>
  
  
  <tr><td><b>View Overall expected salary in the current month?</b></td>
  <td><label for="VOE_Yes">Yes</label>
  <input type="radio" name="Job_Sal" id="VOE_Yes" value="2"</td>
  <td><label for="VOE_No">No</label>
  <input type="radio" name="Job_Sal" id="VOE_No" value="1" </td>
  </tr>
  
  <tr><td><b>View performance reviews?</b></td>
  <td><label for="VPR_Yes">Yes</label>
  <input type="radio" name="Per_Rev" id="VPR_Yes" value="2"</td>
  <td><label for="VPR_No">No</label>
  <input type="radio" name="Per_Rev" id="VPR_No" value="1" </td>
  </tr>
  
</table>
JobID: <input type="number" name="Job_ID" ><br>
Start Date: <input type="text" name="Sta_Dat" ><br>
End   Date: <input type="text" name="End_Dat" ><br>
Leave Reason: <br><textarea name="Lev_Res" id="" cols="32" rows="8"></textarea><br>
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
    <p>Interview arrangement</p>
  <table class="joblist">
  <tr>
    <th>Date</th>
    <th>Hours</th>
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
    <p>Job attendance record</p>
  <table class="joblist">
  <tr>
    <th>SessionID</th>
    <th>StudentID</th>
    <th>Is Present?</th>
    <th>Attend Hours</th>
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

function ui_print_job_list3($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>View job announcements</p>
  <table class="joblist">
  <tr>
    <th>Announcement ID</th>
    <th>Job Name</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Message</th>
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

function ui_print_job_list4($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>Job Contract</p>
  <table class="joblist">
  <tr>
    <th>Working hours per week</th>
    <th>Hours salary</th>
    <th>Start date</th>
    <th>End date</th>
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

function ui_print_job_list5($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>Current Month Salary</p>
  <table class="joblist">
  <tr>
    <th>JobID</th>
    <th>Current Month Salary</th>
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

function ui_print_job_list6($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>Performance review</p>
  <table class="joblist">
  <tr>
    <th>Description</th>
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