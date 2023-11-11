import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:ee_record_mvvm/components/app_loading.dart';
import 'package:ee_record_mvvm/components/loading_widget.dart';
import 'package:ee_record_mvvm/models/login_error.dart';
import 'package:ee_record_mvvm/models/login_token_model.dart';
import 'package:ee_record_mvvm/providers/login_provider.dart';
import 'package:ee_record_mvvm/services/login_service.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/constants.dart';
import 'package:ee_record_mvvm/views/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/api_status.dart';

// import 'home.dart';
// import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.camera}) : super(key: key);
  final CameraDescription camera;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    if (_boxLogin.get("loginStatus") ?? false) {
      // return Home();
    }

    return Scaffold(
      backgroundColor: color1DeepBlue,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/resource/logo.png',
                fit: BoxFit.fitHeight,
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              Text(
                "EE Record",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
              const SizedBox(height: 10),
              Text(
                "กรุณาเข้าสู่ระบบหมู่บ้านของคุณ",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "ชื่อผู้ใช้",
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color1White),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาใส่ชื่อผู้ใช้";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "รหัสผ่าน",
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: const Icon(
                    Icons.password_outlined,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(
                              Icons.visibility_outlined,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.white,
                            )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color1White),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาใส่รหัสผ่าน";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  Consumer<LoginProvider>(
                      builder: ((context, loginState, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).clearSnackBars();

                        if (_formKey.currentState?.validate() ?? false) {
                          _boxLogin.put("loginStatus", true);
                          _boxLogin.put("userName", _controllerUsername.text);

                          await loginState.login(_controllerUsername.text,
                              _controllerPassword.text);

                          if (!loginState.isLogged) {
                            String errorMessage = 'เกิดข้อผิดพลาด';
                            switch (loginState.loginError.code) {
                              case 200:
                                errorMessage = 'เข้าสู่ระบบแล้ว';
                                break;
                              case 400:
                                errorMessage = 'ไม่พบบัญชีผู้ใช้';
                                break;
                              case 401:
                                errorMessage =
                                    'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
                                break;
                              case 408:
                                errorMessage = 'หมดเวลาเชื่อมต่อ';
                                break;
                              default:
                                errorMessage = 'เกิดข้อผิดพลาด';
                                break;
                            }
                            final snackBar = SnackBar(
                              content: Text(errorMessage),
                              duration: Duration(seconds: 2),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          if (loginState.isLogged) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomeScreen(camera: widget.camera);
                                },
                              ),
                            );
                          }
                        }
                      },
                      child: loginState.loading
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              width: 15,
                              height: 15,
                            )
                          : Text("เข้าสู่ระบบ"),
                    );
                  })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ไม่มีบัญชีผู้ใช้ ?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const Signup();
                          //     },
                          //   ),
                          // );
                        },
                        child: const Text("สมัครใช้งานฟรี",
                            style: TextStyle(color: Colors.amber)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
