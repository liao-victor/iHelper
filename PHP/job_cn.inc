<?php // File: job_cn.inc

define('ORA_CON_UN', '"USER_NAME"');             // User name
define('ORA_CON_PW', 'PASSWORD');             // Password
define('ORA_CON_DB', 'DB_LINK'); // Connection identifier
define('RECORD_PER_PAGE', 10);

function lang_hash_decode($hash) {
    $hash = intval($hash);
    $pref_ctn = floor($hash / 9);
    $hash -= 9 * floor($hash / 9);
    $pref_eng = floor($hash / 3);
    $hash -= 3 * floor($hash / 3);
    $pref_pth = $hash;
    return array("ctn" => $pref_ctn, "eng" => $pref_eng, "pth" => $pref_pth);
}

function lang_hash_encode($pref_ctn, $pref_eng, $pref_pth) {
    $pref_ctn = intval($pref_ctn);
    $pref_eng = intval($pref_eng);
    $pref_pth = intval($pref_pth);
    return $pref_ctn * 9 + $pref_eng * 3 + $pref_pth;
}

?>