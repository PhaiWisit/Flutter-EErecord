import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/components/app_alert_dialog.dart';
import 'package:ee_record_mvvm/components/app_loading.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/navigation.dart';
import 'package:ee_record_mvvm/providers/record_provider.dart';
import 'package:ee_record_mvvm/views/takepic_idcard_screen/takepicture_idcard_screen.dart';
import 'package:ee_record_mvvm/views/takepic_plate_screen/takepicture_plate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'widgets/container_head.dart';
import 'widgets/container_home.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;
  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

enum SingingCharacter { car, motocycle }

class _RecordScreenState extends State<RecordScreen> {
  var houseNumber_controller = TextEditingController();
  var about_controller = TextEditingController();

  late String image_path_idcard = '';
  late String image_path_carregis = '';

  static const textStyle_black_20 = TextStyle(color: color1Black, fontSize: 20);

  String selectedValue = "";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "ส่งอาหาร",
            textAlign: TextAlign.center,
          ),
          value: "ส่งอาหาร"),
      const DropdownMenuItem(
          child: Text(
            "ส่งผู้โดยสาร",
            textAlign: TextAlign.center,
          ),
          value: "ส่งผู้โดยสาร"),
      const DropdownMenuItem(
          child: Text(
            "ติดต่อลูกบ้าน",
            textAlign: TextAlign.center,
          ),
          value: "ติดต่อลูกบ้าน"),
      const DropdownMenuItem(
          child: Text(
            "อื่นๆ",
            textAlign: TextAlign.center,
          ),
          value: "อื่นๆ"),
    ];
    return menuItems;
  }

  late SingingCharacter? _character = SingingCharacter.motocycle;
  String vehicleType = 'รถจักรยานยนต์';

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.watch<RecordProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ระบบบันทึกการเข้าออกหมู่บ้าน'),
        backgroundColor: color1DeepBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: color1Grey,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ContainerHead(), // บันทึกข้อมูลผู้มาติดต่อ
              _space(5),
              Image.asset('assets/images/icon_house.png'),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: color1DeepBlue),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // บ้านเลขที่
                                ContainerHome(
                                    houseNumber_controller:
                                        houseNumber_controller,
                                    textStyle_black_20: textStyle_black_20),
                              ],
                            ),
                          ),
                          _space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _containerAbout(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selectedValue == 'อื่นๆ'
                                    ? _containerAboutOption()
                                    : _space(0),
                              ],
                            ),
                          ),
                          _space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _containerType(),
                              ],
                            ),
                          ),
                          _space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [_containerPictureIdCard()],
                            ),
                          ),
                          _space(20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [_containerPictureLicenesePlate()],
                            ),
                          ),
                          _containerSubmit(recordProvider),
                        ],
                      ),
                    ),
                    // Fix wrong onPressed when use transform position of button.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            onClickSendData(context);
                          },
                          child: SizedBox(
                              width: 200, height: 30, child: _space(30)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              _space(30)
            ],
          ),
        ),
      ),
      backgroundColor: color1Grey,
    );
  }

  // เรื่องที่ติดต่อ
  Widget _containerAbout() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: InputDecorator(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            hintText: "test",
          ),
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: color1White,
              ),
              child: DropdownButton(
                icon: const Icon(Icons.arrow_drop_down, color: color1Black),
                value: selectedValue.isNotEmpty ? selectedValue : null,
                items: dropdownItems.map((item) {
                  return DropdownMenuItem(
                    child: Container(child: item.child),
                    value: item.value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value.toString();
                  });
                },
                hint: Text(
                  "เรื่องที่ติดต่อ",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                style: TextStyle(color: color1Black, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ประเภทรถ
  Widget _containerType() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ประเภทรถ',
                    style: textStyle_black_20,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: Text(
                          'รถจักรยานยนต์',
                          style: TextStyle(color: color1Black, fontSize: 15),
                        ),
                      ),
                      leading: Radio<SingingCharacter>(
                        activeColor: color1DeepBlue,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        value: SingingCharacter.motocycle,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            vehicleType = 'รถจักรยานยนต์ ';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: const Text(
                          'รถยนต์',
                          style: TextStyle(color: color1Black, fontSize: 15),
                        ),
                      ),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.car,
                        activeColor: color1DeepBlue,
                        groupValue: _character,
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                            vehicleType = 'รถยนต์';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ภาพถ่าย
  Widget _containerPictureIdCard() {
    return Expanded(
      flex: 7,
      child: GestureDetector(
        onTap: () {
          onClickIdCard();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ภาพบัตรประชาชน',
                  style: TextStyle(color: color1Black, fontSize: 18),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: image_path_idcard == ""
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: color1DeepGrey,
                        )
                      : Icon(
                          Icons.check_box,
                          size: 50,
                          color: Colors.green.shade800,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerPictureLicenesePlate() {
    return Expanded(
      flex: 7,
      child: GestureDetector(
        onTap: () {
          onClickCarRegis();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ภาพป้ายทะเบียนรถ',
                  style: TextStyle(color: color1Black, fontSize: 18),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: image_path_carregis == ""
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: color1DeepGrey,
                        )
                      : Icon(
                          Icons.check_box,
                          size: 50,
                          color: Colors.green.shade800,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ปุ่มบันทึก
  Widget _containerSubmit(RecordProvider recordProvider) {
    if (recordProvider.loading) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 30),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color1Yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Apploading(),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, 30),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color1Yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    onClickSendData(context);
                  },
                  child: const Text(
                    'บันทึกข้อมูล',
                    style: textStyle_black_20,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _containerAboutOption() {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: about_controller,
                style: TextStyle(color: color1Black, fontSize: 16),
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  hintText: 'ระบุ',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  labelStyle: TextStyle(color: color1Black, fontSize: 16),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: about_controller.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            _space(20)
          ],
        ),
      ),
    );
  }

  Widget _space(double height) {
    return SizedBox(
      height: height,
    );
  }

  void onClickIdCard() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TakePictureIdCardScreen(
                  camera: widget.camera,
                )))
        .then((value) {
      setState(() {
        image_path_idcard = value;
      });
    });
  }

  void onClickCarRegis() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => TakePictureScreenLicensePlate(
                  camera: widget.camera,
                )))
        .then((value) {
      setState(() {
        image_path_carregis = value;
      });
    });
  }

  Future<void> onClickSendData(BuildContext context) async {
    DateTime now = DateTime.now();
    var dateFormat = DateFormat.yMd();
    var timeFormat = DateFormat.Hms();

    String _houseNumber = houseNumber_controller.text;
    String _contactMatter = selectedValue;
    String _vehicleType = vehicleType;
    String _date = dateFormat.format(now);
    String _time = timeFormat.format(now);
    String _imagePathIdCard = image_path_idcard;
    String _imagePathCarRegis = image_path_carregis;

    if (selectedValue == 'อื่นๆ') {
      _contactMatter = 'ระบุ : ' + about_controller.text;
    }

    if (houseNumber_controller.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title: 'แจ้งเตือน',
            content: 'คุณไม่ได้ใส่บ้านเลขที่ กรุณาใส่บ้านเลขที่',
            okButton: 'ตกลง',
          );
        },
      );
    } else if (image_path_idcard == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title: 'แจ้งเตือน',
            content: 'คุณไม่ได้ถ่ายภาพบัตรประชาชน กรุณาถ่ายภาพบัตรประชาชน',
            okButton: 'ตกลง',
          );
        },
      );
    } else if (selectedValue == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title: 'แจ้งเตือน',
            content: 'คุณไม่ได้เลือกเรื่องที่ติดต่อ กรุณาเลือกเรื่องที่ติดต่อ',
            okButton: 'ตกลง',
          );
        },
      );
    } else if (image_path_carregis == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppAlertDialog(
            title: 'แจ้งเตือน',
            content: 'คุณไม่ได้ถ่ายภาพทะเบียนรถ กรุณาถ่ายภาพทะเบียนรถ',
            okButton: 'ตกลง',
          );
        },
      );
    } else {
      VisitorModel visitorModel = VisitorModel(
          id: '0',
          visitorStatus: 'active',
          visitorHouseNumber: _houseNumber,
          visitorContactMatter: _contactMatter,
          visitorVehicleType: _vehicleType,
          visitorEnter: DateTime.now(),
          visitorUpdate: DateTime.now(),
          visitorExit: DateTime.now(),
          // visitorTimeExit: '',
          visitorImagePathIdCard: _imagePathIdCard,
          visitorImagePathPalte: _imagePathCarRegis);

      var recordProvider = Provider.of<RecordProvider>(context, listen: false);
      await recordProvider.uploadAll(visitorModel);
      if (recordProvider.isBack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 500),
            content: const Text(
              'บันทึกข้อมูลสำเร็จ',
              style: TextStyle(color: color1White, fontSize: 16),
            ),
          ),
        );
        backToHome(context, widget.camera);
      } else if (recordProvider.recordError.code != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text(
              "ERROR : " + recordProvider.recordError.massage,
              style: TextStyle(color: color1White, fontSize: 16),
            ),
          ),
        );
      }
    }
  }
}
