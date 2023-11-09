import 'package:ee_record_mvvm/components/loading_widget.dart';
import 'package:ee_record_mvvm/components/visitor_detail_time_active.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VisitorDetailScreen extends StatelessWidget {
  const VisitorDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisitorsProvider visitorsProvider = context.watch<VisitorsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลผู้มาติดต่อ'),
        backgroundColor: color1DeepBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color1DeepBlue,
        ),
        child: ListView(
          children: [
            container_houseNumber(visitorsProvider),
            container_contractMatter(visitorsProvider),
            container_datetime(visitorsProvider),
            container_idcard(visitorsProvider),
            container_plate(visitorsProvider)
          ],
        ),
      ),
    );
  }

  Widget container_header() {
    return Container(
      color: Colors.yellow.shade100,
      height: 40,
    );
  }

  Widget container_houseNumber(VisitorsProvider visitorsProvider) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
              child: Container(
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 100,
                child: Column(
                  children: [
                    visitorsProvider.selectedVisitor.visitorVehicleType ==
                            'รถยนต์'
                        ? Image.asset('assets/images/icon_car.png')
                        : Image.asset('assets/images/icon_bike.png'),
                    Text(visitorsProvider.selectedVisitor.visitorVehicleType +
                        ' ')
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
              child: SizedBox(
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  height: 100,
                  child: Column(
                    children: [
                      Icon(
                        Icons.house_outlined,
                        size: 30,
                      ),
                      Text(
                        'บ้านเลขที่ ',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        visitorsProvider.selectedVisitor.visitorHouseNumber
                            .toString(),
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container_contractMatter(VisitorsProvider visitorsProvider) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Text(
                        'เรื่องที่ติดต่อ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        visitorsProvider.selectedVisitor.visitorContactMatter +
                            ' ',
                        style: TextStyle(fontSize: 20),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget container_datetime(VisitorsProvider visitorsProvider) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: color1White,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 100,
                              child: Center(
                                child: Text(visitorsProvider
                                    .selectedVisitor.visitorStatus),
                              ),
                            ),
                            SizedBox(
                                height: 30,
                                child: VisitorDetailTimeActive(
                                  visitorModel:
                                      visitorsProvider.selectedVisitor,
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("เข้า " +
                                visitorsProvider
                                    .selectedVisitor.visitorDateEntry +
                                " " +
                                visitorsProvider
                                    .selectedVisitor.visitorTimeEntry)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            visitorsProvider.selectedVisitor.visitorDateExit ==
                                    ''
                                ? Text('ยังอยู่ในหมู่บ้าน')
                                : Text("ออก " +
                                    visitorsProvider
                                        .selectedVisitor.visitorDateExit +
                                    " " +
                                    visitorsProvider
                                        .selectedVisitor.visitorTimeExit)
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget container_idcard(VisitorsProvider visitorsProvider) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text(
                      'ภาพถ่ายบัตรประชาชน',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: color1White,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: CachedNetworkImage(
                        imageUrl: visitorsProvider
                            .selectedVisitor.visitorImagePathIdCard,
                        placeholder: (context, url) => LoadingWidget(
                          isImage: true,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget container_plate(VisitorsProvider visitorsProvider) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                    color: color1White,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text('ภาพถ่ายทะเบียนรถ', style: TextStyle(fontSize: 16)),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          color: color1White,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: CachedNetworkImage(
                        imageUrl: visitorsProvider
                            .selectedVisitor.visitorImagePathCarRegis,
                        placeholder: (context, url) => LoadingWidget(
                          isImage: true,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
