import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  
  SharedPref() {
    getInstance();
  }
  getInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}
