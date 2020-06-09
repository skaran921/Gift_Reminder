<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["admin_id"]) &&
    isset($_POST["fname"]) &&
    isset($_POST["lname"]) &&
    isset($_POST["email"]) &&     
    isset($_POST["password"])      
    
){        include "./db.php";
         $admin_id = $_POST["admin_id"];
         $fname = $_POST["fname"];
         $lname = $_POST["lname"];
         $email = $_POST["email"];
         $password = $_POST["password"];
         
         $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id' AND ADMIN_EMAIL='$email' AND ADMIN_PASSWORD='$password'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $update_sql = "UPDATE admin SET ADMIN_FIRST_NAME='$fname', ADMIN_LAST_NAME='$lname'  WHERE ADMIN_ID='$admin_id'";
               $update_result = $conn->query($update_sql);
               if($update_result){
                        // * if authenticated user then send data
                    $msg = array("msg"=>"Profile Updated","error"=>"");
                    http_response_code(200);
                    echo json_encode($msg);
               }else{
                    //   if something happen wrong                
                    $msg = array("msg"=>"Profile Not Updated","error"=>"X");
                    http_response_code(400);
                    echo json_encode($msg);
               }      
               
      }else{
           // * if authentication failed then denied
            $msg = array("msg"=>"Authentication failed","error"=>"X");
            http_response_code(401);
            echo json_encode($msg);
      }
}else{
     // * if transaction id not set
     $msg = array("msg"=>"Not allowed, all fields are required","error"=>"X");
     http_response_code(401);
     echo json_encode($msg);
}
?>