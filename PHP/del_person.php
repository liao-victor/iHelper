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
    <title>Delete Person</title>
</head>
<body>
<?

$strSQL = "BEGIN VIEW_PEOPLE.VIEW_ALL_PERSON(:refcur); END;";
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
        <th width="91"> <div align="center">PersonID </div></th>
        <th width="98"> <div align="center">First Name </div></th>
        <th width="198"> <div align="center">Last Name </div></th>
        <th width="97"> <div align="center">Phone </div></th>
        <th width="59"> <div align="center">Email </div></th>
        <th width="30"> <div align="center">Delete </div></th>
    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div align="center"><?=$objResult["PersonID"];?></div></td>
            <td><?=$objResult["FirstName"];?></td>
            <td><?=$objResult["LastName"];?></td>
            <td><?=$objResult["PhoneNo"];?></td>
            <td><?=$objResult["Email"];?></td>
            <td align="center"><a href="del_exct.php?CusID=<?=$objResult["PersonID"];?>">Delete</a></td>

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