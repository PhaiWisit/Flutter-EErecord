import 'dart:convert';
import 'dart:developer';

import 'package:ee_record_mvvm/models/login_error.dart';
import 'package:ee_record_mvvm/models/login_token_model.dart';
import 'package:ee_record_mvvm/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_status.dart';

class LoginProvider extends ChangeNotifier {
  bool _loading = false;
  bool _isLogged = false;
  LoginTokenModel _loginTokenModel = LoginTokenModel(accessToken: '0');
  LoginError _loginError = LoginError(code: 0, massage: 'error');

  bool get loading => _loading;
  bool get isLogged => _isLogged;
  LoginTokenModel get loginTokenmodel => _loginTokenModel;
  LoginError get loginError => _loginError;

  LoginProvider() {}

  setLoginToken(LoginTokenModel loginTokenModel) {
    _loginTokenModel = loginTokenModel;
  }

  setLoginError(LoginError loginError) {
    _loginError = loginError;
    // notifyListeners();
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setIsLogged(bool isLogged) async {
    _isLogged = isLogged;
    notifyListeners();
  }

  login(username, password) async {
    setLoading(true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await LoginService.login(username, password);
    if (response is Success) {
      LoginTokenModel loginTokenModel =
          LoginTokenModel.fromRawJson(response.response.toString());

      // await prefs.setString('accessToken', loginTokenModel.accessToken);
      String? accessToken = '0';
      accessToken = prefs.getString('accessToken');
      log(accessToken!);
      setLoginToken(loginTokenModel);
      setIsLogged(true);
    }
    if (response is Failure) {
      LoginError loginError = LoginError(
          code: response.code, massage: response.errorResponse.toString());
      setIsLogged(false);
      setLoginError(loginError);
      // notifyListeners();
    }
    setLoading(false);
  }
}
