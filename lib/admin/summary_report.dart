import 'dart:io';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/summary_admin_controller.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';


class SummaryReport extends StatefulWidget {
  const SummaryReport({ super.key });

  @override
  SummaryReportState createState() => SummaryReportState();
}

class SummaryReportState extends State<SummaryReport> {

  final Incident incidentController = Incident();
  final AlertController alertController = AlertController();
  
  late DateTime? startDate;
  late DateTime? endDate;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
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
              //spacing
              const SizedBox(height: 18,),
              //title
              const Center(child:  Text("Summary Report", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 24, letterSpacing: 1.5, wordSpacing: 0.5))),
          
            
          
          
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
    future: SummaryController.getAll(),
    builder: (context, snapshot) {
      if(!snapshot.hasData){
        return Container();
      }else if(snapshot.data!.isEmpty){
        return const Center(child: Text("No Data", style: TextStyle(fontSize: 40),),);
      }else{
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final data = snapshot.data![index];
            final startDate = "${data.startDate.month}/${data.startDate.day}/${data.startDate.year}";
            final endDate = "${data.endDate.month}/${data.endDate.day}/${data.endDate.year}";
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Text("${data.monthText} Monthly Report", style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 24),),
              
                  RichText(
                    text: TextSpan(
                        text: "Start Date: ",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 17),
                        children: [
                      TextSpan(
                          text: startDate.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16))
                  ])),
              
                  RichText(
                    text: TextSpan(
                        text: "End Date: ",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 17),
                        children: [
                      TextSpan(
                          text: endDate.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16))
                  ])),
              
                  RichText(
                    text: TextSpan(
                        text: "Total Report: ",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 17),
                        children: [
                      TextSpan(
                          text: data.totalReport.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16))
                  ])),
                   Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                  ),
                ],
              ),
            );
          },
        );
      }
    },
  );

}