<html lang="en">

<head>
    <title>User Portal - iHelper</title>
    <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link href="portal.css" media="screen" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto+Mono" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Raleway:100,200" rel="stylesheet">
</head>

<body>
<div class="content-box">
    <h1 class="title">iHelper</h1>

<?php
session_start();
if (isset($_POST['signout'])) {     // Action: Sign out
    if (isset($_SESSION['curUser'])) {
        session_destroy();
        echo "Signed out successfully. ";
        echo '<a href="" class="portal-btn">Sign In</a>';
    } else {
        header("Refresh:0");        // Refresh the page to show sign-in form
    }
} else if (isset($_POST['signin'])) {   // Action: Sign in
    $_SESSION['curUser'] = null;        // parameter declaration
    $_SESSION['userType'] = null;
    $db_host = 'DB_LINK'; // Connect to database
    $db_user = '"USER_NAME"';
    $db_pass = 'PASSWORD';
    $conn = oci_connect($db_user, $db_pass, $db_host);
    if (!$conn) {
        die('Failed to establish the connection to server: ' . oci_error());
    }

    $ID = $_POST['ID'];     // database connected
    $PW = $_POST['PW'];
    $rtn_value = -1;
    $stmt = "BEGIN UTIL.SignIn_Check('$ID', '$PW', :isSuccessful); END;";    // call db procedure
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':isSuccessful', $rtn_value);
    $exe_result = oci_execute($sc);

    if (!$exe_result || $rtn_value == -1) { // unexpected exceptions
        die('Sign in failed. ' . oci_error());
    } else {
        if ($rtn_value == 0) {  // User not found
            echo 'This account does not exist.';
            echo '<a href="" class="portal-btn">Try Again</a>';
        } elseif ($rtn_value == 1) {    // User found but password incorrect
            echo 'Password is incorrect.';
            echo '<a href="" class="portal-btn">Try Again</a>';
        } else {    // SUCCESS
            $_SESSION['curUser'] = $ID;
            if ($rtn_value == 2) {
                $_SESSION['userType'] = 'STUD';
            } elseif ($rtn_value == 3) {
                $_SESSION['userType'] = 'SUPE';
            } elseif ($rtn_value == 4) {
                $_SESSION['userType'] = 'ADMI';
            }
            echo '<a href="" class="portal-btn">Redirecting...</a>';
            header("Refresh:0");
            die();
        }
    }

    oci_close($conn);
} else {    // Not signed in and no other action: show sign-in form.
    if (!isset($_SESSION['curUser']) || (isset($_SESSION['curUser']) && $_SESSION['curUser'] == null)) {
        ?>

    <div id="signin-box">
        <form id="signin" method="post" autocomplete="off">
            <input class="signin-input" name="ID" type="text" spellcheck="false" id="usr" placeholder="NetID" required>
            <input class="signin-input" name="PW" type="password" id="pw" placeholder="NetPassword" required>
            <input name="signin" class="portal-btn" type="submit" value="Sign In">
        </form>
    </div>

        <?php
    } else {   // already signed in ?>

        Signed in as: <b><?= $_SESSION['curUser'] ?></b> [<?php
            if ($_SESSION['userType'] == 'STUD')
                echo "Student";
            elseif ($_SESSION['userType'] == 'SUPE')
                echo "Supervisor";
            elseif ($_SESSION['userType'] == 'ADMI')
                echo "Administrator"
        ?>]
<?php
        if (isset($_GET['approve']) && $_SESSION['userType'] == 'ADMI') { ?>
            <a href="apv_app_list.php" class="portal-btn">Approve Applications</a>
            <a href="apv_con_list.php" class="portal-btn">Approve Contracts</a>
            <a href="apv_job_list.php" class="portal-btn">Approve Job Modifications</a>
            <a href="apv_obj_list.php" class="portal-btn">Approve Objections</a>
            <a href="<?=$_SERVER['PHP_SELF']?>" class="portal-btn">Back</a>
        <?php }
        elseif (isset($_GET['pi_manage']) && $_SESSION['userType'] == 'ADMI') { ?>
            <a href="pi_stud_show.php" class="portal-btn">Info Management: Student</a>
            <a href="pi_supe_show.php" class="portal-btn">Info Management: Supervisor</a>
            <a href="<?=$_SERVER['PHP_SELF']?>" class="portal-btn">Back</a>
        <?php }
        elseif (isset($_GET['search']) && $_SESSION['userType'] == 'ADMI') { ?>
            <a href="search_stud.php" class="portal-btn">Search Students</a>
            <a href="search_supe.php" class="portal-btn">Search Supervisors</a>
            <a href="<?=$_SERVER['PHP_SELF']?>" class="portal-btn">Back</a>
        <?php } else {
        ?>
        <a href="jobboard.php" class="portal-btn">Job Board</a>
        <?php
        if ($_SESSION['userType'] == 'SUPE') { ?>
            <a href="myjobboard.php" class="portal-btn">My Jobs</a>
            <a href="job_create.php" class="portal-btn">Create a Job</a>
            <a href="search_stud.php" class="portal-btn">Search Students</a>
        <?php }
        elseif ($_SESSION['userType'] == 'ADMI') {
            echo '<a href="' . $_SERVER['PHP_SELF'] . '?approve" class="portal-btn">Requests to Approve...</a>';
            echo '<a href="' . $_SERVER['PHP_SELF'] . '?pi_manage" class="portal-btn">Personal Info Management...</a>';
            echo '<a href="' . $_SERVER['PHP_SELF'] . '?search" class="portal-btn">Search...</a>';
            echo '<a href="job_create.php" class="portal-btn">Create a Job</a>';
            echo '<a href="del_person.php" class="portal-btn">Remove a Person</a>';
        } elseif ($_SESSION['userType'] == 'STUD') { ?>
            <a href="application.php" class="portal-btn">Application Board</a>
            <a href="interview.php" class="portal-btn">Interview Board</a>
            <a href="attendedjob.php" class="portal-btn">Job Management</a>
            <a href="personinfo.php" class="portal-btn">Person Information Management</a>
        <?php }
        ?>
        <form method="post">
            <input name="signout" type="submit" class="portal-btn" value="Sign Out">
        </form>

        <?php
        }
    }
}
?>

    </div>
</body>
</html>