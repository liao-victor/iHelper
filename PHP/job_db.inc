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

function db_get_table($conn, $start_pos, $item_count, $person_id, $FIL_REQIV, $FIL_ISCON, $FIL_LANGPREF, $SRT_HRSLR) {
    $rtn_value = oci_new_cursor($conn);
    $stmt = "BEGIN JOB_LIST.VIEW_JOBS(:START_POS, :ITEM_COUNT, $FIL_REQIV, $FIL_ISCON, $FIL_LANGPREF, $SRT_HRSLR, '$person_id', :OUT_TABLE); END;";
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':START_POS', $start_pos);
    oci_bind_by_name($sc, ':ITEM_COUNT', $item_count);
    oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value, -1, OCI_B_CURSOR);

    oci_execute($sc);
    oci_execute($rtn_value);

    return($rtn_value);
}

function db_get_job_count($conn, $person_id, $FIL_REQIV, $FIL_ISCON, $FIL_LANGPREF) {
    $rtn_value = -1;
    $stmt = "BEGIN JOB_LIST.COUNT_JOBS($FIL_REQIV, $FIL_ISCON, $FIL_LANGPREF, '$person_id', :OUT_COUNT); END;";
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':OUT_COUNT', $rtn_value);

    oci_execute($sc);

    return($rtn_value);
}

function db_get_permission($conn, $person_id, $job_id = 0) {
    $permission = -1;
    $stmt = "BEGIN UTIL.Permission_Check($job_id, '$person_id', :OUT_VALUE); END;";
    $sc = oci_parse($conn, $stmt);
    oci_bind_by_name($sc, ':OUT_VALUE', $permission);

    $scrst = oci_execute($sc);

    if ($scrst == true) {
        return $permission;
    } else {
        return -1;
    }

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