<?php
header('Content-Type: application/json');
if(isset($_POST["admin_id"]) ){
    $admin_id = $_POST["admin_id"];
    $book_number = 0;
    include("./db.php");    
    $sql = $conn->prepare("SELECT BOOK_NUMBER FROM books where ADMIN_ID= ? ORDER BY BOOK_ID desc LIMIT 0,1");
    $sql->bind_param("s",$admin_id);
    $sql->execute();
     $result = $sql->get_result();
     if($result->num_rows === 0){
       $book_number +=1;
     }else{
          if($row = $result->fetch_assoc()){
               $book_number = $row['BOOK_NUMBER']+1;
          }else{
              $book_number+=1;
          }
     }
     $sql->close();

     $insert_sql  = "INSERT INTO books(BOOK_NUMBER,ADMIN_ID)VALUES('$book_number','$admin_id')";
     $insert_result = $conn->query($insert_sql);
     if($insert_result){
        $sql = $conn->prepare("SELECT * FROM books where ADMIN_ID= ?");
        $sql->bind_param("s",$admin_id);
        $sql->execute();
        $result = $sql->get_result();
        while($row = $result->fetch_assoc()){
            $rows[] = $row;
        }
        $result =array("msg"=>"New Book Inserted Successfully","result"=>$rows,"error"=>"");
        http_response_code(200);
        echo json_encode($result);
     }
}else{
   $result =array("msg"=>"Book Number Required","error"=>"X");
   http_response_code(400);
   echo json_encode($result);
}

?>