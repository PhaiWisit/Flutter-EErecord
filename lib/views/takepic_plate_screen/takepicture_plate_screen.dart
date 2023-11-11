import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ee_record_mvvm/models/license_plate_model.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class TakePictureScreenLicensePlate extends StatefulWidget {
  const TakePictureScreenLicensePlate({Key? key, required this.camera})
      : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenLicensePlateState createState() =>
      TakePictureScreenLicensePlateState();
}

class TakePictureScreenLicensePlateState
    extends State<TakePictureScreenLicensePlate> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool condition = false;
  bool flash_status = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ถ่ายภาพทะเบียนรถ"),
        backgroundColor: color1DeepBlue,
      ),
      backgroundColor: color1DeepBlue,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CameraPreview(
                  _controller,
                  child: Image.asset('assets/images/camera_frame2.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!flash_status) {
                            _controller.setFlashMode(FlashMode.torch);
                            setState(() {
                              flash_status = true;
                            });
                          } else {
                            _controller.setFlashMode(FlashMode.off);
                            setState(() {
                              flash_status = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                !flash_status ? Colors.white : Colors.amber),
                        child: Text(
                          "Flash",
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  camera: widget.camera,
                  imageName: image.name,
                ),
              ),
            )
                .then((value) {
              Navigator.of(context).pop(value);
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String imageName;

  const DisplayPictureScreen(
      {Key? key,
      required this.imagePath,
      required this.camera,
      required this.imageName})
      : super(key: key);

  final CameraDescription camera;
  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // ignore: unused_field
  late LicensePlateModel _dataFromAPI;

  @override
  void initState() {
    super.initState();
    cropImage();
    getLicensePlateData();
  }

  Map<String, String> get headers => {
        "Apikey": AIFORTHAI_API_KEY,
        "Content-Type": "application/x-www-form-urlencoded",
      };

  void cropImage() {
    final image = img.decodeImage(File(widget.imagePath).readAsBytesSync())!;
    final thumbnail = img.copyCrop(image, 60, 240, 360, 240);
    File(widget.imagePath).writeAsBytesSync(img.encodePng(thumbnail));
  }

  Future<LicensePlateModel> getLicensePlateData() async {
    var postUri = Uri.parse(AIFORTHAI_API);
    // final encoding = Encoding.getByName('utf-8');
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    http.MultipartFile imageApi =
        await http.MultipartFile.fromPath('file', widget.imagePath);

    request.files.add(imageApi);
    request.headers.addAll(headers);
    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      var response = await http.Response.fromStream(streamedResponse);
      // final respStr = await json.decode(utf8.decode(response.bodyBytes));
      return _dataFromAPI =
          licensePlateModelFromJson(utf8.decode(response.bodyBytes));
    } else {
      return _dataFromAPI = LicensePlateModel(
          box: [],
          rChar: 'ไม่ระบุ',
          rDigit: '',
          rProvince: '',
          recognition: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตรวจสอบรูปภาพ',
        ),
        backgroundColor: color1DeepBlue,
      ),
      backgroundColor: color1DeepBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Image.file(File(widget.imagePath)),
            ),
          ),
          FutureBuilder(
              future: getLicensePlateData(),
              builder: ((context, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                } else {
                  return Text(
                    "หมายเลขทะเบียน : " +
                        _dataFromAPI.rChar +
                        " " +
                        _dataFromAPI.rDigit +
                        " " +
                        _dataFromAPI.rProvince,
                    style: TextStyle(color: color1White),
                  );
                }
              })),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 140,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color1Yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(widget.imagePath);
              },
              child: const Text(
                'ใช้ภาพนี้',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
