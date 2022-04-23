import 'dart:io';

import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'api_status.dart';

class VisitorServices {
  static Future<Object> getVisitor() async {
    try {
      var url = Uri.parse(VISITOR_ALL);
      var response = await http.get(url);
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
    try {
      var url = Uri.parse(VISITOR_ACTIVE);
      var response = await http.get(url);
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
    try {
      var url = Uri.parse(VISITOR_INACTIVE);
      var response = await http.get(url);
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
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', Uri.parse(VISITOR_UPDATE_STATUS));
    request.bodyFields = {'id': id, 'date': dateExit, 'time': timeExit};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }

  static Future<Object> uploadAll(VisitorModel body) async {
    String _houseNumber = body.visitorHouseNumber.toString();
    String _contactMatter = body.visitorContactMatter;
    String _vehicleType = body.visitorVehicleType;
    String _date = body.visitorDateEntry;
    String _time = body.visitorTimeEntry;
    String _imagePathIdCard = body.visitorImagePathIdCard;
    String _imagePathCarRegis = body.visitorImagePathCarRegis;
    try {
      var postUri = Uri.parse(VISITOR_UPLOAD);
      http.MultipartRequest request = http.MultipartRequest("POST", postUri);
      http.MultipartFile multipartFile1 =
          await http.MultipartFile.fromPath('imageIdCard', _imagePathIdCard);
      http.MultipartFile multipartFile2 = await http.MultipartFile.fromPath(
          'imageCarRegis', _imagePathCarRegis);
      request.files.add(multipartFile1);
      request.files.add(multipartFile2);
      request.fields['status'] = 'active';
      request.fields['houseNumber'] = _houseNumber;
      request.fields['contactMatter'] = _contactMatter;
      request.fields['vehicleType'] = _vehicleType;
      request.fields['date'] = _date;
      request.fields['time'] = _time;
      request.fields['imagePathIdCard'] = _imagePathIdCard;
      request.fields['imagePathCarRegis'] = _imagePathCarRegis;

      var response = await request.send();
      if (SUCCESS == response.statusCode) {
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
}
