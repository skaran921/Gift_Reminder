<?php 
// delete  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["transaction_id"]) &&
    isset($_POST["admin_id"])
){        include "./db.php";
         $transation_id = $_POST["transaction_id"];
         $admin_id = $_POST["admin_id"];        
         $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $update_sql = "UPDATE transaction SET status='InActive' WHERE TRANSACTION_ID='$transation_id'";
               $update_result = $conn->query($update_sql);
               if($update_result){
                        // * if authenticated user then send data
                    $msg = array("msg"=>"One Transaction Deleted","error"=>"");
                    http_response_code(200);
                    echo json_encode($msg);
               }else{
                    //   if something happen wrong                
                    $msg = array("msg"=>"Transaction Not Deleted","error"=>"X");
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
     $msg = array("msg"=>"Not Allowed, Authentication Failed","error"=>"X");
     http_response_code(401);
     echo json_encode($msg);
}
?>