<?php
session_start();
if (!isset($_SESSION['curUser'])) {
    // If not signed in
    header('Location: portal.php');
} elseif (!isset($_GET['id'])) {
    header('Location: jobboard.php');
} else {

    include("job_ui.inc");
    include("job_cn.inc");
    include("job_db.inc");
    $conn = db_connect();

    $person_id = $_SESSION['curUser'];
    $job_id = intval($_GET['id']);

    $permission = db_get_permission($conn, $person_id, $job_id);

    if ($permission == 0) {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
    }

    $rtn_value = oci_new_cursor($conn);
    $stmt = "BEGIN JOB_LIST.VIEW_JOB_DETAIL($job_id, '$person_id', :OUT_TABLE); END;";
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value, -1, OCI_B_CURSOR);

    $scrst = oci_execute($sc);
    oci_execute($rtn_value);
    oci_fetch($rtn_value);
    $lang_pref = lang_hash_decode(oci_result($rtn_value, 12));


    if (oci_result($rtn_value, 13) == 'P' || oci_result($rtn_value, 13) == 'D') {
        echo 'Sorry but you have no permission to continue. Please wait for the approval of the administrator. ';
    }

    if (isset($_POST['submit'])) {  // after submit post
        // date format check
        if (preg_match("/^[12]\d{3}\-(?:0[0-9]|1[012])\-(?:[0-2][0-9]|3[01]) (?:[01][0-9]|2[0-3]):(?:[0-5][0-9]):(?:[0-5][0-9])$/", $_POST['appddl']) == 0) {
            echo "The input format of the application deadline is incorrect! Please <a href=''>try again</a>. ";
        }
        // min-max weeks check
        elseif (intval($_POST['minweeks']) > intval($_POST['maxweeks']) && intval($_POST['maxweeks']) != 0) {
            echo "The minimum weeks of job is larger than the maximum weeks of job! Please <a href=''>try again</a>. ";
        }

        else {
            $job_name = $_POST['name'];
            $job_desc = $_POST['desc'];
            $job_salary = $_POST['hrslr'] == '' ? 'NULL' : $_POST['hrslr'];
            $job_hpw = $_POST['hpw'] == '' ? 'NULL' : $_POST['hpw'] ;
            $job_minweeks = $_POST['minweeks'] == '' ? 'NULL' : $_POST['minweeks'];
            $job_maxweeks = $_POST['maxweeks'] == '' ? 'NULL' : $_POST['maxweeks'];
            $job_iscon = $_POST['iscon'];
            $job_quota = $_POST['quota'];
            $job_isreqiv = $_POST['isreqiv'];
            $job_minyear = $_POST['minyr'] == '' ? 'NULL' : $_POST['minyr'];
            $job_prefcode = strval(lang_hash_encode($_POST['pctn'], $_POST['peng'], $_POST['ppth']));
            $job_isopen = $_POST['isopen'];
            $job_appddl = $_POST['appddl'];

            $stmt = "BEGIN JOB_LIST.UPDATE_JOB($job_id, '$job_name', '$job_desc', $job_salary, $job_hpw, $job_minweeks, $job_maxweeks, '$job_iscon', $job_quota, '$job_isreqiv', $job_minyear, $job_prefcode, '$job_isopen', '$job_appddl', '$person_id'); END;";
            $sc = oci_parse($conn, $stmt);
            $scrst = oci_execute($sc);
            if ($scrst == true)
                if ($permission == 2){
                    echo 'Successfully modified!';
                } else {
                    echo 'Successfully modified! Please wait for administrators to approve! ';
                }
            else
                echo "Failed! Please <a href=''>try again</a>.";
        }
        oci_close($conn);
    } elseif (isset($_POST['remove'])) {
        if ($permission == 2) {
            $stmt = "BEGIN DESTROY.DJOB($job_id); END;";
            $sc = oci_parse($conn, $stmt);
            $scrst = oci_execute($sc);
        } elseif ($permission == 1) {
            $stmt = "BEGIN DESTROY.DJOB_REQUEST($job_id); END;";
            $sc = oci_parse($conn, $stmt);
            $scrst = oci_execute($sc);
        }
        if ($scrst == true)
            if ($permission == 2){
                echo "Successfully removed!";
            } else {
                echo "Successfully submitted removal request! Please wait for administrators to approve! ";
            }
        else
            echo "Failed! Please <a href=''>try again</a>.";
        oci_close($conn);
    } else {

    ?>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Modify Job</title>
    </head>
    <body>
    <form method="post" action="">
        <label for="job_name">Job Name: </label>
        <input type="text" id="job_name" name="name" value="<?php echo oci_result($rtn_value, 2); ?>"><br>
        <label for="job_desc">Description: </label><br>
        <textarea id="job_desc" name="desc" rows="4" cols="50"><?php echo oci_result($rtn_value, 3); ?></textarea><br>
        <label for="job_quota">Quota: </label>
        <input type="number" id="job_quota" name="quota" value="<?php echo oci_result($rtn_value, 9); ?>"><br>
        <label for="job_appddl">Application deadline: </label>
        <input type="text" id="job_appddl" name="appddl" value="<?php echo oci_result($rtn_value, 16); ?>"> Example: 2017-12-24 23:59:59<br>
        <label for="job_hrslr">Hourly salary: </label>
        <input type="number" id="job_hrslr" name="hrslr" value="<?php echo oci_result($rtn_value, 4); ?>"><br>
        <label for="job_hpw">Hours per week: </label>
        <input type="number" id="job_hpw" name="hpw" value="<?php echo oci_result($rtn_value, 5); ?>"><br>
        <label for="job_minweeks">Minimum weeks of job: </label>
        <input type="number" id="job_minweeks" name="minweeks" value="<?php echo oci_result($rtn_value, 6); ?>"><br>
        <label for="job_maxweeks">Maximum weeks of job: </label>
        <input type="number" id="job_maxweeks" name="maxweeks" value="<?php echo oci_result($rtn_value, 7); ?>"><br>
        <label for="job_minyr">Minimum study year: </label>
        <input type="number" id="job_minyr" name="minyr" value="<?php echo oci_result($rtn_value, 11); ?>"><br>
        <label for="job_iscon_yes">Is continuous: </label>
        <input type="radio" id="job_iscon_yes" name="iscon" value="Y"<?php if (oci_result($rtn_value, 8) == 'Y') echo ' checked' ?>>
        <label for="job_iscon_no">Is NOT continuous: </label>
        <input type="radio" id="job_iscon_no" name="iscon" value="N"<?php if (oci_result($rtn_value, 8) == 'N') echo ' checked' ?>><br>
        <label for="job_isreqiv_yes">Interview required: </label>
        <input type="radio" id="job_isreqiv_yes" name="isreqiv" value="Y"<?php if (oci_result($rtn_value, 10) == 'Y') echo ' checked' ?>>
        <label for="job_isreqiv_no">Interview NOT required: </label>
        <input type="radio" id="job_isreqiv_no" name="isreqiv" value="N"<?php if (oci_result($rtn_value, 10) == 'N') echo ' checked' ?>><br>
        <label for="job_pctn_2">Require HIGH Cantonese level: </label>
        <input type="radio" id="job_pctn_2" name="pctn" value=2<?php if ($lang_pref['ctn'] == 2) echo ' checked' ?>>
        <label for="job_pctn_1">Require MEDIUM Cantonese level: </label>
        <input type="radio" id="job_pctn_1" name="pctn" value=1<?php if ($lang_pref['ctn'] == 1) echo ' checked' ?>>
        <label for="job_pctn_0">Require NO Cantonese skills: </label>
        <input type="radio" id="job_pctn_0" name="pctn" value=0<?php if ($lang_pref['ctn'] == 0) echo ' checked' ?>><br>
        <label for="job_peng_2">Require HIGH English level: </label>
        <input type="radio" id="job_peng_2" name="peng" value=2<?php if ($lang_pref['eng'] == 2) echo ' checked' ?>>
        <label for="job_peng_1">Require MEDIUM English level: </label>
        <input type="radio" id="job_peng_1" name="peng" value=1<?php if ($lang_pref['eng'] == 1) echo ' checked' ?>>
        <label for="job_peng_0">Require NO English skills: </label>
        <input type="radio" id="job_peng_0" name="peng" value=0<?php if ($lang_pref['eng'] == 0) echo ' checked' ?>><br>
        <label for="job_ppth_2">Require HIGH Putonghua level: </label>
        <input type="radio" id="job_ppth_2" name="ppth" value=2<?php if ($lang_pref['pth'] == 2) echo ' checked' ?>>
        <label for="job_ppth_1">Require MEDIUM Putonghua level: </label>
        <input type="radio" id="job_ppth_1" name="ppth" value=1<?php if ($lang_pref['pth'] == 1) echo ' checked' ?>>
        <label for="job_ppth_0">Require NO Putonghua skills: </label>
        <input type="radio" id="job_ppth_0" name="ppth" value=0<?php if ($lang_pref['pth'] == 0) echo ' checked' ?>><br>
        <label for="job_isopen_yes">Open for application: </label>
        <input type="radio" id="job_isopen_yes" name="isopen" value="Y"<?php if (oci_result($rtn_value, 15) == 'Y') echo ' checked' ?>>
        <label for="job_isopen_no">Closed for application: </label>
        <input type="radio" id="job_isopen_no" name="isopen" value="N"<?php if (oci_result($rtn_value, 15) == 'N') echo ' checked' ?>><br>
        <input type="submit" name="submit" value="Submit">
        <input type="submit" name="remove" value="Remove">
<!--radio button state restore [COMPLETE] -->
<!--database operation after post [COMPLETE] -->
<!--study year filter [COMPLETE] -->
<!--beautify-->
    </form>
    </body>
    </html>

<?php
        oci_close($conn);
    }
}