import 'package:ee_record_mvvm/models/visitor_error.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/services/api_status.dart';
import 'package:ee_record_mvvm/services/visitor_service.dart';
import 'package:flutter/foundation.dart';

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
    // getVisitor();
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
}
