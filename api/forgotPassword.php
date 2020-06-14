<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(   
    isset($_POST["email"])   
){       include "./db.php";
         $email = $_POST["email"];
                  
         $sql = "SELECT ADMIN_ID from admin where  ADMIN_EMAIL='$email'";
      $result =$conn->query($sql);
      if($result->num_rows){
          //   send otp  
              $row =$result->fetch_assoc();
              $otp = rand(100000,999999);
              $htmlBody="<div style='background-color:#fafafa'><h1 style='color:#390ac8'>Gift Reminder</h1><br/><center><p>Forgot Passowrd<br/> <span><b>Your OTP is:</b></span> <span style='color:#ABA7C0'> $otp  </span> </p></center> </div>";
             // mail($email,"Forgot Password",$htmlBody,"From: Gift Reminder");
                    $msg = array("msg"=>"OTP sent to your email","OTP"=>$otp, "error"=>"","id"=>$row['ADMIN_ID']);
                    http_response_code(200);
                    echo json_encode($msg);
                 
               
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