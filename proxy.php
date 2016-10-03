<?php
/*
 * HUAWEI FIREWARE SCANNER
 * @VERSION: 2.0.2016.1003
 * @AUTHOR: Norckon
 */

error_reporting(0);
ini_set('default_socket_timeout', 5); // timeout 5 seconds
$model = explode('|', $_GET['m']);
$prefix = 'http://update.hicloud.com:8180/TDS/data/files/p3/s15/'.$model[0].'/'.$model[1].'/v'.$_GET['v'].'/f'.$_GET['c'].'/full/';

// Convernt or parse to XML object
$logRaw = file_get_contents($prefix.'changelog.xml');   // Changelog
$logXml = simplexml_load_string($logRaw) or die('{"error":"Invalid data"}');
$fileRaw = file_get_contents($prefix.'filelist.xml');   // FileList
$fileXml = simplexml_load_string($fileRaw) or die('{"error":"Invalid data"}');

// Do value convernt from XML to custom value
$emuiVer = (string)$logXml -> component -> attributes() -> version;
if($emuiVer == "") $emuiVer = (string)$logXml -> componet -> attributes() -> version; // for some version
$emuiOta = (string)$logXml -> {'point-version'} == '' ? false : true;
foreach($logXml -> language as $langItem) { // Getting desc by language
    if($langItem -> attributes() -> code == $_GET['l']) {
        $emuiDesc = (string)$langItem -> features[1] -> feature;
        $emuiDesc = str_replace("\n\t","<br/>",$emuiDesc);
    }
}
foreach($fileXml -> files -> file as $fileItem) { // Getting FileInfo
    if($fileItem -> dpath == 'update.zip') {
        $emuiSize = number_format(($fileItem -> size / 1024 / 1024), 2).' MiB';
        $emuiMD5 = (string)$fileItem -> md5;
    }
}
// Create a new array preparing for encode JSON string
$data = array(
    'id' => $_GET['v'],
    'version' => $emuiVer,
    'isOta' => $emuiOta,
    'changlog' => $emuiDesc,
    'dlLink' => $prefix.'update.zip',
    'dlSize' => $emuiSize,
    'dlMd5' => $emuiMD5,
);

echo json_encode($data);
?>