<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["transaction_id"]) &&
    isset($_POST["admin_id"]) &&
    isset($_POST["name"]) &&
    isset($_POST["fname"]) &&
    isset($_POST["address"]) &&
    isset($_POST["phone"]) &&
    isset($_POST["amount"]) &&
    isset($_POST["page_no"]) &&
    isset($_POST["book_id"]) 
    
    
){        include "./db.php";
         $transation_id = $_POST["transaction_id"];
         $admin_id = $_POST["admin_id"];
         $name = $_POST["name"];
         $fname = $_POST["fname"];
         $address = $_POST["address"];
         $phone = $_POST["phone"];
         $amount = $_POST["amount"];
         $page_no = $_POST["page_no"];
         $book_id = $_POST["book_id"];
         $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $update_sql = "UPDATE transaction SET NAME='$name', FATHER_NAME='$fname',ADDRESS='$address',PHONE='$phone',AMOUNT='$amount',PAGE_NUMBER='$page_no',BOOK_ID='$book_id'  WHERE TRANSACTION_ID='$transation_id'";
               $update_result = $conn->query($update_sql);
               if($update_result){
                        // * if authenticated user then send data
                    $msg = array("msg"=>"One Transaction Updated","error"=>"");
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
     $msg = array("msg"=>"Not allowed, all fields are required","error"=>"X");
     http_response_code(401);
     echo json_encode($msg);
}
?>