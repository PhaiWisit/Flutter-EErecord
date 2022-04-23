import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog(
      {Key? key,
      required this.title,
      required this.content,
      this.okButton,
      this.ccButton})
      : super(key: key);

  final String title;
  final String content;
  final String? okButton;
  final String? ccButton;

  get color1DeepBlue => null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (ccButton != null)
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              ccButton!,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        if (okButton != null)
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(
              okButton!,
              style: TextStyle(color: color1DeepBlue),
            ),
          ),
      ],
    );
  }
}
