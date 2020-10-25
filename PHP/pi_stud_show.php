<?php
session_start();
if (!isset($_SESSION['curUser'])) {
    // If not signed in
    header('Location: portal.php');
}
require ('job_db.inc');
require ('job_cn.inc');
$objConnect = db_connect();

$person_id = $_SESSION['curUser'];
if ($_SESSION['userType'] != 'ADMI') {
    oci_close($objConnect);
    die('Sorry but you have no permission to continue. ');
}
?>
<html>
<head>
    <title>Modify Student Info</title>
</head>
<body>
<?

$strSQL = "BEGIN VIEW_PEOPLE.VIEW_ALL_STUDENT(:refcur); END;";
$objParse = oci_parse($objConnect, $strSQL);

// bind the ref cursor
$refcur = oci_new_cursor($objConnect);
oci_bind_by_name($objParse, ':REFCUR', $refcur, -1, OCI_B_CURSOR);

// execute the statement
oci_execute($objParse);

// treat the ref cursor as a statement resource
oci_execute($refcur, OCI_DEFAULT);

?>
<table width="600" border="1">
    <tr>
        <th width="91"> <div align="center">Person <br>ID  </div></th>
        <th width="98"> <div align="center">First <br>Name  </div></th>
        <th width="98"> <div align="center">Last <br>Name  </div></th>
        <th width="98"> <div align="center">Phone </div></th>
        <th width="198"> <div align="center">Email </div></th>
        <th width="97"> <div align="center">Major </div></th>
        <th width="59"> <div align="center">Gender </div></th>
        <th width="71"> <div align="center">Local <br>student?</div></th>
    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div  align="center"><?=$objResult["PersonID"];?></div></td>
            <td><?=$objResult["FirstName"];?></td>
            <td><?=$objResult["LastName"];?></td>
            <td><?=$objResult["PhoneNo"];?></td>
            <td><?=$objResult["Email"];?></td>
            <td><div  align="center"><?=$objResult["MajorAbbr"];?></div></td>
            <td align="right"><?=$objResult["Gender"];?></td>
            <td align="right"><?=$objResult["IsLocal"];?></td>
            <td align="center"><a  href="pi_stud_update.php?CusID=<?=$objResult["PersonID"];?>">Edit</a></td>
        </tr>
        <?
    }
    ?>
</table>
<?
oci_close($objConnect);
?>
</body>
</html>