import 'dart:io';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/summary_controller.dart';
import 'package:capstone_project/models/summary_model.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';


class MonthlyReport extends StatefulWidget {
  const MonthlyReport({ super.key });

  @override
  MonthlyReportState createState() => MonthlyReportState();
}



class MonthlyReportState extends State<MonthlyReport> {

  bool isEditable = true;

  final Incident incidentController = Incident();
  final AlertController alertController = AlertController();
  //emergency
  final typeOfReportsController = TextEditingController();
  final typeOfEmergencyController = TextEditingController();

  //hazard
  final typeOfReportsController1 = TextEditingController();
  final typeOfEmergencyController1 = TextEditingController();

  //crime
  final typeOfReportsController2 = TextEditingController();
  final typeOfEmergencyController2 = TextEditingController();
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

dynamic hazardType;
dynamic crimeType;
List<MonthlyModel1> dataEmergency = [];
List<MonthlyModel1> dataHazard = [];
List<MonthlyModel1> dataCrime = [];

@override
  void initState() {

    //emergency
    typeOfReportsController.text = "Type of Reports: ";
    typeOfEmergencyController.text = "Types of Emergency: ";
    //hazard
    typeOfReportsController1.text = "Type of Reports: ";
    typeOfEmergencyController1.text = "Types of Emergency: ";
    //crime
    typeOfReportsController2.text = "Type of Reports: ";
    typeOfEmergencyController2.text = "Types of Emergency: ";

    MonthlyController.getAllEmergencyDataCount().then((value){
      setState(() {
        dataEmergency.addAll(value);
      });
    });

    MonthlyController.getAllHazardDataCount().then((value){
      setState(() {
        dataHazard.addAll(value);
      });
    });

    MonthlyController.getAllCrimeDataCount().then((value){
      setState(() {
        dataCrime.addAll(value);
      });
    });

    MonthlyController.getAllHazard().then((value){
      for(var i = 0; i < value.length; i++){
        hazardType = value[i].typeOfReport;
      }
    });

    MonthlyController.getAllCrime().then((value){
      for(var i = 0; i < value.length; i++){
        crimeType = value[i].typeOfReport;
      }
    });

    super.initState();
  }


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
              const Center(child:  Text("Monthly Report", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 24, letterSpacing: 1.5, wordSpacing: 0.5))),
          
              FutureBuilder(
                future: MonthlyController.getAllEmergency(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return const SizedBox.shrink();
                  }else if(snapshot.data!.isEmpty){
                    return const SizedBox.shrink();
                  }else{
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Center(
                                child: Text("${data.monthText} ${DateTime.now().year.toString()}", style: const TextStyle(color: Colors.black87, fontSize: 24, letterSpacing: 1.5, wordSpacing: 0.5),),
                              ),

                              FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: TextFormField(
                                        controller: typeOfReportsController,
                                        readOnly: isEditable,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none
                                            ),                        
                                      ),
                                    ),
                                    Text("${data.typeOfReport} Report",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 1.5,
                                          wordSpacing: 0.5,
                                          fontSize: 18))
                                  ],
                                ),
                              ),

                              // RichText(
                              //   text: TextSpan(
                              //       text: "Types of Reports: ",
                              //       style: const TextStyle(
                              //           color: Colors.black87, fontSize: 17),
                              //       children: [
                              //     TextSpan(
                              //         text: "${data.typeOfReport} Report",
                              //         style: const TextStyle(
                              //             color: Colors.black,
                              //             letterSpacing: 1.5,
                              //             wordSpacing: 0.5,
                              //             fontSize: 16))
                              // ])),

                               FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: TextFormField(
                                        controller: typeOfEmergencyController,
                                        readOnly: isEditable,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none
                                            ),                        
                                      ),
                                    ),
                                    ...dataEmergency.map((e){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text("${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17)),
                                    );
                                  }),
                                  ],
                                ),
                              ),

                              // RichText(
                              //   text: TextSpan(
                              //   text: "Types of Emergency: ",
                              //   style: const TextStyle(color: Colors.black87, fontSize: 17),
                              //   children: [
                              //     ...dataEmergency.map((e){
                              //       return TextSpan(text: "${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17));
                              //     }),
                              //   ]
                              //   ),
                              // ),
                              
                            

                              FutureBuilder(
                                future: MonthlyController.getAllHazard(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return const SizedBox.shrink();
                                  }else if(snapshot.data!.isEmpty){
                                    return const SizedBox.shrink();
                                  }else{
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // RichText(
                                          //   text: TextSpan(
                                          //       text: "Types of Reports: ",
                                          //       style: const TextStyle(
                                          //           color: Colors.black87, fontSize: 17),
                                          //       children: [
                                          //     TextSpan(
                                          //         text: "$hazardType Report",
                                          //         style: const TextStyle(
                                          //             color: Colors.black,
                                          //             letterSpacing: 1.5,
                                          //             wordSpacing: 0.5,
                                          //             fontSize: 16))
                                          // ])),

                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: TextFormField(
                                                controller: typeOfReportsController1,
                                                readOnly: isEditable,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none
                                                    ),                        
                                              ),
                                            ),
                                            Text("$hazardType Report",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 18))
                                          ],
                                        ),
                                      ),

                                      
                               FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: TextFormField(
                                        controller: typeOfEmergencyController,
                                        readOnly: isEditable,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none
                                            ),                        
                                      ),
                                    ),
                                    ...dataHazard.map((e){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text("${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17)),
                                    );
                                  }),
                                  ],
                                ),
                              ),

                                          // RichText(
                                          //   text: TextSpan(
                                          //       text: "Types of Emergency: ",
                                          //       style: const TextStyle(
                                          //           color: Colors.black87, fontSize: 17),
                                          //       children: [
                                          //     ...dataHazard.map((e){
                                          //       return TextSpan(text: "${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17));
                                          //     })
                                          // ])),
                                          const Divider(),
                                        ],
                                      );
                                  }
                                },
                              ),


                              FutureBuilder(
                                future: MonthlyController.getAllCrime(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return const SizedBox.shrink();
                                  }else if(snapshot.data!.isEmpty){
                                    return const SizedBox.shrink();
                                  }else{
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                        fit: BoxFit.contain,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              child: TextFormField(
                                                controller: typeOfReportsController2,
                                                readOnly: isEditable,
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none
                                                    ),                        
                                              ),
                                            ),
                                            Text("$hazardType Report",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 18))
                                          ],
                                        ),
                                      ),
                                          // RichText(
                                          //   text: TextSpan(
                                          //       text: "Types of Reports: ",
                                          //       style: const TextStyle(
                                          //           color: Colors.black87, fontSize: 17),
                                          //       children: [
                                          //     TextSpan(
                                          //         text: "$crimeType Report",
                                          //         style: const TextStyle(
                                          //             color: Colors.black,
                                          //             letterSpacing: 1.5,
                                          //             wordSpacing: 0.5,
                                          //             fontSize: 16))
                                          // ])),

                                          // RichText(
                                          //   text: TextSpan(
                                          //       text: "Types of Emergency: ",
                                          //       style: const TextStyle(
                                          //           color: Colors.black87, fontSize: 17),
                                          //       children: [
                                          //     ...dataCrime.map((e){
                                          //       return TextSpan(text: "${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17));
                                          //     })
                                          // ])),

                                           FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: TextFormField(
                                        controller: typeOfEmergencyController2,
                                        readOnly: isEditable,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none
                                            ),                        
                                      ),
                                    ),
                                    ...dataCrime.map((e){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text("${e.count.toString()} ${e.typeOfReport.toString() }, ", style: const TextStyle(color: Colors.black87, fontSize: 17)),
                                    );
                                  }),
                                  ],
                                ),
                              ),

                                        ],
                                      );
                                  }
                                },
                              ),

                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              )
          
            ],
          ),
        ),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: TextButton(
                      onPressed: (){
                        setState(() {
                          isEditable = !isEditable;
                          print(isEditable);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: ColorTheme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: const Text("Post", style: TextStyle(color: ColorTheme.accentColor, fontSize: 19, letterSpacing: 1.5, wordSpacing: 0.5),),
                      ),
                  ),
    );
  }

}