import 'dart:io';
import 'package:gift_reminder/config/gift.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future updateProfile(
      {@required adminId,
      @required fname,
      @required lname,
      @required email,
      @required password}) async {
    try {
      Map _data = {
        "admin_id": "$adminId",
        "fname": "$fname",
        "lname": "$lname",
        "email": "$email",
        "password": "$password"
      };
      var response =
          await http.post("${Gift.baseUrl}/editProfile.php", body: _data);
      // print(response);
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

  static Future updatePassword(
      {@required adminId,
      @required email,
      @required password,
      @required newPassword}) async {
    try {
      Map _data = {
        "admin_id": "$adminId",
        "new_password": "$newPassword",
        "email": "$email",
        "password": "$password"
      };
      var response =
          await http.post("${Gift.baseUrl}/changePassword.php", body: _data);
      var jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      return jsonResponse;
    } on HttpException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } on SocketException catch (error) {
      return {"msg": "${error.message}", "error": "X"};
    } catch (error) {
      // print("$error $stacktrace");
      return {"msg": "$error", "error": "X"};
    }
  }
}
