import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/view_models/register_view_model.dart';
import 'package:ee_record_mvvm/view_models/visitors_view_model.dart';
import 'package:ee_record_mvvm/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitorsViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EE Record',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(
          camera: camera,
        ),
      ),
    );
  }
}
