<?php 
//header("CONTENT-TYPE: application/json");
   if(isset($_POST["admin_id"])){
       include "./db.php";
      $admin_id = $_POST["admin_id"];
      $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
               $book_sql = "SELECT * FROM books WHERE ADMIN_ID='$admin_id' AND BOOK_STATUS='ACTIVE' ORDER BY BOOK_ID";
               $book_result = $conn->query($book_sql);
               $book_rows = array();
               while($book_row = $book_result->fetch_assoc()){
                   $book_rows[]=$book_row;
               }
               
                // * if authenticated user then send data
            $msg = array("msg"=>"Success","results"=>$book_rows, "error"=>"");
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