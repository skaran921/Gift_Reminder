<?php 
header("CONTENT-TYPE: application/json");
   if(isset($_POST["admin_id"])){
       include "./db.php";
      $admin_id = $_POST["admin_id"];
      $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $transaction_sql = "SELECT * FROM transaction WHERE ADMIN_ID='$admin_id' AND STATUS='ACTIVE' ORDER BY TRANSACTION_ID DESC";
               $transaction_result = $conn->query($transaction_sql);
               $rows = array();
               while($row = $transaction_result->fetch_assoc()){
                   $rows[]=$row;
               }
               
                // * if authenticated user then send data
            $msg = array("msg"=>"Success","results"=>$rows, "error"=>"");
            http_response_code(200);
            echo json_encode($msg);
               
      }else{
           // * if authentication failed then denied
            $msg = array("msg"=>"Authentication failed","error"=>"X");
            http_response_code(401);
            echo json_encode($msg);
      }
   }else{
      // * if authentication failed then denied
      $msg = array("msg"=>"Authentication failed","error"=>"X");
      http_response_code(401);
      echo json_encode($msg);
   }

?>