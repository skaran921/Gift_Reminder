<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["first_name"]) &&
    isset($_POST["last_name"]) &&
    isset($_POST["email"])    &&
    isset($_POST["password"])    
){       include "./db.php";
         $first_name = $_POST["first_name"];
         $last_name = $_POST["last_name"];
         $email = $_POST["email"];
         $password = $_POST["password"];
         
         $sql = "SELECT * from admin where  ADMIN_EMAIL='$email'";
      $result =$conn->query($sql);
      if($result->num_rows){           

                     // * if authenticated user then send data
                     $msg = array("msg"=>"Sorry, email already exist","error"=>"X");
                     http_response_code(400);
                     echo json_encode($msg);               
      }else{
           // * if authentication failed then denied

            $create_sql = "INSERT INTO admin(ADMIN_FIRST_NAME,ADMIN_LAST_NAME,ADMIN_EMAIL,ADMIN_PASSWORD,ADMIN_STATUS)VALUES('$first_name','$last_name','$email','$password','ACTIVE')";
            $create_result = $conn->query($create_sql);

            if($create_result){
                $msg = array("msg"=>"New Account Created","error"=>"","_id"=>$conn->insert_id);
                http_response_code(200);
                echo json_encode($msg);
            }else{
                // error account not created
                $msg = array("msg"=>"Error, Account Not Created","error"=>"X");
                http_response_code(400);
                echo json_encode($msg);
            }
      }
}else{
     // * if transaction id not set
     $msg = array("msg"=>"All fields are required","error"=>"X");
     http_response_code(400);
     echo json_encode($msg);
}
?>