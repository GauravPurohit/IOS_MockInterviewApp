<?php
    
    
    $firstName = $_POST["firstName"];
   // $lastName = $_POST["lastName"];
   // $userId = $_POST["userId"];
    
    
    //include the S3 class
    if (!class_exists('S3'))require_once('S3.php');
    
    //AWS access info
    if (!defined('awsAccessKey')) define('awsAccessKey', 'your credentials here');
    if (!defined('awsSecretKey')) define('awsSecretKey', 'your credentials here');
    
    //instantiate the class
    $s3 = new S3(awsAccessKey, awsSecretKey);
    
    
    
     $target_dir = "$firstName" ;if(!file_exists($target_dir))
   {
        mkdir($target_dir, 0777, true);
   }
    
    
    //create a new bucket
    $s3->putBucket("gpuro", S3::ACL_PUBLIC_READ);
    
    $fileName = $_FILES['file']['name'];
    $fileTempName = $_FILES['file']['tmp_name'];
    $target_dir = $target_dir . "/" . basename($_FILES['file']['name']);
    
    
    
    // if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir))
       if ($s3->putObjectFile($fileTempName, "gpuro", $target_dir, S3::ACL_PUBLIC_READ))
    {
        echo json_encode([
                         "Message" => "The file ". basename($_FILES["file"]["name"]). " has been uploaded.",
                         "Status" => "OK"
                         // "userId" => $_REQUEST["userId"]
                         ]);
        
    } else {
        
        echo json_encode([
                         "Message" => "Sorry, there was an error uploading your file ". basename($_FILES["file"]["name"]). ".",
                         "Status" => "Error"
                         // "userId" => $_REQUEST["userId"]
                         ]);
        
    }
    ?>
