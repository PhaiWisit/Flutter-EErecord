import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTimeActive extends StatefulWidget {
  const HomeTimeActive(
      {Key? key, required this.index, required this.visitorsViewModel})
      : super(key: key);

  final int index;
  final VisitorsProvider visitorsViewModel;

  @override
  State<HomeTimeActive> createState() => _HomeTimeActiveState();
}

class _HomeTimeActiveState extends State<HomeTimeActive> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _timeActive(widget.index)[2],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              _timeActive(widget.index)[0] + " ",
              style: TextStyle(color: _timeActive(widget.index)[1]),
            ),
          );
        },
      ),
    );
  }

  List _timeActive(int index) {
    DateTime now = DateTime.now();
    DateTime visitorEnter =
        widget.visitorsViewModel.visitorActive[index].visitorEnter;
    String date = DateFormat("dd/MM/yyyy HH:mm:ss").format(visitorEnter);
    DateTime timeEntry = DateFormat("dd/MM/yyyy HH:mm:ss").parse(date);

    Duration diff = now.difference(timeEntry);
    return _printDuration(diff);
  }

  List _printDuration(Duration duration) {
    Color colorGreen1 = Color(0xFF76BAA5);
    Color colorGreen2 = Color(0xFFE3F9F4);
    Color colorOrange1 = Colors.orange.shade300;
    Color colorOrange2 = Color.fromARGB(255, 253, 234, 206);
    Color colorRed1 = Colors.red.shade300;
    Color colorRed2 = Color.fromARGB(255, 255, 226, 229);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = duration.inHours.remainder(24).toString();
    String minutes = duration.inMinutes.remainder(60).toString();
    // String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    // String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    List onlineDay = [
      duration.inDays.toString() + ' วัน ' + hours + ' ชั่วโมง',
      colorRed1,
      colorRed2
    ];

    List onlineHours = [
      hours + ' ชั่วโมง ' + minutes + ' นาที',
      colorOrange1,
      colorOrange2
    ];

    List onlineMinutes = [
      minutes + ' นาที ' + twoDigitSeconds + ' วินาที',
      colorGreen1,
      colorGreen2
    ];

    if (duration.inDays >= 1) {
      return onlineDay;
    } else if (duration.inHours >= 1) {
      return onlineHours;
    } else {
      return onlineMinutes;
    }
  }
}
