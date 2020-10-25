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
     '">GO BACK</button></div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list($_sqlsts)
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
  <table>
END;
    // Read fetched data.
    while (oci_fetch($_sqlsts)) {
        // use while loop
        // Print open and close HTML row tags and columns data.
        print '<tr><td>Application ID:</td><td>' . oci_result($_sqlsts, 1) . '</td></tr>';
        print '<tr><td>Student ID:</td><td>' . oci_result($_sqlsts, 2) . '</td></tr>';
        print '<tr><td>First Name:</td><td>' . oci_result($_sqlsts, 3) . '</td></tr>';
        print '<tr><td>Last Name:</td><td>' . oci_result($_sqlsts, 4) . '</td></tr>';
        print '<tr><td>Phone:</td><td>' . oci_result($_sqlsts, 5) . '</td></tr>';
        print '<tr><td>Email:</td><td>' . oci_result($_sqlsts, 6) . '</td></tr>';
        print '<tr><td>Gender:</td><td>' . oci_result($_sqlsts, 7) . '</td></tr>';
        print '<tr><td>Major:</td><td>' . oci_result($_sqlsts, 8) . '</td></tr>';
        print '<tr><td>If is local:</td><td>' . oci_result($_sqlsts, 9) . '</td></tr>';
        print '<tr><td>CV:</td><td><a href="' . oci_result($_sqlsts, 10) . '" target="_blank">Click to Open</a></td></tr>';
        print '<tr><td>Entrance Year:</td><td>' . oci_result($_sqlsts, 11) . '</td></tr>';
        $decode = lang_hash_decode(oci_result($_sqlsts, 12));
        print '<tr><td colspan="2">Language Preference:</td></tr><tr><td>English:</td><td>' . lang_decode($decode["eng"]) . '</td></tr>';
        print '<td>Cantonese:</td><td>' . lang_decode($decode["ctn"]) . '</td></tr>';
        print '<td>Putonghua:</td><td>' . lang_decode($decode["pth"]) . '</td></tr></table>';
        print '<form action="updateintersr.php" method="post"><input type="hidden" name="id" value='.$_GET["id"].'><input type="hidden" name="inid" value='.$_GET["inid"].'><input type="hidden" name="appid" value='.$_GET["appid"].'><input type="hidden" name="jobid" value='.$_GET["jobid"].'>Score: <input type="number" name="score" required value="' . oci_result($_sqlsts, 13) . '"><br>Remark:<br><textarea name="remark" rows="6" cols="50">'.oci_result($_sqlsts, 14).'</textarea><br><input type="submit" value="Give score and remark"></form><button type="button" onclick="window.location.href=\'deleteinter.php?id='.$_GET["id"].'&inid='.$_GET["inid"].'&jobid='.$_GET["jobid"].'\'">DELETE</button>';
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