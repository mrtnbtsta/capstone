import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'admin_variables.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:get/get.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/theme/colors.dart';
class DashboardHazard extends StatefulWidget {
  const DashboardHazard({super.key});

  @override
  DashboardHazardState createState() => DashboardHazardState();
}

class DashboardHazardState extends State<DashboardHazard> {
  final Hazard hazard =
      Hazard();
  final Incident incidentController = Incident();
  final AlertController alertController = AlertController();

  @override
  void initState() {
    hazard.fetchHazardData();
    alertController.fetchAlertdata();
     incidentController.getIncidentData();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete();
    incidentController.closeStream();
    hazard.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        drawer: const AdminSidebar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
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
                    const Text("Hazard",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
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
                    )
                  ],
                ),

                const SizedBox(height: 30),

                // reportWidget()
                StreamBuilder(
                  stream: hazard.readingStreamController.stream,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return const Center(child: CircularProgressIndicator(color: ColorTheme.primaryColor,),);
                    }else if(snapshot.data!.isEmpty){
                      return const Center(child: Text("No data", style: TextStyle(fontSize: 40),),);
                    }else{
                      return ListView.builder(
          itemCount: snapshot.data!.length,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = snapshot.data![index];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.only(left: 5),
                      child: const Icon(EvaIcons.person_outline,
                          size: 45, color: Color.fromRGBO(123, 97, 255, 1)),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name.toString(),
                              style: const TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            SizedBox(
                              width: 290,
                              child: Text(
                                data.address.toString(),
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.3,
                                    wordSpacing: 0.5,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                //CARD CONTENT
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 232, 236)
                            .withOpacity(0.7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(),
                                imageUrl: ImagesAPI.getImagesUrl(
                                    data.image.toString()),
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Type of Report: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                          children: [
                                        TextSpan(
                                            text: data.typeOfReport.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16))
                                      ])),
                                  RichText(
                                      text: TextSpan(
                                          text: "Location Incident: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                          children: [
                                        TextSpan(
                                            text: data.locationIncident
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal))
                                      ])),
                                  RichText(
                                      text: TextSpan(
                                          text: "Describe Incident: ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                          children: [
                                        TextSpan(
                                            text: data.describeIncident
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal))
                                      ])),
                                  // ReadMoreText(
                                  //    "${data.locationIncident.toString()}, ${data.describeIncident}",
                                  //   trimLines: 6,
                                  //   colorClickableText: Colors.pink,
                                  //   trimMode: TrimMode.Line,
                                  //   trimCollapsedText: 'Show more',
                                  //   trimExpandedText: 'Show less',
                                  //   moreStyle: const TextStyle(
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.bold),
                                  //   lessStyle: const TextStyle(
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: const Color.fromRGBO(143, 143, 156, 1)
                              .withOpacity(0.1),
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => hazard
                                    .updateHazardData(data.rid),
                                icon: const Icon(Icons.move_up,
                                    size: 25,
                                    color: Color.fromRGBO(123, 97, 255, 1)),
                                label: const Text("Move to post",
                                    style: TextStyle(
                                      letterSpacing: 1.5,
                                      wordSpacing: 0.5,
                                      fontSize: 16,
                                    )),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () async {
                                    ArtDialogResponse response =
                                        await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                                denyButtonText: "Cancel",
                                                title: "Are you sure?",
                                                text:
                                                    "You won't be able to revert this!",
                                                confirmButtonText:
                                                    "Yes, delete it",
                                                type:
                                                    ArtSweetAlertType.warning));

                                    // ignore: unnecessary_null_comparison
                                    if (response == null) {
                                      return;
                                    }

                                    if (response.isTapConfirmButton) {
                                      // ignore: use_build_context_synchronously
                                      hazard
                                          .deleteHazardReportData(data.rid);
                                      // setState(() {
                                      //   ReportAPI.deleteEmergencyReportData(
                                      //       _data.rid);
                                      // });
                                      // ArtSweetAlert.show(
                                      //     context: context,
                                      //     artDialogArgs: ArtDialogArgs(
                                      //       type: ArtSweetAlertType.success,
                                      //       title: "Deleted!",
                                      //       onConfirm: () {
                                      //         ReportAPI.deleteEmergencyReportData(
                                      //             _data.rid);
                                      //         setState(() {});
                                      //       },
                                      //     ));

                                      return;
                                    }
                                  },
                                  icon: const Icon(EvaIcons.trash,
                                      size: 25,
                                      color: Color.fromRGBO(123, 97, 255, 1))),
                            )
                          ],
                        )
                      ],
                    )),
                const SizedBox(height: 10),
                Divider(
                  color:
                      const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
                    }
                  },
                  )

                //spacing
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (index, isActive) {
              // var selected = isActive;
              final colorActive = isActive
                  ? ColorTheme.secondaryColor
                  : ColorTheme.primaryColor;
              return Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Icon(
                    iconList[index],
                    size: 25,
                    color: colorActive,
                  ),
                  Text(iconNames[index],
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: colorActive, fontSize: 11))
                ],
              );
            },
            onTap: (int index) {
              setState(() {
                currentIndex = index;
              });
              switch (index) {
                case 0:
                  currentAdminScreen = AdminScreenNames.home;
                  // Navigator.of(context).pushNamed('/dashboard-emergency');
                  break;
                case 1:
                  currentAdminScreen = AdminScreenNames.post;
                  Navigator.of(context).popAndPushNamed(RouteName.post);
                  break;
                case 2:
                  currentAdminScreen = AdminScreenNames.bulletin;
                  Navigator.of(context)
                      .popAndPushNamed(RouteName.dashboardBulletin);
                  break;
                case 3:
                  currentAdminScreen = AdminScreenNames.lostfound;
                  Navigator.of(context)
                      .popAndPushNamed(RouteName.dashboardLostfound);
                  break;
              }

              // print(currentAdminScreen);
            },
            shadow: const BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 2,
              color: Color.fromARGB(255, 228, 232, 236),
            ),
            activeIndex: currentIndex,
            leftCornerRadius: 5,
            rightCornerRadius: 5,
            backgroundColor: const Color.fromARGB(255, 228, 232, 236),
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.defaultEdge));
  }

}
