<?php 
header("CONTENT-TYPE: application/json");
   if(isset($_POST["admin_id"])){
       include "./db.php";
      $admin_id = $_POST["admin_id"];
      $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $transaction_sql = "SELECT transaction.TRANSACTION_ID,transaction.NAME,transaction.FATHER_NAME,transaction.ADDRESS,transaction.PHONE,transaction.AMOUNT,transaction.PAGE_NUMBER,transaction.BOOK_ID,transaction.ADMIN_ID,transaction.CREATE_DATE,transaction.UPDATE_DATE,transaction.STATUS, books.BOOK_NUMBER FROM transaction 
                  left join books on transaction.BOOK_ID= books.BOOK_ID 
                  WHERE transaction.ADMIN_ID='$admin_id' AND STATUS='ACTIVE' GROUP by TRANSACTION_ID ORDER BY TRANSACTION_ID DESC";
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