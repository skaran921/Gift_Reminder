import 'dart:convert';
import 'dart:io';
import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future authenticate(
      {@required String email, @required String password}) async {
    Map _data = {"email": email, "password": password};
    try {
      var response = await http.post("${Gift.baseUrl}/login.php", body: _data);
      var jsonResponse = json.decode(response.body);
      print(response);
      print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error) {
      print(error);
      return {"msg": "${error.message}", "error": "X"};
    }
  }
}
