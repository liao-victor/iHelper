<!--major requirement to be added-->
<?php
session_start();
if (!isset($_SESSION['curUser'])) {
    // If not signed in
    header('Location: portal.php');
} else {

    include("job_ui.inc");
    include("job_cn.inc");
    include("job_db.inc");
    $conn = db_connect();

    $person_id = $_SESSION['curUser'];

    if ($_SESSION['userType'] == 'STUD') {
        oci_close($conn);
        die('Sorry but you have no permission to continue. ');
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

            $stmt = "BEGIN JOB_LIST.ADD_JOB('$job_name', '$job_desc', $job_salary, $job_hpw, $job_minweeks, $job_maxweeks, '$job_iscon', $job_quota, '$job_isreqiv', $job_minyear, $job_prefcode, '$job_isopen', '$job_appddl', '$person_id'); END;";
            $sc = oci_parse($conn, $stmt);
            $scrst = oci_execute($sc);
            if ($scrst == true)
                if ($_SESSION['userType'] == 'ADMI'){
                    echo 'Successfully created!';
                } elseif ($_SESSION['userType'] == 'SUPE') {
                    echo 'Successfully created! Please wait for administrators to approve! ';
                }
            else
                echo "Failed! Please <a href=''>try again</a>.";
        }
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
        <input type="text" id="job_name" name="name" value="" required><br>
        <label for="job_desc">Description: </label><br>
        <textarea id="job_desc" name="desc" rows="4" cols="50"></textarea><br>
        <label for="job_quota">Quota: </label>
        <input type="number" id="job_quota" name="quota" value="" required><br>
        <label for="job_appddl">Application deadline: </label>
        <input type="text" id="job_appddl" name="appddl" value="" pattern="^[12]\d{3}\-(?:0[0-9]|1[012])\-(?:[0-2][0-9]|3[01]) (?:[01][0-9]|2[0-3]):(?:[0-5][0-9]):(?:[0-5][0-9])$" required> Example: 2017-12-24 23:59:59<br>
        <label for="job_hrslr">Hourly salary: </label>
        <input type="number" id="job_hrslr" name="hrslr" value=""><br>
        <label for="job_hpw">Hours per week: </label>
        <input type="number" id="job_hpw" name="hpw" value=""><br>
        <label for="job_minweeks">Minimum weeks of job: </label>
        <input type="number" id="job_minweeks" name="minweeks" value=""><br>
        <label for="job_maxweeks">Maximum weeks of job: </label>
        <input type="number" id="job_maxweeks" name="maxweeks" value=""><br>
        <label for="job_minyr">Minimum study year: </label>
        <input type="number" id="job_minyr" name="minyr" value=""><br>
        <label for="job_iscon_yes">Is continuous: </label>
        <input type="radio" id="job_iscon_yes" name="iscon" value="Y" required>
        <label for="job_iscon_no">Is NOT continuous: </label>
        <input type="radio" id="job_iscon_no" name="iscon" value="N"><br>
        <label for="job_isreqiv_yes">Interview required: </label>
        <input type="radio" id="job_isreqiv_yes" name="isreqiv" value="Y" required>
        <label for="job_isreqiv_no">Interview NOT required: </label>
        <input type="radio" id="job_isreqiv_no" name="isreqiv" value="N"><br>
        <label for="job_pctn_2">Require HIGH Cantonese level: </label>
        <input type="radio" id="job_pctn_2" name="pctn" value=2 required>
        <label for="job_pctn_1">Require MEDIUM Cantonese level: </label>
        <input type="radio" id="job_pctn_1" name="pctn" value=1>
        <label for="job_pctn_0">Require NO Cantonese skills: </label>
        <input type="radio" id="job_pctn_0" name="pctn" value=0><br>
        <label for="job_peng_2">Require HIGH English level: </label>
        <input type="radio" id="job_peng_2" name="peng" value=2 required>
        <label for="job_peng_1">Require MEDIUM English level: </label>
        <input type="radio" id="job_peng_1" name="peng" value=1>
        <label for="job_peng_0">Require NO English skills: </label>
        <input type="radio" id="job_peng_0" name="peng" value=0><br>
        <label for="job_ppth_2">Require HIGH Putonghua level: </label>
        <input type="radio" id="job_ppth_2" name="ppth" value=2 required>
        <label for="job_ppth_1">Require MEDIUM Putonghua level: </label>
        <input type="radio" id="job_ppth_1" name="ppth" value=1>
        <label for="job_ppth_0">Require NO Putonghua skills: </label>
        <input type="radio" id="job_ppth_0" name="ppth" value=0><br>
        <label for="job_isopen_yes">Open for application: </label>
        <input type="radio" id="job_isopen_yes" name="isopen" value="Y" required>
        <label for="job_isopen_no">Closed for application: </label>
        <input type="radio" id="job_isopen_no" name="isopen" value="N"><br>
        <input type="submit" name="submit" value="Submit">
    </form>
    </body>
    </html>

<?php
        oci_close($conn);
    }
}