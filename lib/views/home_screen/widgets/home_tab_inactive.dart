import 'package:ee_record_mvvm/components/app_error.dart';
import 'package:ee_record_mvvm/components/app_loading.dart';
import 'package:ee_record_mvvm/models/visitor_list_model.dart';
import 'package:ee_record_mvvm/utils/app_color.dart';
import 'package:ee_record_mvvm/utils/function.dart';
import 'package:ee_record_mvvm/utils/navigation.dart';
import 'package:ee_record_mvvm/providers/visitors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabInactive extends StatelessWidget {
  const HomeTabInactive({Key? key}) : super(key: key);
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
            itemCount: visitorsViewModel.visitorInactive.length,
            itemBuilder: (BuildContext context, int index) {
              return _cardInactive(
                  context: context,
                  index: index,
                  visitorsViewModel: visitorsViewModel);
            }),
      );
    }
  }

  Widget _cardInactive(
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
            VisitorModel visitorModel =
                visitorsViewModel.visitorInactive[index];
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
                                    visitorsViewModel.visitorInactive[index]
                                        .visitorHouseNumber
                                        .toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 200, 241, 200),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      'สำเร็จ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 24, 150, 28)),
                                    ),
                                  )),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: visitorsViewModel.visitorInactive[index]
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
                                                .visitorInactive[index]
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
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(' วันที่ ' +
                                                        visitorsViewModel
                                                            .visitorInactive[
                                                                index]
                                                            .visitorDateEntry)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(' เวลา ' +
                                                        visitorsViewModel
                                                            .visitorInactive[
                                                                index]
                                                            .visitorTimeEntry)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, right: 8),
                                          child: Container(
                                            width: 2,
                                            color: color1Yellow,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('วันที่ ' +
                                                        visitorsViewModel
                                                            .visitorInactive[
                                                                index]
                                                            .visitorDateExit)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text('เวลา ' +
                                                        visitorsViewModel
                                                            .visitorInactive[
                                                                index]
                                                            .visitorTimeExit)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
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
