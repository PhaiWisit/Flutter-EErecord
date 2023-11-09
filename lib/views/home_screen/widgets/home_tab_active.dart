import 'package:ee_record_mvvm/components/app_error.dart';
import 'package:ee_record_mvvm/components/app_loading.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/function.dart';
import 'package:ee_record_mvvm/utils/navigation.dart';
import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_time_active.dart';

class HomeTabActive extends StatelessWidget {
  const HomeTabActive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisitorsProvider visitorsViewModel = context.watch<VisitorsProvider>();

    if (visitorsViewModel.loading) {
      return Apploading();
    } else if (visitorsViewModel.visitorError.code != 0) {
      return RefreshIndicator(
        onRefresh: () async {
          onRefresh(context);
        },
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            AppError(
              errortext: visitorsViewModel.visitorError.massage,
            ),
          ],
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          onRefresh(context);
        },
        child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: visitorsViewModel.visitorActive.length,
            itemBuilder: (BuildContext context, int index) {
              return _cardActive(
                  context: context,
                  index: index,
                  visitorsViewModel: visitorsViewModel);
            }),
      );
    }
  }

  Widget _cardActive(
      {required BuildContext context,
      required int index,
      required VisitorsProvider visitorsViewModel}) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            color: color1White,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: InkWell(
          onTap: () {
            VisitorModel visitorModel = visitorsViewModel.visitorActive[index];
            visitorsViewModel.setSelectedVisitor(visitorModel);
            openVisitorDetialScreen(context);
          },
          splashColor: Color.fromARGB(255, 245, 245, 245),
          child: SizedBox(
            height: 150,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'บ้านเลขที่ ' +
                                    visitorsViewModel
                                        .visitorActive[index].visitorHouseNumber
                                        .toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              HomeTimeActive(
                                  index: index,
                                  visitorsViewModel: visitorsViewModel)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: color1DeepBlue,
                                    border: Border.all(
                                        color: color1DeepGrey, width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: visitorsViewModel.visitorActive[index]
                                            .visitorVehicleType ==
                                        'รถยนต์'
                                    ? Image.asset('assets/images/icon_car.png')
                                    : Image.asset(
                                        'assets/images/icon_bike.png')),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 40,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            visitorsViewModel
                                                .visitorActive[index]
                                                .visitorContactMatter,
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 70,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('วันที่ ' +
                                                        visitorsViewModel
                                                            .visitorActive[
                                                                index]
                                                            .visitorDateEntry)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('เวลา ' +
                                                        visitorsViewModel
                                                            .visitorActive[
                                                                index]
                                                            .visitorTimeEntry)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 40,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: color1DeepBlue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                border: Border.all(
                                                    color: color1DeepGrey,
                                                    width: 3)),
                                            child: TextButton(
                                              child: const Text(
                                                'สำเร็จ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              onPressed: () {
                                                onUpdateStatus(
                                                    context,
                                                    visitorsViewModel
                                                        .visitorActive[index]);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
