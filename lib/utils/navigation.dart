import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/views/home_screen.dart';
import 'package:ee_record_mvvm/views/register_screen.dart';
import 'package:ee_record_mvvm/views/visitor_detail_screen.dart';
import 'package:flutter/material.dart';

void openVisitorDetialScreen(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: ((context) => VisitorDetailScreen())));
}

void openRegisterScreen(BuildContext context, CameraDescription camera) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: ((context) => RegisterScreen(
                camera: camera,
              ))));
}

void backToHome(BuildContext context, CameraDescription camera) async {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen(camera: camera)),
      (route) => false);
}
