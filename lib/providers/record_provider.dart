import 'package:ee_record_mvvm/models/record_error.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/services/api_status.dart';
import 'package:ee_record_mvvm/services/visitor_service.dart';
import 'package:flutter/foundation.dart';

class RecordProvider extends ChangeNotifier {
  bool _loading = false;
  bool _isBack = false;
  RecordError _recordError = RecordError(code: 0, massage: 'massage');

  bool get loading => _loading;
  bool get isBack => _isBack;
  RecordError get recordError => _recordError;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setIsBack(bool isback) async {
    _isBack = isback;
    notifyListeners();
  }

  setRecordError(RecordError recordError) {
    _recordError = recordError;
  }

  Future<void> uploadAll(VisitorModel body) async {
    setLoading(true);
    notifyListeners();
    var response = await VisitorServices.uploadAll(body);
    if (response is Success) {
      print('success');
      setIsBack(true);
    }
    if (response is Failure) {
      RecordError recordError = RecordError(
          code: response.code, massage: response.errorResponse.toString());
      setRecordError(recordError);
      print('failure');
    }
    setLoading(false);
    notifyListeners();
  }
}
