import 'dart:developer';

import 'package:ee_record_mvvm/models/visitor_error.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/services/api_status.dart';
import 'package:ee_record_mvvm/services/visitor_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class VisitorsProvider extends ChangeNotifier {
  bool _loading = false;
  List<VisitorModel> _visitorListModel = [];
  List<VisitorModel> _visitorActive = [];
  List<VisitorModel> _visitorInactive = [];
  VisitorError _visitorError = VisitorError(code: 0, massage: 'error');
  VisitorModel? _selectedVisitor;

  bool get loading => _loading;
  List<VisitorModel> get visitorListModel => _visitorListModel;
  List<VisitorModel> get visitorActive => _visitorActive;
  List<VisitorModel> get visitorInactive => _visitorInactive;
  VisitorError get visitorError => _visitorError;
  VisitorModel get selectedVisitor => _selectedVisitor!;

  VisitorsProvider() {
    // List<VisitorModel> visitorListModel = [];
    // List<VisitorModel> visitorActive = [];
    // List<VisitorModel> visitorInactive = [];
    // setVisitorListModel(visitorListModel);
    // setVisitorActive(visitorActive);
    // setVisitorInactive(visitorInactive);

    getVisitorActive();
    getVisitorInactive();
  }

  onRefresh() {
    getVisitorActive();
    getVisitorInactive();
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setVisitorError(VisitorError visitorError) {
    _visitorError = visitorError;
  }

  setVisitorListModel(List<VisitorModel> visitorListModel) {
    _visitorListModel = visitorListModel;
  }

  setVisitorActive(List<VisitorModel> visitorActive) {
    _visitorActive = visitorActive;
  }

  setVisitorInactive(List<VisitorModel> visitorInactive) {
    _visitorInactive = visitorInactive;
  }

  setSelectedVisitor(VisitorModel visitorModel) {
    _selectedVisitor = visitorModel;
  }

  // updateStatus(visitorModel) {}

  getVisitor() async {
    setLoading(true);
    var response = await VisitorServices.getVisitor();
    if (response is Success) {
      setVisitorListModel(response.response as List<VisitorModel>);
      print('GET ALL VISITOR SUCCESS');
    }
    if (response is Failure) {
      VisitorError visitorError = VisitorError(
          code: response.code, massage: response.errorResponse.toString());
      setVisitorError(visitorError);
    }
    setLoading(false);
  }

  getVisitorActive() async {
    setLoading(true);
    var response = await VisitorServices.getVisitorActive();
    if (response is Success) {
      setVisitorActive(response.response as List<VisitorModel>);
    }
    if (response is Failure) {
      VisitorError visitorError = VisitorError(
          code: response.code, massage: response.errorResponse.toString());
      setVisitorError(visitorError);
    }
    setLoading(false);
  }

  getVisitorInactive() async {
    setLoading(true);
    var response = await VisitorServices.getVisitorInactive();
    if (response is Success) {
      setVisitorInactive(response.response as List<VisitorModel>);
    }
    if (response is Failure) {
      VisitorError visitorError = VisitorError(
          code: response.code, massage: response.errorResponse.toString());
      setVisitorError(visitorError);
    }
    setLoading(false);
  }

  onDeleteVisitor(String id) async {
    // setLoading(true);
    var response = await VisitorServices.deleteVisitor(id);
    if (response is Success) {
      // List<VisitorModel> visitorListModel = [];
      // setVisitorActive(visitorListModel);
      // onRefresh();
      // log('DELETE VISITOR SUCCESS');
    }
    if (response is Failure) {
      VisitorError visitorError = VisitorError(
          code: response.code, massage: response.errorResponse.toString());
      setVisitorError(visitorError);
    }
    // setLoading(false);
  }

  Future<void> onUpdateStatus(VisitorModel visitorModel) async {
    setLoading(true);
    DateTime now = DateTime.now();
    var dateFormat = DateFormat.yMd();
    var timeFormat = DateFormat.Hms();

    String _id = visitorModel.id.toString();
    String _dateExit = dateFormat.format(now);
    String _timeExit = timeFormat.format(now);

    http.StreamedResponse response =
        await VisitorServices.updateStatus(_id, _dateExit, _timeExit);

    if (response.statusCode == 200) {
      setLoading(false);
      print(await response.stream.bytesToString());
      await onRefresh();
    } else {
      setLoading(false);
      print(response.reasonPhrase);
    }
  }
}
