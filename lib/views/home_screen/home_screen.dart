import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/providers/login_provider.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:ee_record_mvvm/utils/function.dart';
import 'package:ee_record_mvvm/utils/navigation.dart';
import 'package:ee_record_mvvm/utils/shared_pref.dart';
import 'package:ee_record_mvvm/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'widgets/home_tab_active.dart';
import 'widgets/home_tab_inactive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    onRefresh(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: color1Grey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: color1DeepBlue,
            bottom: TabBar(
              indicatorColor: color1Yellow,
              labelColor: color1Yellow,
              unselectedLabelColor: color1White,
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available),
                      SizedBox(
                        width: 4,
                      ),
                      Text('ตอนนี้')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history),
                      SizedBox(
                        width: 4,
                      ),
                      Text('ประวัติ')
                    ],
                  ),
                )
              ],
            ),
            flexibleSpace: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 80,
                            width: 80,
                            child:
                                Image.asset('assets/images/icon_shield.png')),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'EE Record',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                                // Test
                                TextButton(
                                    onPressed: () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove('accessToken');
                                      prefs.remove('username');
                                      prefs.remove('villageName');

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return LoginScreen(camera: camera);
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('Log out')),
                              ],
                            ),
                            Consumer<LoginProvider>(
                              builder: (BuildContext context,
                                  LoginProvider value, Widget? child) {
                                String username =
                                    PreferenceUtils.getString('username');
                                return Row(children: [
                                  Text(
                                    'ผู้ใช้งาน : $username',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ]);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: HomeTabActive(),
            ),
            Center(
              child: HomeTabInactive(),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 60,
          padding: EdgeInsets.all(5),
          color: color1Grey,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color1DeepBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              openRegisterScreen(context, camera);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(
                  'เพิ่มผู้มาติดต่อ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
