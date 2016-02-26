<?php
    
    require("Conn.php");
    require("MySqlDao.php");
    $username = htmlentities($_POST["userName"]);
    $password = htmlentities($_POST["passWord"]);
    $returnValue = array();
    
    if(empty($username) || empty($password))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "Missing required field";
        echo json_encode($returnValue);
        return;
    }
    
    
    $dao = new MySqlDao();
    $dao->openConnection();
    $passDetails = $dao->getPasswordSalt($username,$password);
    $passDetails = array_values($passDetails)[0];
    $userDetails = $dao->getUserDetailsWithPassword($username,$password,$passDetails);

   // echo "$passDetails";
    //print_r(array_values($userDetails));
    //echo $userDetails;
    
    
    if(!empty(array_values($userDetails)[1]) && !empty(array_values($userDetails)[2]))
    {
        $returnValue["status"] = "Success";
        $returnValue["message"] = "User logged in !";
        echo json_encode($returnValue);
    }
    
    else {
        $returnValue["status"] = "error";
        $returnValue["message"] = "User is not found, please try again !";
        echo json_encode($returnValue);
    }
    
    $dao->closeConnection();
    
    ?>
