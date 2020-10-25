<?php
session_start();

if (!isset($_SESSION['curUser'])) {
    // If not signed in
    echo "Please <a href='portal.php'>sign in</a> first! ";
    header('Location: portal.php');
} else {
    include("personinfodb.inc");
    include("job_cn.inc");
    include("personinfoui.inc");

    $conn = db_connect();
    $Per_Inf = !isset($_GET['Per_Inf']) ? 0 : intval($_GET['Per_Inf' ]);
    $Mod_Con = !isset($_GET['Mod_Con']) ? 0 : intval($_GET['Mod_Con' ]);
    $Mod_Cv  = !isset($_GET['Mod_Cv' ]) ? 0 : intval($_GET['Mod_Cv'  ]);
    $Mod_Mlp = !isset($_GET['Mod_Mlp']) ? 0 : intval($_GET['Mod_Mlp' ]);
    $PhoneNo = !isset($_GET['PhoNo']  ) ? '' : $_GET['PhoNo'];
    $Email   = !isset($_GET['Email'  ]) ? '' : $_GET['Email'   ];
    $Address1= !isset($_GET['Address1'])? '' : $_GET['Address1'];
    $Address2= !isset($_GET['Address2'])? '' : $_GET['Address2'];
    $City    = !isset($_GET['City'])    ? '' : $_GET['City'];
    $State   = !isset($_GET['State']  ) ? '' : $_GET['State'];
    $CV      = !isset($_GET['CV']     ) ? '' : $_GET['CV'];
    $LanPr   = !isset($_GET['LanPr'  ]) ? 0 : intval($_GET['LanPr'   ]);
    $Std_ID  = $_SESSION['curUser'];

    $table_ref = db_evaluate($conn,$Per_Inf,$Mod_Con,$Mod_Cv,$Mod_Mlp,$PhoneNo,$Email,$Address1,$Address2,$City,$State,$CV,$LanPr,$Std_ID);

    ui_print_header('Job Applications For You', $_SESSION['curUser']);
    ui_print_optionbox();
    if($table_ref != 0)
        ui_print_job_list($table_ref);
    ui_print_footer(date('Y-m-d H:i:s'));
}
oci_close($conn);
