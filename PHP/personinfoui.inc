
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
    <td><b>View personal information?</b></td>
  <td><label for="VAP_Yes">Yes</label>
  <input type="radio" name="Per_Inf" id="VAP_Yes" value="2" </td>
  <td><label for="VAP_No">No</label>
  <input type="radio" name="Per_Inf" id="VAP_No" value="1" </td>
   </tr>
    
  <tr><td><b>Modify Contact information?</b></td>
  <td><label for="MCI_Yes">Yes</label>
  <input type="radio" name="Mod_Con" id="MCI_Yes" value="2" </td>
  <td><label for="MCI_No">No</label>
  <input type="radio" name="Mod_Con" id="MCI_No" value="1" </td>
  </tr>
  
  <tr><td><b>Modify CV?</b></td>
  <td><label for="MC_Yes">Yes</label>
  <input type="radio" name="Mod_Cv" id="MC_Yes" value="2"</td>
  <td><label for="MC_No">No</label>
  <input type="radio" name="Mod_Cv" id="MC_No" value="1" </td>
  </tr>
  
  <tr><td><b>Modify Language Preference</b></td>
  <td><label for="MLP_Yes">Yes</label>
  <input type="radio" name="Mod_Mlp" id="MLP_Yes" value="2"</td>
  <td><label for="MLP_No">No</label>
  <input type="radio" name="Mod_Mlp" id="MLP_No" value="1" </td>
  </tr>
</table>
PhoneNo：<input type="text" name="PhoNo" ><br>
Email：<input type="text" name="Email" ><br>
Street Address1：<input type="text" name="Address1" ><br>
Street Address2：<input type="text" name="Address2" ><br>
City：<input type="text" name="City" ><br>
State：<input type="text" name="State" ><br>
CV：<input type="text" name="CV" ><br>
Language Preference: <input type="number" name="LanPr" ><br>
<input type="submit" value="Submit" >
</form>
</div>
';

}

function ui_print_job_list($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
    <p>Personal Information</p>
  <table class="joblist">
  <tr>
    <th>Person ID</th>
    <th>Title</th>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Is local?</th>
    <th>Phone Number</th>
    <th>Email</th>
    <th>Major</th>
    <th>Cantonese level</th>
    <th>English level</th>
    <th>Putonghua level</th>
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