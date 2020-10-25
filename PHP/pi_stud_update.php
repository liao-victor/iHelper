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

    $idd = $_GET["CusID"];
    $strSQL = "BEGIN VIEW_PEOPLE.VIEW_STUD_DETAIL('$idd',:refcur); END;";
    $objParse = oci_parse($objConnect, $strSQL);

    // bind the ref cursor
    $refcur = oci_new_cursor($objConnect);
    oci_bind_by_name($objParse, ':REFCUR', $refcur, -1, OCI_B_CURSOR);

    // execute the statement
    oci_execute($objParse);

    // treat the ref cursor as a statement resource
    oci_execute($refcur, OCI_DEFAULT);
    $objResult = oci_fetch_array($refcur);
    if(!$objResult)
    {
        echo "Not found StudentID=".$_GET["CusID"];
    }
    else
    {

        ?>
    <form  action="pi_stud_exct.php?CusID=<?=$objResult["PersonID"];?>"  name="frmEdit" method="post">
        <table width="600" border="1">
            <tr>
                <th width="91"> <div align="center">Person <br>ID  </div></th>
                <th width="98"> <div align="center">First <br>Name  </div></th>
                <th width="98"> <div align="center">Last <br>Name  </div></th>
                <th width="98"> <div align="center">Phone </div></th>
                <th width="198"> <div align="center">Email </div></th>
                <th width="97"> <div align="center">Major </div></th>
                <th width="71"> <div align="center">Local <br>student?</div></th>
                <th width="59"> <div align="center">Pref <br>code </div></th>
            </tr>
            <tr>
                <td><div  align="center"><?=$objResult["PersonID"];?></div></td>
                <td><input type="text" name="txtFName" size="10"  value="<?=$objResult["FirstName"];?>" required></td>
                <td><input type="text" name="txtLName" size="10"  value="<?=$objResult["LastName"];?>" required></td>
                <td><input type="text" name="txtPhone" size="10"  value="<?=$objResult["PhoneNo"];?>" required></td>
                <td><input type="email" name="txtEmail" size="25"  value="<?=$objResult["Email"];?>" required></td>
                <td><input type="text" name="txtMajorID" size="10"  value="<?=$objResult["MajorID"];?>" required></td>
                <td><input type="text" name="txtLocal" size="5"  value="<?=$objResult["IsLocal"];?>" required></td>
                <td><input type="number" min="0" max="26" name="txtCode" size="5"  value="<?=$objResult["Prefcode"];?>" required></td>
            </tr>
        </table>
        <table width="600" border="1">
            <tr>
                <th width="98"> <div align="center">Street Addr1 </div></th>
                <th width="98"> <div align="center">Street Addr2 </div></th>
                <th width="97"> <div align="center">City </div></th>
                <th width="71"> <div align="center">State </div></th>
                <th width="59"> <div align="center">ZipCode </div></th>
            </tr>
            <tr>
                <td><input type="text" name="txtSone" size="35"  value="<?=$objResult["StreetAddr1"];?>" required></td>
                <td><input type="text" name="txtStwo" size="35"  value="<?=$objResult["StreetAddr2"];?>" required></td>
                <td><input type="text" name="txtCity" size="15"  value="<?=$objResult["City"];?>" required></td>
                <td><input type="text" name="txtState" size="14"  value="<?=$objResult["State"];?>" required></td>
                <td><input type="text" name="txtZip" size="10"  value="<?=$objResult["ZipCode"];?>" required></td>
            </tr>
        </table>
        <input type="submit" name="submit" value="submit">
        <?
    }
    oci_close($objConnect);
    ?>
</form>
</body>
</html>