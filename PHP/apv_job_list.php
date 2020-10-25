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
    <title>Job Page</title>
</head>
<body>
<h1>Need Approval Job List</h1>
<?

$strSQL = "BEGIN APPROVE.VIEWNA_JOB(:refcur); END;";
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
        <th width="30"> <div align="center">JobID </div></th>
        <th width="60"> <div align="center">Name </div></th>
        <th width="60"> <div align="center">Description </div></th>
        <th width="30"> <div align="center">Hour <br>salary </div></th>
        <th width="30"> <div align="center">Hour <br>per week</div></th>
        <th width="30"> <div align="center">Min <br>week</div></th>
        <th width="30"> <div align="center">Max <br>week</div></th>
        <th width="30"> <div align="center">Continuous? </div></th>
        <th width="30"> <div align="center">Quota </div></th>
        <th width="30"> <div align="center">Require Interview</div></th>
        <th width="30"> <div align="center">Min <br>Year</div></th>
        <th width="30"> <div align="center">Preference <br>code</div></th>
        <th width="90"> <div align="center">Last Mod <br>Date </div></th>
        <th width="30"> <div align="center">Open?</div></th>
        <th width="90"> <div align="center">Deadline</div></th>
        <th width="30"> <div align="center">Validity</div></th>
    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div align="center"><?=$objResult["JobID"];?></div></td>
            <td><?=$objResult["Name"];?></td>
            <td><div align="center"><?php if(isset($objResult["Description"])) echo $objResult["Description"];?></div></td>
            <td><div align="center"><?php if(isset($objResult["HrSalary"])) echo $objResult["HrSalary"];?></div></td>
            <td><div align="center"><?php if(isset($objResult["HrPerWeek"])) echo $objResult["HrPerWeek"];?></div></td>
            <td><div align="center"><?php if(isset($objResult["MinWeek"])) echo $objResult["MinWeek"];?></div></td>
            <td><div align="center"><?php if(isset($objResult["MaxWeek"])) echo $objResult["MaxWeek"];?></div></td>
            <td><?=$objResult["IsContinuous"];?></td>
            <td><?=$objResult["Quota"];?></td>
            <td><?=$objResult["IsReqInterview"];?></td>
            <td><div align="center"><?php if(isset($objResult["MinStudyYear"])) echo $objResult["MinStudyYear"];?></div></td>
            <td><div align="center"><?php if(isset($objResult["PrefCode"])) echo $objResult["PrefCode"];?></div></td>
            <td align="right"><?=$objResult["LastModDate"];?></td>
            <td align="right"><?=$objResult["IsOpen"];?></td>
            <td align="right"><?=$objResult["AppDeadline"];?></td>
            <td align="right"><?=$objResult["IsValid"];?></td>
            <td align="center"><a href="apv_job.php?CuID=<?=$objResult["JobID"];?>&msg=Y">Approve</a></td>
            <td align="center"><a href="apv_job.php?CuID=<?=$objResult["JobID"];?>&msg=N">Disapprove</a></td>

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