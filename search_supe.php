<?php
session_start();
if (!isset($_SESSION['curUser'])) {
    // If not signed in
    header('Location: portal.php');
}
require ('job_db.inc');
require ('job_cn.inc');
$conn = db_connect();

$person_id = $_SESSION['curUser'];
if ($_SESSION['userType'] != 'ADMI') {
    oci_close($conn);
    die('Sorry but you have no permission to continue. ');
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Search for Supervisor Information</title>
</head>
<body bgcolor="#EEEEEE">
<h2>General search of supervisor information</h2>

<?php

function get_input($first = "")
{
    echo <<<END
  <form action="search_supe.php" method="post">
  Search:
  <input type="text" name="first" value="$first">
  <p> 
  <input type="submit">
  </form>
END;
}

if(!isset($_REQUEST['first'])) {
    echo "Enter text (Name, ID Phone or Email)<br>
         You can enter the complete name or an initial substring.<p>";
    get_input();
}
else {
    // check whether the input fields are empty before continuing
    if (empty($_REQUEST['first'])) {
        echo "You did not enter text in both 
          fields, please re-enter the information.<p>";
        get_input($_REQUEST['first']);
    }
    else {
        // if text has been entered in both input fields, then
        // create a database connection to Oracle XE using
        // password hr for user HR with a local connection to the XE database

        // execute the function that calls the PL/SQL stored procedure
        $emp = get_employees($conn, $_REQUEST['first']);

        // display results
        print_results($emp, 'Here are the Supervisor(s)~');

        // close the database connection
        oci_close($conn);
    }
}

// this functions calls a PL/SQL procedure that uses a ref cursor to fetch records
function get_employees($conn, $firstname)
{
    // execute the call to the stored PL/SQL procedure
    $sql = "BEGIN VIEW_PEOPLE.SUPE_GENERAL_SEARCH(:firstname,:refcur); END;";
    $stmt = oci_parse($conn, $sql);

    // bind the first and last name variables
    oci_bind_by_name($stmt, ':firstname', $firstname, 64);

    // bind the ref cursor
    $refcur = oci_new_cursor($conn);
    oci_bind_by_name($stmt, ':REFCUR', $refcur, -1, OCI_B_CURSOR);

    // execute the statement
    oci_execute($stmt);

    // treat the ref cursor as a statement resource
    oci_execute($refcur, OCI_DEFAULT);
    oci_fetch_all($refcur, $employeerecords, null, null, OCI_FETCHSTATEMENT_BY_ROW);

    // return the results
    return ($employeerecords);
}

// this function prints information in the returned records
function print_results($returned_records, $report_title)
{
    echo '<h3>'.htmlentities($report_title).'</h3>';
    if (!$returned_records) {
        echo '<p>No Records Found</p>';
    }
    else {
        echo '<table border="1">';
        // print one row for each record retrieved
        // put the fields of each record in separate table cells
        foreach ($returned_records as $row) {
            echo '<tr>';
            foreach ($row as $field) {
                print '<td>'.
                    ($field ? htmlentities($field) : '&nbsp;').'</td>';
            }
        }
        echo '</table>';
    }
    echo '<input type="button" name="Go Back" value="Back" onclick="location.href=\'search_supe.php\'">';
}

?>

</body>
</html>