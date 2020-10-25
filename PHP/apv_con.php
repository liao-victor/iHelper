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
    <title>Done!</title>
</head>
<body>
<h2>~Action done~</h2>
<?

$conid = $_GET["CuID"];
$prompt = $_GET["msg"];
$strSQL = "call APPROVE.CONTRACT_CHANGES('$conid','$prompt')";
$objParse = oci_parse($objConnect, $strSQL);
$objExecute = oci_execute($objParse, OCI_DEFAULT);

if($objExecute)
{
    echo "Action done!";
}
else
{
    $e = oci_error($objParse);
    echo "Error Delete [".$e['message']."]";
}
oci_close($objConnect);
?>
<input type="button" name="Go Back" value="Back" onclick="location.href='apv_con_list.php'">
</body>
</html>
