import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';

class ContainerHead extends StatelessWidget {
  const ContainerHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: color1DeepBlue,
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  'assets/resource/logo.png',
                  fit: BoxFit.fitHeight,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            Text(
              " บันทึกข้อมูลผู้มาติดต่อ",
              style: TextStyle(color: color1White, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
