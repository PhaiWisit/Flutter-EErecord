import 'package:ee_record_mvvm/models/register_error.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/services/api_status.dart';
import 'package:ee_record_mvvm/services/visitor_service.dart';
import 'package:flutter/foundation.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _isBack = false;
  RegisterError _registerError = RegisterError(code: 0, massage: 'massage');

  bool get loading => _loading;
  bool get isBack => _isBack;
  RegisterError get registerError => _registerError;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setIsBack(bool isback) async {
    _isBack = isback;
    notifyListeners();
  }

  setRegisterError(RegisterError registerError) {
    _registerError = registerError;
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
      RegisterError registerError = RegisterError(
          code: response.code, massage: response.errorResponse.toString());
      setRegisterError(registerError);
      print('failure');
    }
    setLoading(false);
    notifyListeners();
  }
}
