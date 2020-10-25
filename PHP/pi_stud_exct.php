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

$aid = $_GET["CusID"];
$fname = $_POST["txtFName"];
$lname = $_POST["txtLName"];
$pn = $_POST["txtPhone"];
$em = $_POST["txtEmail"];
$midd = $_POST["txtMajorID"];
$ilocal = $_POST["txtLocal"];
$pcode = $_POST["txtCode"];

$sone = $_POST["txtSone"];
$stwo = $_POST["txtStwo"];
$city = $_POST["txtCity"];
$state = $_POST["txtState"];
$zip = $_POST["txtZip"];

$strSQL = "call UPDATE_PEOPLE.ISTUDENT('$aid','$fname','$lname','$pn','$em','$midd','$ilocal','$pcode')";
$objParse = oci_parse($objConnect, $strSQL);
$objExecute = oci_execute($objParse, OCI_DEFAULT);

$strSQL = "call UPDATE_PEOPLE.IADDRESS('$aid','$sone','$stwo','$city','$state','$zip')";
$objParse = oci_parse($objConnect, $strSQL);
$objExecute = oci_execute($objParse, OCI_DEFAULT);


if($objExecute)
{
    echo "Save completed.";
}
else
{
    oci_rollback($objConnect); //*** RollBack Transaction ***//
    $e = oci_error($objParse);
    echo "Error Save [".$e['message']."]";
}
oci_close($objConnect);
?>

<input type="button" name="Go Back" value="Back" onclick="location.href='pi_stud_show.php'">
</body>
</html>