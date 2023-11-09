import 'package:ee_record_mvvm/models/visitor_error.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/services/visitor_service.dart';
import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void onRefresh(BuildContext context) async {
  VisitorError _visitorError = VisitorError(code: 0, massage: 'error');
  await Future.delayed(Duration(milliseconds: 500));
  Provider.of<VisitorsProvider>(context, listen: false).onRefresh();
  Provider.of<VisitorsProvider>(context, listen: false)
      .setVisitorError(_visitorError);
}

Future<void> onUpdateStatus(
    BuildContext context, VisitorModel visitorModel) async {
  DateTime now = DateTime.now();
  var dateFormat = DateFormat.yMd();
  var timeFormat = DateFormat.Hms();

  String _id = visitorModel.visitorId.toString();
  String _dateExit = dateFormat.format(now);
  String _timeExit = timeFormat.format(now);

  http.StreamedResponse response =
      await VisitorServices.updateStatus(_id, _dateExit, _timeExit);

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    onRefresh(context);
  } else {
    print(response.reasonPhrase);
  }
}
