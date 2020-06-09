
<?php 
header("CONTENT-TYPE: application/json");
if(
    isset($_POST['name'])  && 
    isset($_POST['father_name']) &&
    isset($_POST['admin_id']) &&
    isset($_POST['book_id']) &&
    isset($_POST['page_no']) &&
    isset($_POST['address']) &&
    isset($_POST['amount'])
){
     $name = $_POST['name'];
     $fname = $_POST['father_name'];
     $admin_id = $_POST['admin_id'];
     $page_no = $_POST['page_no'];
     $address = $_POST['address'];
     $phone = $_POST['phone'];
     $amount = $_POST['amount'];
     $book_id = $_POST['book_id'];
    include "./db.php";
    $sql = "SELECT ADMIN_ID from admin where ADMIN_ID='$admin_id'";
    $result =$conn->query($sql);
    if($result->num_rows){
             $insert_sql = "INSERT INTO transaction(NAME,FATHER_NAME,ADDRESS,PHONE,AMOUNT,PAGE_NUMBER,BOOK_ID,ADMIN_ID)values('$name','$fname','$address','$phone','$amount','$page_no','$book_id','$admin_id')";
             $insert_result = $conn->query($insert_sql);
             $last_insert_id =$conn->insert_id;
             $select_query = "SELECT * FROM transaction WHERE TRANSACTION_ID = '$last_insert_id'";
             $select_result = $conn->query($select_query);
             $row = $select_result->fetch_assoc();
             if($insert_result){
                //    * if transaction save
                $msg = array("msg"=>"Transaction Added","error"=>"","result"=>$row);
                http_response_code(200);
                echo json_encode($msg);
             }else{
                //    * if someting wrong happen
                $msg = array("msg"=>"Oops... Transaction Not Added","error"=>"X");
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
    $msg = array("msg"=>"Please fill all required fields ","error"=>"X");
    http_response_code(400);
    echo json_encode($msg);
}
?>