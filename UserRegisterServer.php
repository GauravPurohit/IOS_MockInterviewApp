<?php
    
    
    require("ConnServer.php");
    require("MySqlDaoServer.php");
    
    
    $username = htmlentities($_POST["userName"]);
    $password = htmlentities($_POST["passWord"]);
    
    
    $returnValue = array();
    
    if(empty($username) || empty($password))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "Missing required field !";
        echo json_encode($returnValue);
        return;
    }
    
    $dao = new MySqlDaoServer();
    $dao->openConnection();
    $userDetails = $dao->getUserDetails($username);
    
    if(!empty($userDetails))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "User already exists, please try another username !";
        echo json_encode($returnValue);
        return;
    }
    
    //$salt = openssl_random_pseudo_bytes(16);
    $salt = random_bytes(16);
    $secure_password = sha1($password . $salt);
    
    $result = $dao->registerUser($username,$secure_password,$salt);
    
    
    
    if($result)
    {
        $returnValue["status"] = "Success";
        $returnValue["message"] = "User is registered !";
        echo json_encode($returnValue);
        return;
    }
    
    $dao->closeConnection();
    
    ?>
