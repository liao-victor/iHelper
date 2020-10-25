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
    <title>Supervisor Objections Page</title>
</head>
<body>
<h1>Need Approval Objection List</h1>
<?

$strSQL = "BEGIN APPROVE.VIEWNA_OBJECTION(:refcur); END;";
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
        <th width="30"> <div align="center">Objection <br>ID </div></th>
        <th width="60"> <div align="center">Record <br>ID </div></th>
        <th width="60"> <div align="center">Type </div></th>
        <th width="30"> <div align="center">Reason </div></th>
        <th width="30"> <div align="center">Supervisor <br>ID</div></th>
        <th width="30"> <div align="center">Approve <br>status</div></th>

    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div align="center"><?=$objResult["ObjectionID"];?></div></td>
            <td><?=$objResult["RecordID"];?></td>
            <td><?=$objResult["Type"];?></td>
            <td><div align="center"><?php if(isset($objResult["Reason"])) echo $objResult["Reason"];?></div></td>
            <td align="right"><?=$objResult["SupervisorID"];?></td>
            <td align="right"><?=$objResult["IsApproved"];?></td>
            <td align="center"><a href="apv_obj.php?CuID=<?=$objResult["ObjectionID"];?>&msg=Y">Approve</a></td>
            <td align="center"><a href="apv_obj.php?CuID=<?=$objResult["ObjectionID"];?>&msg=N">Disapprove</a></td>
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