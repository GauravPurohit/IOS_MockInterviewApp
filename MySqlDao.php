

<?php
    
    class MySqlDao {
        var $dbhost = null;
        var $dbuser = null;
        var $dbpass = null;
        var $conn = null;
        var $dbname = null;
        var $result = null;
        
        
        function __construct() {
            $this->dbhost = Conn::$dbhost;
            $this->dbuser = Conn::$dbuser;
            $this->dbpass = Conn::$dbpass;
            $this->dbname = Conn::$dbname;
        }
        
        public function openConnection() {
            $this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);
            if (mysqli_connect_errno())
                echo new Exception("Could not establish connection with database");
        }
        
        public function getConnection() {
            return $this->conn;
        }
        
        public function closeConnection() {
            if ($this->conn != null)
                $this->conn->close();
        }
        
        public function getUserDetails($username)
        {
            $returnValue = array();
            $sql = "select * from users where username='" . $username . "'";
            
            $result = $this->conn->query($sql);
            if ($result != null && (mysqli_num_rows($result) >= 1)) {
                $row = $result->fetch_array(MYSQLI_ASSOC);
                if (!empty($row)) {
                    $returnValue = $row;
                }
            }
            return $returnValue;
        }
        
       
        public function getPasswordSalt($username, $userPassword)
        {
            $returnValue = array();
            $salt = "select salt from MockInterview.users where username='" . $username . "'";
            $salt_result=$this->conn->query($salt);
            if ($salt_result != null && (mysqli_num_rows($salt_result) >= 1)) {
                $row = $salt_result->fetch_array(MYSQLI_ASSOC);
                if (!empty($row)) {
                    $returnValue = $row;
                }
            }
            
            return $returnValue;
        }
        
        
        public function getUserDetailsWithPassword($username, $userPassword, $passDetails)
        {
            $returnValue = array();
            $userPasswordNew = sha1($userPassword . $passDetails);
            $sql = "select * from MockInterview.users where username='" . $username . "' and password='" . $userPasswordNew . "'";
            $result = $this->conn->query($sql);
            if ($result != null && (mysqli_num_rows($result) >= 1)) {
                $row = $result->fetch_array(MYSQLI_ASSOC);
                if (!empty($row)) {
                    $returnValue = $row;
                }
            }
            return $returnValue;
        }
        
        public function registerUser($username, $password, $salt)
        {
            
            $sql = "insert into MockInterview.users set username=?, password=?, salt=?";
            $statement = $this->conn->prepare($sql);
            
            if (!$statement)
                throw new Exception($statement->error);
            
            $statement->bind_param("sss", $username, $password, $salt);
            $returnValue = $statement->execute();
            
            return $returnValue;
        }
        
    }
    ?>