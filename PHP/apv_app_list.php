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
    <title>Approve Application Page</title>
</head>
<body>
<h1>Need Approval Applications List</h1>
<?

$strSQL = "BEGIN APPROVE.VIEWNA_APP(:refcur); END;";
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
        <th width="91"> <div align="center">AppID </div></th>
        <th width="98"> <div align="center">JobID </div></th>
        <th width="198"> <div align="center">StudentID </div></th>
        <th width="97"> <div align="center">Score </div></th>
        <th width="59"> <div align="center">Is Successful </div></th>
        <th width="71"> <div align="center">IsValid </div></th>
    </tr>
    <?
    while($objResult = oci_fetch_array($refcur,OCI_BOTH))
    {
        ?>
        <tr>
            <td><div align="center"><?=$objResult["AppID"];?></div></td>
            <td><?=$objResult["JobID"];?></td>
            <td><?=$objResult["StudentID"];?></td>
            <td><div align="center"><?php if(isset($objResult["Score"])) echo $objResult["Score"];?></div></td>
            <td align="right"><?=$objResult["IsSuccessful"];?></td>
            <td align="right"><?=$objResult["IsValid"];?></td>
            <td align="center"><a href="apv_app.php?CusID=<?=$objResult["AppID"];?>&msg=Y">Approve</a></td>
            <td align="center"><a href="apv_app.php?CusID=<?=$objResult["AppID"];?>&msg=N">Disapprove</a></td>

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