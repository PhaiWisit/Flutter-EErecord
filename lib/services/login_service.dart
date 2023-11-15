import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ee_record_mvvm/services/api_status.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Object> login(username, password) async {
    var client = http.Client();
    try {
      var postUri = Uri.parse(NEST_LOCAL_SERVER + NEST_LOGIN);
      var response = await http
          .post(postUri,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "username": username,
                "password": password,
              }))
          .timeout(Duration(seconds: 5), onTimeout: () {
        return http.Response('error', 408);
      });

      // var response = await client.post(postUri,
      //     body: jsonEncode({
      //       "username": username,
      //       "password": password,
      //     }));
      //     .timeout(Duration(seconds: 5), onTimeout: () {
      //   return http.Response('Error', 101);
      // });

      log('${response.statusCode.toString()} : ${response.bodyBytes.toString()}');
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // var uri = Uri.parse(decodedResponse['uri'] as String);
      // print(await client.get(uri));

      if (SUCCESS == response.statusCode || CREATE == response.statusCode) {
        return Success(code: SUCCESS, response: response.body);
      } else if (response.statusCode == 400) {
        return Failure(code: 400, errorResponse: 'Invalid User');
      } else if (response.statusCode == 401) {
        return Failure(code: 401, errorResponse: 'Invalid Password');
      } else if (response.statusCode == 408) {
        return Failure(code: 408, errorResponse: 'Can not connect to server');
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on TimeoutException catch (_) {
      return Failure(
          code: NO_INTERNET, errorResponse: 'Can not connect to server');
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      print(e);
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    } finally {
      client.close();
    }
  }
}
