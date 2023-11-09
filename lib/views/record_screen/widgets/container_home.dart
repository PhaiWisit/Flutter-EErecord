import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class ContainerHome extends StatelessWidget {
  const ContainerHome({
    Key? key,
    required this.houseNumber_controller,
    required this.textStyle_black_20,
  }) : super(key: key);

  final TextEditingController houseNumber_controller;
  final TextStyle textStyle_black_20;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Container(
        decoration: BoxDecoration(
          color: color1White,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: TextField(
          controller: houseNumber_controller,
          style: textStyle_black_20,
          decoration: InputDecoration(
            hintText: 'ใส่บ้านเลขที่',
            hintStyle: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
            labelStyle: textStyle_black_20,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            suffixIcon: IconButton(
              onPressed: houseNumber_controller.clear,
              icon: const Icon(Icons.clear),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}