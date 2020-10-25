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
    print $_GET['jobid'];
    echo <<<END
     '">GO BACK</button></div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list($_sqlsts)
{
    while (oci_fetch($_sqlsts)) {
        if($_SESSION["curUser"]==(oci_result($_sqlsts, 4))) $flag=TRUE;
        else
            $flag=FALSE;
        if($flag) print '<form action="updaterecord.php" method="post">';
        echo <<<END
  <table><tr><td>Record ID:</td><td><input type="number" name="id"
value="
END;
        print oci_result($_sqlsts, 1) . '" readonly>';
        print '</td></tr><tr><td>Job ID:</td><td><input type="number" name="jobid"
value="'.oci_result($_sqlsts, 2) . '" readonly><tr><td>Supervisor ID:</td><td>' . oci_result($_sqlsts, 4) . '</td></tr><tr><td>Student ID:</td><td>'.oci_result($_sqlsts, 3).'</td></tr>';
        print '<tr><td>Type:</td><td><input type="radio" name="type" value="P"';
        if(oci_result($_sqlsts, 6)=='P') print ' checked';
        if(!$flag) print ' readonly';
        print '> Positive<br><input type="radio" name="type" value="M"';
        if(!$flag) print ' readonly';
        if(oci_result($_sqlsts, 6)=='M') print ' checked';
        if(!$flag) print ' readonly';
        print '> Neutral<br><input type="radio" name="type" value="N"';
        if(oci_result($_sqlsts, 6)=='N') print ' checked';
        print '> Negative</td></tr>';
        print '<tr><td>Describe:</td><td><textarea name="desc" rows="6" cols="50"';
        if(!$flag) print ' readonly';
        print '>'.oci_result($_sqlsts, 7).'</textarea></td></tr>';
        print '<tr><td>Payment:</td><td><input type="number" name="pay"
value="'.oci_result($_sqlsts, 8).'"';
        if(!$flag) print ' readonly';
        print '></td></tr></td></tr></table>';
        if($flag) print '<input type="submit" value="Update"></form>';
        print '<button type="button" onclick="window.location.href=\'viewobj.php?id='.oci_result($_sqlsts, 1).'&jobid=' . $_GET["jobid"] . '\'">View objection</button><br>Submit Objection:<br><form action="spobj.php" method="post"><input type="hidden" name="id"
value="'.oci_result($_sqlsts, 1) . '"><input type="hidden" name="supid" value="'.$_SESSION["curUser"] .'"><input type="hidden" name="jobid" value="'.oci_result($_sqlsts, 2) .'"><textarea name="desc" rows="6" cols="50"></textarea><br><input type="submit" value="Submit"></form>';
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