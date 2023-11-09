import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/function.dart';
import 'package:ee_record_mvvm/utils/navigation.dart';
import 'package:flutter/material.dart';

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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            Text(
                              'EE Record',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Row(
                              children: [
                                Text(
                                  'ระบบบันทึกข้อมูลผู้เข้า-ออกหมู่บ้าน',
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
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
              primary: color1DeepBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              openRegisterScreen(context, camera);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text(
                  'เพิ่มผู้มาติดต่อ',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
