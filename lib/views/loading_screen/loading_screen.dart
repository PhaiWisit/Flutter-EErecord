import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/providers/login_provider.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:ee_record_mvvm/views/home_screen/home_screen.dart';
import 'package:ee_record_mvvm/views/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  Future<void> getToken(BuildContext context, LoginProvider loginState) async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = '0';
      accessToken = prefs.getString('accessToken');
      log(accessToken!);

      if (accessToken != '0') {
        var uri = Uri.parse(NEST_LOCAL_SERVER + NEST_PROFILE);
        var response = await http.get(
          uri,
          headers: {"Authorization": "Bearer $accessToken"},
        ).timeout(Duration(seconds: 5), onTimeout: () {
          return http.Response('error', 408);
        });

        log(response.body);
        // var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen(camera: camera);
              },
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen(camera: camera);
              },
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(camera: camera);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginState = context.watch<LoginProvider>();

    getToken(context, loginState);

    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   if (loginState.isLogged) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) {
    //           return HomeScreen(camera: camera);
    //         },
    //       ),
    //     );
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) {
    //           return LoginScreen(camera: camera);
    //         },
    //       ),
    //     );
    //   }
    // });

    return Scaffold(
      backgroundColor: color1DeepBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/resource/logo.png',
              fit: BoxFit.fitHeight,
              height: 100,
              width: 100,
            ),
            Text(
              "EE Record",
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
