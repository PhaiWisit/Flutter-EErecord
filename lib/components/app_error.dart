import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError({Key? key, required this.errortext}) : super(key: key);

  final String errortext;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: errortext.isNotEmpty,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            errortext,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ));
  }
}
