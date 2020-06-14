<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["new_password"]) &&
    isset($_POST["admin_id"]) &&
    isset($_POST["email"])
){       include "./db.php";
         $newPassword = $_POST["new_password"];
         $email = $_POST["email"];
         $admin_id = $_POST["admin_id"];
         
         $sql = "SELECT ADMIN_ID from admin where  ADMIN_EMAIL='$email'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $update_sql = "UPDATE admin SET ADMIN_PASSWORD='$newPassword'  WHERE ADMIN_ID='$admin_id'";
               $update_result = $conn->query($update_sql);
               if($update_result){
                        // * if authenticated user then send data
                    $msg = array("msg"=>"Password Changed","error"=>"");
                    http_response_code(200);
                    echo json_encode($msg);
               }else{
                    //*   if something happen wrong                
                    $msg = array("msg"=>"Authentication failed, password not updated","error"=>"X");
                    http_response_code(401);
                    echo json_encode($msg);
               }      
               
      }else{
           // * if authentication failed then denied
            $msg = array("msg"=>"Sorry your email are not registred","error"=>"X");
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