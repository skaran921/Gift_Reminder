import 'dart:convert';
import 'dart:io';
import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class CreateAccountService {
  static Future createNewAccount(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String password}) async {
    Map _data = {
      "first_name": "$firstName",
      "last_name": "$lastName",
      "email": email,
      "password": password
    };
    try {
      var response =
          await http.post("${Gift.baseUrl}/createAccount.php", body: _data);
      var jsonResponse = json.decode(response.body);
      // print(response);
      // print(jsonResponse);
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

  static Future forgotPassword({
    @required String email,
  }) async {
    Map _data = {
      "email": email,
    };
    try {
      var response =
          await http.post("${Gift.baseUrl}/forgotPassword.php", body: _data);
      var jsonResponse = json.decode(response.body);
      // print(response);
      // print(jsonResponse);
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

  static Future forgotPasswordAferOtpConfirmation({
    @required String email,
    @required String newPassword,
    @required String adminId,
  }) async {
    Map _data = {
      "email": email,
      "new_password": newPassword,
      "admin_id": adminId
    };
    try {
      var response = await http
          .post("${Gift.baseUrl}/forgotPasswordAfterOTP.php", body: _data);
      var jsonResponse = json.decode(response.body);
      // print(response);
      // print(jsonResponse);
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
