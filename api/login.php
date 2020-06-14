<?php 
// author: Karan Soni

// $json_data = file_get_contents('php://input');
header('Content-Type: application/json');
// echo $data = json_decode($json_data,true); 
if(isset($_POST["email"]) && isset($_POST["password"])){
     $email  = $_POST['email'];
     $password = $_POST['password'];
     $status = "ACTIVE";
     include("./db.php");
     $sql = $conn->prepare("SELECT * FROM admin WHERE ADMIN_EMAIL = ? AND ADMIN_PASSWORD = ? AND ADMIN_STATUS= ?");
     $sql->bind_param("sss", $email, $password,$status);
     $sql->execute();
     $result = $sql->get_result();
     if($result->num_rows === 0){
        $msg = array("msg"=>"Authentication error, email and password not match","error"=>"X");
        http_response_code(400);
        echo json_encode($msg);
     }else{
        if($row = $result->fetch_assoc()) {
           $row['ADMIN_PASSWORD'] = '';
           $result = array("msg"=>"Success","result"=>$row,"error"=>"");
           http_response_code(400);
           echo json_encode($result);
        }
     }
      
     $sql->close();
}else{
    $msg = array("msg"=>"Email and Password Required.","error"=>"X");
    http_response_code(400);
    echo json_encode($msg);
}

?>