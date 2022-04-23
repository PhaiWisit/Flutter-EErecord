import 'package:flutter/cupertino.dart';

class Apploading extends StatelessWidget {
  const Apploading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
