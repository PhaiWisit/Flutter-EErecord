import 'dart:developer';
import 'dart:io';

import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:ee_record_mvvm/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_status.dart';

class VisitorServices {
  static Future<Object> getVisitor() async {
    String token = PreferenceUtils.getString('accessToken');
    try {
      var url = Uri.parse(NEST_LOCAL_HOST + VISITOR_ALL);
      var headers = {'authorization': 'Bearer $token'};
      var response = await http.get(url, headers: headers);
      if (SUCCESS == response.statusCode) {
        return Success(
            code: SUCCESS, response: visitorListModelFromJson(response.body));
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }

  static Future<Object> getVisitorActive() async {
    String token = PreferenceUtils.getString('accessToken');
    try {
      var url = Uri.parse(NEST_LOCAL_HOST + VISITOR_ACTIVE);
      var headers = {'authorization': 'Bearer $token'};
      var response = await http.get(url, headers: headers);
      if (SUCCESS == response.statusCode) {
        return Success(
            code: SUCCESS, response: visitorListModelFromJson(response.body));
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }

  static Future<Object> getVisitorInactive() async {
    String token = PreferenceUtils.getString('accessToken');
    try {
      var url = Uri.parse(NEST_LOCAL_HOST + VISITOR_INACTIVE);
      var headers = {'authorization': 'Bearer $token'};
      var response = await http.get(url, headers: headers);
      if (SUCCESS == response.statusCode) {
        return Success(
            code: SUCCESS, response: visitorListModelFromJson(response.body));
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }

  static Future<http.StreamedResponse> updateStatus(
      String id, String dateExit, String timeExit) async {
    String token = PreferenceUtils.getString('accessToken');
    DateTime visitorExitTime = DateTime.now();

    var headers = {'authorization': 'Bearer $token'};
    var request = http.Request('PATCH',
        Uri.parse(NEST_LOCAL_HOST + VISITOR_UPDATE_STATUS + id + "/status"));
    request.bodyFields = {
      "visitorStatus": "INACTIVE",
      'visitorsExit': visitorExitTime.toIso8601String()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  static Future<Object> uploadAll(VisitorModel body) async {
    String token = PreferenceUtils.getString('accessToken');
    Map<String, String> headers = {'authorization': 'Bearer $token'};
    String _houseNumber = body.visitorHouseNumber.toString();
    String _contactMatter = body.visitorContactMatter;
    String _vehicleType = body.visitorVehicleType;

    String _imagePathIdCard = body.visitorImagePathIdCard;
    String _imagePathPalte = body.visitorImagePathPalte;
    try {
      var postUri = Uri.parse(NEST_LOCAL_HOST + VISITOR_UPLOAD);
      http.MultipartRequest request = http.MultipartRequest("POST", postUri);

      http.MultipartFile multipartFile1 =
          await http.MultipartFile.fromPath('imageIdCard', _imagePathIdCard);
      http.MultipartFile multipartFile2 =
          await http.MultipartFile.fromPath('imagePlate', _imagePathPalte);
      request.headers.addAll(headers);
      request.files.add(multipartFile1);
      request.files.add(multipartFile2);
      // request.fields['status'] = 'active';
      request.fields['visitorHouseNumber'] = _houseNumber;
      request.fields['visitorContactMatter'] = _contactMatter;
      request.fields['visitorVehicleType'] = _vehicleType;
      // request.fields['date'] = _date;
      // request.fields['time'] = _time;
      // request.fields['imageIdCard'] = _imagePathIdCard;
      // request.fields['imagePlate'] = _imagePathPalte;

      var response = await request.send();
      log(response.statusCode.toString());
      if (SUCCESS == response.statusCode || CREATE == response.statusCode) {
        return Success(code: SUCCESS, response: 'Success');
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(
          code: NO_INTERNET, errorResponse: 'No Internet Connection');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }

  static Future<Object> deleteVisitor(String id) async {
    String token = PreferenceUtils.getString('accessToken');

    try {
      var url = Uri.parse(NEST_LOCAL_HOST + "/visitors/" + id);

      var headers = {'authorization': 'Bearer $token'};
      var response = await http.delete(url, headers: headers);
      // log(response.statusCode.toString());
      if (SUCCESS == response.statusCode) {
        return Success(code: SUCCESS, response: 'Deleted');
      } else {
        return Failure(
            code: USER_INVALID_RESPONSE, errorResponse: 'Invalid Response');
      }
    } on SocketException {
      return Failure(code: NO_INTERNET, errorResponse: 'No Internet');
    } on FormatException {
      return Failure(code: INVALID_FORMAT, errorResponse: 'Invalid Format');
    } catch (e) {
      log(e.toString());
      return Failure(code: UNKNOWN_ERROR, errorResponse: 'Unknown Error');
    }
  }
}
