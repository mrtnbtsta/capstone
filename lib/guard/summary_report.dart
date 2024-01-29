import 'package:capstone_project/controllers/summary_controller.dart';
import 'package:capstone_project/guard_sidebar.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';


class SummaryGuardReport extends StatefulWidget {
  const SummaryGuardReport({ super.key });

  @override
  SummaryGuardReportState createState() => SummaryGuardReportState();
}

class SummaryGuardReportState extends State<SummaryGuardReport> {
  
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
      appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(EvaIcons.arrow_back, color: ColorTheme.secondaryColor,),
            onPressed: () => {Navigator.of(context).pop()},
          ),
        ),
      drawer: const GuardSidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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