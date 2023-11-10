import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/providers/record_provider.dart';
import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:ee_record_mvvm/views/home_screen/home_screen.dart';
import 'package:ee_record_mvvm/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
  await _initHive();

  runApp(MyApp(camera: firstCamera));
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitorsProvider()),
        ChangeNotifierProvider(create: (_) => RecordProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EE Record',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            // LoginScreen()
            HomeScreen(
          camera: camera,
        ),
      ),
    );
  }
}
