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

    $job_id = intval($_GET['id']);
    $person_id = $_SESSION['curUser'];
    $rtn_value = oci_new_cursor($conn);
    $stmt = "BEGIN JOB_LIST.VIEW_JOB_DETAIL($job_id, '$person_id', :OUT_TABLE); END;";
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value, -1, OCI_B_CURSOR);

    $scrst = oci_execute($sc);
    oci_execute($rtn_value);
    oci_fetch($rtn_value);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Job Detail</title>
    <link rel="stylesheet" href="job_detail.css">
</head>
<body>
<div class="job-info">
    <div class="info-row">
        <div class="info-column job-id">#<?php echo $job_id?></div>
        <div class="info-column job-name"><?php echo oci_result($rtn_value, 2);?></div>
    </div>
    <div class="info-row">
        <div class="info-column job-description">
            <pre><?php echo oci_result($rtn_value, 3)?></pre>
        </div>
    </div>
    <div class="info-row">
        <div class="info-column job-quota">
            <div class="info-caption">Quota</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 9);?></div>
        </div>
        <div class="info-column job-app-ddl">
            <div class="info-caption">Application Deadline</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 16);?></div>
        </div>
        <?php if (oci_result($rtn_value, 4) != '') {?>
        <div class="info-column">
            <div class="info-caption">Hourly Salary</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 4);?> HKD</div>
        </div> <?php } ?>
        <?php if (oci_result($rtn_value, 5) != '') {?>
        <div class="info-column">
            <div class="info-caption">Hours per week</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 5);?></div>
        </div> <?php } ?>
        <?php if (oci_result($rtn_value, 6) != '' || oci_result($rtn_value, 7) != '') {?>
        <div class="info-column">
            <div class="info-caption">Total weeks</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 6) == '' ? '0' : oci_result($rtn_value, 6);?> ~ <?php echo oci_result($rtn_value, 7);?></div>
        </div> <?php } ?>
        <div class="info-column">
            <div class="info-caption">Continuous?</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 8) == 'Y' ? 'Yes' : 'No'; ?></div>
        </div>
        <div class="info-column">
            <div class="info-caption">Require interview?</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 10) == 'Y' ? 'Yes' : 'No'; ?></div>
        </div>
        <?php if (oci_result($rtn_value, 11) != '') {?>
        <div class="info-column">
            <div class="info-caption">Minimum Study Year</div>
            <div class="info-content"><?php echo oci_result($rtn_value, 11);?></div>
        </div> <?php } ?>
    <?php if (oci_result($rtn_value, 12) != '') {
        $lang_pref = lang_hash_decode(oci_result($rtn_value, 12));
        ?>
        <div class="info-column">
            <div class="info-caption">Cantonese Requirement</div>
            <div class="info-content"><?php
                if ($lang_pref['ctn'] == 2) echo 'High';
                elseif ($lang_pref['ctn'] == 1) echo 'Medium';
                elseif ($lang_pref['ctn'] == 0) echo 'No'; ?></div>
        </div>
        <div class="info-column">
            <div class="info-caption">English Requirement</div>
            <div class="info-content"><?php
                if ($lang_pref['eng'] == 2) echo 'High';
                elseif ($lang_pref['eng'] == 1) echo 'Medium';
                elseif ($lang_pref['eng'] == 0) echo 'No'; ?></div>
        </div>
        <div class="info-column">
            <div class="info-caption">Putonghua Requirement</div>
            <div class="info-content"><?php
                if ($lang_pref['pth'] == 2) echo 'High';
                elseif ($lang_pref['pth'] == 1) echo 'Medium';
                elseif ($lang_pref['pth'] == 0) echo 'No'; ?></div>
        </div> <?php } ?>
    </div>
</div>
<div class="job-action">
    <?php if (oci_result($rtn_value, 15) == 'Y' && $_SESSION['userType'] == 'STUD') {?>
        <div class="action-row">
        <a href="application.php?Sub_App=2&Job_ID=<?=$job_id?>" class="btn active">Apply Now</a>
    </div> <?php } ?>
    <?php if (oci_result($rtn_value, 13) == 'P' && $_SESSION['userType'] == 'ADMI') {?>
    <div class="action-row">
        <a href="apv_job.php?CuID=<?=$job_id;?>&msg=Y" class="btn active">Approve</a>
    </div>
    <div class="action-row">
        <a href="apv_job.php?CuID=<?=$job_id;?>&msg=N" class="btn danger">Disapprove</a>
    </div>
    <?php } ?>
    <?php if (db_get_permission($conn, $_SESSION['curUser'], $job_id) == 1) {?>
    <div class="action-row">
        <a href="jobapp.php?id=<?php echo $job_id; ?>" class="btn">Applications</a>
    </div>
    <div class="action-row">
        <a href="jobinter.php?id=<?php echo $job_id; ?>" class="btn">Interviews</a>
    </div>
    <div class="action-row">
        <a href="contracts.php?id=<?php echo $job_id; ?>" class="btn">Contracts</a>
    </div>
    <div class="action-row">
        <a href="jobann.php?id=<?php echo $job_id; ?>" class="btn">Announcements</a>
    </div>
    <div class="action-row">
        <a href="jobrecord.php?id=<?php echo $job_id; ?>" class="btn">Records</a>
    </div>
    <?php } ?>
    <?php if ($_SESSION['userType'] != 'STUD') {?>
    <div class="action-row">
        <a href="job_modify.php?id=<?php echo $job_id; ?>" class="btn">Modify...</a>
    </div> <?php } ?>
    <div class="action-row" style="margin-top: 12px">
        Status: <?php
        if (oci_result($rtn_value, 13) == 'Y')
            echo 'Valid';
        elseif (oci_result($rtn_value, 13) == 'P')
            echo 'Waiting for approval';
        elseif (oci_result($rtn_value, 13) == 'D')
            echo 'To be deleted';
        elseif (oci_result($rtn_value, 13) == 'N')
            echo 'Invalid';
        ?><br>
        Last Modified: <?php echo oci_result($rtn_value, 14) ?>
    </div>
</div>
</body>
</html>

    <?php
    oci_close($conn);
}
