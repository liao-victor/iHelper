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

function db_evaluate($conn, $Sub_App,$App_Info,$App_Res, $App_ID,$Job_ID,$Cov_Let,$Std_ID) {
    $rtn_value1 = 0;
    $rtn_value2 = 0;

   if($Sub_App == 2){
       if($Job_ID != '') {
           $stmt = "BEGIN JOB_APPLY.SUBMIT_APP($Job_ID,'$Std_ID','$Cov_Let'); END;";
           $sc = oci_parse($conn, $stmt);
           oci_execute($sc);
       }
    }

   if($App_Info == 2){
       if($App_ID != '') {
           $rtn_value1 = oci_new_cursor($conn);
           $stmt = "BEGIN JOB_APPLY.APP_Info($App_ID, :OUT_TABLE); END;";
           $sc = oci_parse($conn, $stmt);
           oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value1, -1, OCI_B_CURSOR);
           oci_execute($sc);
           oci_execute($rtn_value1);
       }
}

    if($App_Res == 2){
       if($App_ID != '') {
           $rtn_value2 = oci_new_cursor($conn);
           $stmt = "BEGIN JOB_APPLY.App_RESULT($App_ID, :OUT_TABLE); END;";
           $sc = oci_parse($conn, $stmt);
           oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value2, -1, OCI_B_CURSOR);
           oci_execute($sc);
           oci_execute($rtn_value2);
       }
    }


    return[$rtn_value1,$rtn_value2];
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