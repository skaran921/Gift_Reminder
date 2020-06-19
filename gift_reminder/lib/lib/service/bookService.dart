import 'dart:convert';
import 'dart:io';

import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class BookService {
  static Future getBooks({@required adminId}) async {
    try {
      Map _data = {"admin_id": "$adminId"};
      var response =
          await http.post("${Gift.baseUrl}/getBooks.php", body: _data);
      // print(response.body);
      var jsonResponse = json.decode(response.body);
      // print(jsonResponse);
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

  static Future createNewBook({@required adminId}) async {
    try {
      Map _data = {"admin_id": "$adminId"};
      var response =
          await http.post("${Gift.baseUrl}/insertBook.php", body: _data);
      // print(response.body);
      var jsonResponse = json.decode(response.body);
      // print(jsonResponse);
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
}
