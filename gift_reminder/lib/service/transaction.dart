import 'dart:io';
import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionService {
  static Future insertTransaction(
      {@required name,
      @required fname,
      address = "",
      @required amount,
      @required pageNumber,
      @required bookId,
      phone = "",
      @required adminId}) async {
    try {
      Map _transaction = {
        "name": '$name',
        "father_name": '$fname',
        "admin_id": '$adminId',
        "page_no": '$pageNumber',
        "address": '$address',
        "phone": '$phone',
        "amount": '$amount',
        "book_id": '$bookId',
      };
      var response = await http.post("${Gift.baseUrl}/insertTransaction.php",
          body: _transaction);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error) {
      return {"msg": "$error", "error": "X"};
    }
  }

  static Future getTransaction({@required adminId}) async {
    try {
      Map _data = {"admin_id": "$adminId"};
      var response =
          await http.post("${Gift.baseUrl}/getTransaction.php", body: _data);
      print(response);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error, stacktrace) {
      print("$error $stacktrace");
      return {"msg": "$error", "error": "X"};
    }
  }

  static Future removeTransaction(
      {@required adminId, @required transactionId}) async {
    try {
      Map _data = {"admin_id": "$adminId", "transaction_id": "$transactionId"};
      var response =
          await http.post("${Gift.baseUrl}/deleteTransaction.php", body: _data);
      print(response);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error, stacktrace) {
      print("$error $stacktrace");
      return {"msg": "$error", "error": "X"};
    }
  }

  static Future updateTransaction(
      {@required transactionId,
      @required name,
      @required fname,
      address = "",
      @required amount,
      @required pageNumber,
      @required bookId,
      phone = "",
      @required adminId}) async {
    try {
      Map _transaction = {
        "transaction_id": '$transactionId',
        "name": '$name',
        "fname": '$fname',
        "admin_id": '$adminId',
        "page_no": '$pageNumber',
        "address": '$address',
        "phone": '$phone',
        "amount": '$amount',
        "book_id": '$bookId',
      };
      var response = await http.post("${Gift.baseUrl}/updateTransaction.php",
          body: _transaction);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error) {
      return {"msg": "$error", "error": "X"};
    }
  }
}
