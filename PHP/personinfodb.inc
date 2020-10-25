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

function db_evaluate($conn,$Per_Inf,$Mod_Con,$Mod_Cv,$Mod_Mlp,$PhoneNo,$Email,$Address1,$Address2,$City,$State,$CV,$LanPr,$Std_ID) {
    $rtn_value = 0;

    if($Per_Inf == 2){
        $rtn_value = oci_new_cursor($conn);
        $stmt = "BEGIN JOB_MANAGE.VPERSONINFO('$Std_ID', :OUT_TABLE); END;";
        $sc = oci_parse($conn, $stmt);
        oci_bind_by_name($sc, ':OUT_TABLE', $rtn_value, -1, OCI_B_CURSOR);
        oci_execute($sc);
        oci_execute($rtn_value);
    }

    if($Mod_Con == 2){
        if ($PhoneNo != '' and $PhoneNo != '' and $Email != '' and $Address1 != '' and $Address2 != '' and $City != '' and $State != '') {
            $stmt = "BEGIN UPDATE_PEOPLE.ICONINFO('$Std_ID','$PhoneNo','$Email','$Address1','$Address2','$City','$State'); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
        }
    }

    if($Mod_Cv == 2){
        if ($CV != '') {
            $stmt = "BEGIN UPDATE_PEOPLE.ICV('$Std_ID','$CV'); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
        }
    }

    if($Mod_Mlp == 2){
            $stmt = "BEGIN UPDATE_PEOPLE.ILangPreInfo('$Std_ID',$LanPr); END;";
            $sc = oci_parse($conn, $stmt);
            oci_execute($sc);
    }

    return $rtn_value;
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