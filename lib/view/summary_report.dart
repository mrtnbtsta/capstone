import 'dart:io';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/models/summary_model.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/summary_controller.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';


class SummaryUserReport extends StatefulWidget {
  const SummaryUserReport({ super.key });

  @override
  SummaryUserReportState createState() => SummaryUserReportState();
}

class SummaryUserReportState extends State<SummaryUserReport> {

  final Incident incidentController = Incident();
  final AlertController alertController = AlertController();
  
  late DateTime? startDate;
  late DateTime? endDate;
  dynamic typeReport;
  List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

List<SummaryUserModel1> data1 = <SummaryUserModel1>[];

@override
  void initState() {
    SummaryUserController.getAll().then((value){
      for(var i = 0; i < value.length; i++){
        setState(() {
          typeReport = value[i].typeOfReport;
        });
      }
    });

    SummaryUserController.getAll1().then((value){
      setState(() {
        data1.addAll(value);
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      drawer: const Sidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: Platform.isAndroid
                              ? const Icon(EvaIcons.menu,
                                  color: ColorTheme.primaryColor)
                              : const Icon(CupertinoIcons.bars,
                                  color: ColorTheme.primaryColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.zero,
                        child: Row(
                          // mainAxisAlignment: Ma,
                          children: [
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          buildAlertNotifications(
                                              alertController, context)),
                                  icon: const Icon(EvaIcons.alert_triangle,
                                      color: ColorTheme.primaryColor),
                                ),
                                StreamBuilder(
                                  stream: alertController
                                      .readingStreamController.stream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    } else if (snapshot.data!.isEmpty) {
                                      return Container();
                                    } else {
                                      return Positioned(
                                        left: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: snapshot.data!.isEmpty
                                                  ? Colors.transparent
                                                  : Colors.amber.shade600),
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            snapshot.data!.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => buildNotifications(
                                          incidentController, context)),
                                  icon: const Icon(EvaIcons.bell,
                                      color: ColorTheme.primaryColor),
                                ),
                                StreamBuilder(
                                  stream: incidentController
                                      .readingStreamController.stream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    } else if (snapshot.data!.isEmpty) {
                                      return Container();
                                    } else {
                                      return Positioned(
                                        left: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: snapshot.data!.isEmpty
                                                  ? Colors.transparent
                                                  : Colors.amber.shade600),
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            snapshot.data!.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildTextButton(currentEnum == ButtonEnum.bulletinBoard ? true : false, 0, "Bulletin Board"),
                    buildTextButton(currentEnum == ButtonEnum.resolvedReport ? true : false, 1, "Resolved Report"),
                  ],
                ),

                const SizedBox(height: 10),
                Center(child: buildTextButton(currentEnum == ButtonEnum.summaryReport ? true : false, 2, "Monthly Report")),
              //spacing
              const SizedBox(height: 18,),
              //title
              const Center(child:  Text("Summary Of Reporting", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 24, letterSpacing: 1.5, wordSpacing: 0.5))),
          
            
          
          
              displayDataWidget()
             
            
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       const Text("January Monthly Report", style: TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 20)),
              //       RichText(
              //       text: const TextSpan(
              //           text: "Start Date: ",
              //           style: TextStyle(
              //               color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16),
              //           children: [
              //         TextSpan(
              //             text: "1/5/24",
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.normal,
              //                 fontSize: 16,
              //                 letterSpacing: 1.5,
              //                 wordSpacing: 0.5))
              //       ])),
              //       RichText(
              //       text: const TextSpan(
              //           text: "End Date: ",
              //           style: TextStyle(
              //               color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16),
              //           children: [
              //         TextSpan(
              //             text: "1/29/24",
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 16,
              //                 letterSpacing: 1.5,
              //                 wordSpacing: 0.5))
              //       ])),
              //       RichText(
              //       text: const TextSpan(
              //           text: "Total  Report: ",
              //           style: TextStyle(
              //               color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16),
              //           children: [
              //         TextSpan(
              //             text: "9",
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.normal,
              //                 fontSize: 16,
              //                 letterSpacing: 1.5,
              //                 wordSpacing: 0.5))
              //       ])),
              //     ],
              //   ),
              // )
          
            ],
          ),
        ),
      ),
    );
  }


  Widget displayDataWidget() =>  FutureBuilder(
    future: SummaryUserController.getAll(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Container();
      }else if(snapshot.data!.isEmpty){
        return const Center(child: Text("No Data", style: TextStyle(fontSize: 40),),);
      }else{
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            final data = snapshot.data![index];
            var current = DateTime.now();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Text("${data.monthText} ${current.year}", style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 24),),
              
                  
              
                  RichText(
                    text: TextSpan(
                        text: "Types of Reports: ",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 17),
                        children: [
                      TextSpan(
                          text: "${data.typeOfReport} Reports",
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16))
                  ])),
                          
                  RichText(
                    text: TextSpan(
                    text: "Types of ${typeReport.toString()}: ",
                    style: const TextStyle(color: Colors.black87, fontSize: 17),
                    children: [
                      ...data1.map((e){
                        return TextSpan(text: "${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17));
                      })
                    ]
                    ),
                  ),

                  const Divider(),

                ],
              ),
            );
          },
        );
      }
    },
  );
  Widget buildTextButton(bool isSelected, int index, String text) => InkWell(
    onTap: () {
      setState((){
        switch(index){
          case 0:
          currentEnumButton = ButtonEnum.bulletinBoard;
           Navigator.of(context).pushNamed(
              RouteName.bulletinBoard,
          );
          break;
          case 1:
          currentEnumButton = ButtonEnum.resolvedReport;
           Navigator.of(context).pushNamed(
              RouteName.actionedUser,
          );
          break;
          case 2:
          currentEnumButton = ButtonEnum.summaryReport;
          //  Navigator.of(context).pushNamed(
          //     RouteName.summaryUserReport,
          // );
          break;
        }
      });
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: isSelected ? const Color.fromARGB(255, 247, 208, 91) : ColorTheme.primaryColor
      ),
      child: Text(text, style: const TextStyle(color: ColorTheme.accentColor, fontSize: 14, letterSpacing: 1.5, wordSpacing: 0.5),),
    ),
  );
}

