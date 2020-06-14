<?php 
// update  transaction
header("CONTENT-TYPE: application/json");

if(
    isset($_POST["admin_id"]) &&
    isset($_POST["search_by"]) &&
    isset($_POST["search_value"])    
){       include "./db.php";
         $admin_id = $_POST["admin_id"];
         $search_by = $_POST["search_by"];
         $search_value = $_POST["search_value"];
         
         $sql = "SELECT * from admin where  ADMIN_ID='$admin_id'";
      $result =$conn->query($sql);
      if($result->num_rows){
            if($search_by === "AMOUNT" || $search_by ==="PAGE_NUMBER"){
                $search_sql = "SELECT * FROM transaction WHERE $search_by ='$search_value' AND ADMIN_ID='$admin_id' AND STATUS='Active' ORDER BY NAME ";
            }else{
                $search_sql = "SELECT * FROM transaction WHERE $search_by LIKE '%$search_value%' AND ADMIN_ID='$admin_id' AND STATUS='Active' ORDER BY NAME";
                
            }
            $search_result = $conn->query($search_sql);
            $rows = array();
               
               while($row =$search_result->fetch_assoc() ){
                  $rows[] = $row;
               }   

                     // * if authenticated user then send data
                     $msg = array("msg"=>"Success","results"=>$rows ,"error"=>"","length"=>count($rows));
                     http_response_code(200);
                     echo json_encode($msg);
               
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