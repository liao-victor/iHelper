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
    <title>Contract Page</title>
</head>
<body>
<h1>Need Approval Contract List</h1>
<?

$strSQL = "BEGIN APPROVE.VIEWNA_CONTRACT(:refcur); END;";
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
        <th width="30"> <div align="center">Contract <br>ID </div></th>
        <th width="30"> <div align="center">JobID </div></th>
        <th width="60"> <div align="center">Student <br>ID </div></th>
        <th width="60"> <div align="center">Supervisor <br>ID </div></th>
        <th width="30"> <div align="center">Hour <br>per Week</div></th>
        <th width="30"> <div align="center">Week</div></th>
        <th width="30"> <div align="center">Hour <br>salary</div></th>
        <th width="60"> <div align="center">Start Date</div></th>
        <th width="60"> <div align="center">End Date</div></th>
        <th width="30"> <div align="center">Active</div></th>
        <th width="60"> <div align="center">Remark</div></th>
        <th width="30"> <div align="center">Validity</div></th>
    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div align="center"><?=$objResult["CtrtNo"];?></div></td>
            <td><?=$objResult["JobID"];?></td>
            <td><?=$objResult["StudentID"];?></td>
            <td><?=$objResult["SupervisorID"];?></td>
            <td><?=$objResult["HrPerWeek"];?></td>
            <td><?=$objResult["Weeks"];?></td>
            <td><?=$objResult["HrSalary"];?></td>
            <td><?=$objResult["StartDate"];?></td>
            <td><?=$objResult["EndDate"];?></td>
            <td align="right"><?=$objResult["IsActive"];?></td>
            <td><div align="center"><?php if(isset($objResult["Remark"])) echo $objResult["Remark"];?></div></td>
            <td align="right"><?=$objResult["IsValid"];?></td>
            <td align="center"><a href="apv_con.php?CuID=<?=$objResult["CtrlNo"];?>&msg=Y">Approve</a></td>
            <td align="center"><a href="apv_con.php?CuID=<?=$objResult["CtrlNo"];?>&msg=N">Disapprove</a></td>

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