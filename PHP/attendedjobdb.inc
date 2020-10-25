
<?php  // File: anyco_db.inc

function db_connect()
{
    // use constants defined in anyco_cn.inc
    $conn = oci_connect(ORA_CON_UN, ORA_CON_PW, ORA_CON_DB);
    if (!$conn) {
        db_error(null, __FILE__, __LINE__);
    }
    return($conn);
}

function db_do_query($conn, $statement)
{
    $stid = oci_parse($conn, $statement);
    if (!$stid) {
        db_error($conn, __FILE__, __LINE__);
    }

    $r = oci_execute($stid, OCI_DEFAULT);
    if (!$r) {
        db_error($stid, __FILE__, __LINE__);
    }
    $r = oci_fetch_all($stid, $results, null, null,
        OCI_FETCHSTATEMENT_BY_ROW);
    return($results);
}

function db_evaluate($conn,$Job_Ses,$Job_Att,$Job_Ann,$Job_Con,$Sub_Lap,$Job_Sal,$Per_Rev,$Std_ID,$Sta_Dat,$End_Dat,$Job_ID,$Lev_Res){
    $rtn_value1 = 0;
    $rtn_value2 = 0;
    $rtn_value3 = 0;
    $rtn_value4 = 0;
    $rtn_value5 = 0;
    $rtn_value6 = 0;

    if($Job_Ses == 2){
        $rtn_value1 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VJOBSESSION('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value1, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value1);
    }

    if($Job_Att == 2){
        $rtn_value2 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VATTENREC('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value2, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value2);
    }

    if($Job_Ann == 2){
        $rtn_value3 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VANNO('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value3, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value3);
    }

    if($Job_Con == 2){
        $rtn_value4 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VCONTRACT('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value4, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value4);
    }


    if($Job_Sal == 2){
        $rtn_value5 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VMONSALARY('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value5, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value5);
    }

    if($Sub_Lap == 2) {
        if ($Lev_Res != '' and $Sta_Dat != '' and $End_Dat != ''){
            $stmt = "BEGIN JOB_MANAGE.TAKE_LEAVE('$Std_ID',$Job_ID,'$Lev_Res','$Sta_Dat','$End_Dat'); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
        }
    }

    if($Per_Rev == 2){
        $rtn_value6 = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VPERREVIEW('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value6, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value6);
    }

    return[$rtn_value1,$rtn_value2,$rtn_value3,$rtn_value4,$rtn_value5,$rtn_value6];
}


// $r is the resource containing the error.
// Pass no argument or false for connection errors

function db_error($r = false, $file, $line)
{
    $err =  $r ? oci_error($r) : oci_error();

    if (isset($err['message'])) {
        $m = htmlentities($err['message']);
    }
    else {
        $m = 'Unknown DB error';
    }

    echo '<p><b>Error</b>: at line '.$line.' of '.$file.'</p>';
    echo '<pre>'.$m.'</pre>';

    exit;
}

?>