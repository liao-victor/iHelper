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
    print $_GET['id'];
    echo <<<END
     '">GO BACK</button></div>
    <div class="account-info"><a href="portal.php">$curUser</a></div>
</div>
END;
}

function ui_print_job_list()
{
    GLOBAL $conn;
    // Open the HTML table.
    echo <<<END
  <form action="takerecord.php" method="post"><table><tr><td>Job ID:</td><td><input type="number" name="jobid" value="
END;
        print $_GET["id"].'" readonly></td></tr><tr><td>Supervisor ID:</td><td><input type="text" name="supid" value="'.$_SESSION["curUser"].'" readonly> </td></tr><tr><td>Student ID:</td><td><input type="text" name="stuid" required></td></tr>';
        print '<tr><td>Type:</td><td><input type="radio" name="type" value="P"> Positive<br><input type="radio" name="type" value="M" checked> Neutral<br><input type="radio" name="type" value="N"> Negative</td></tr>';
        print '<tr><td>Describe:</td><td><textarea name="desc" rows="6" cols="50"></textarea></td></tr>';
        print '<tr><td>Payment:</td><td><input type="number" name="pay"
></td></tr></td></tr></table><input type="submit" value="Create"></form>';
}

function print_result($data){
    $out='<input type="radio" name="result" value="P"';
    if($data=='P') $out=$out.'checked';
    $out=$out.'> Pending<br>
  <input type="radio" name="result" value="Y" ';
    if($data=='Y') $out=$out.'checked';
    $out=$out.'> Yes<br>
  <input type="radio" name="result" value="N" ';
    if($data=='N') $out=$out.'checked';
    $out=$out.'>No';
    return $out;
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