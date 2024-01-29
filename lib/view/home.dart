// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/report_model.dart';
import 'package:capstone_project/view/report_discussion.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/theme/colors.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  List<EmergencyReportsModel> allReports = [];
  // List<HazardReportsModel> dataHazard = [];
  // List<CrimeReportsModel> dataCrime = [];
  final AlertController alertController = Get.put(AlertController());
  final UserNotification userNotification = UserNotification();
  IncidentController incidentController = IncidentController();
  // int? uid;
  Future<void> getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int uid = pref.getInt("uid") ?? 0;

    GuardUserAPI.displayGuardUserData().then((value) {
      for (var id in value) {
        userNotification.getUserNotifactionData(id.gid!.toInt(), uid);
      }
    });
  }

  String? name;

  void getcurrentLoginName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name") ?? "";
  }

  // deleteEmergencyData

  void deleteReportData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteEmergencyData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["result"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(
            child: Text("Successfully deleted"),
          )));
        }
      }
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    getcurrentLoginName();
    MapFunctions.getUserLocation();
    incidentController.allReportsData();
    getUserID();
    super.initState();
  }

  @override
  void dispose() {
    incidentController.closeStream();
    userNotification.closeStream();
    super.dispose();
  }

  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Sidebar(),
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed("user"),
                              icon: const Icon(EvaIcons.message_circle,
                                  color: ColorTheme.primaryColor),
                            ),
                            Container(
                              margin: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  IconButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            buildUserNotifications(
                                                userNotification, context)),
                                    icon: const Icon(EvaIcons.bell,
                                        color: ColorTheme.primaryColor),
                                  ),
                                  StreamBuilder(
                                    stream: userNotification
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
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),

                    //spacing
                    const SizedBox(height: 40),
                    //1ST CARD
                    StreamBuilder<List<EmergencyReportsModel>>(
                      stream: incidentController.readingStreamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                          );
                        } else if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No data",
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        data.postStatus.toString() == "Default"
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(left: 5),
                                        child: const Icon(
                                            EvaIcons.person_outline,
                                            size: 45,
                                            color: ColorTheme.secondaryColor),
                                      ),
                                      data.postStatus.toString() == "Default"
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.name.toString(),
                                                      style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              26, 23, 44, 1),
                                                          letterSpacing: 1.5,
                                                          wordSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18)),
                                                  SizedBox(
                                                    width: 290,
                                                    child: Text(
                                                        data.address.toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    26,
                                                                    23,
                                                                    44,
                                                                    1),
                                                            letterSpacing: 0.3,
                                                            wordSpacing: 0.5,
                                                            fontSize: 16)),
                                                  ),
                                                ],
                                              ))
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              child: const Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Anonymous User",
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              26, 23, 44, 1),
                                                          letterSpacing: 1.5,
                                                          wordSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18)),
                                                  // SizedBox(
                                                  //   width: 300,
                                                  //   child: Text(
                                                  //       data.address.toString(),
                                                  //       style: const TextStyle(
                                                  //           color:
                                                  //               Color.fromRGBO(
                                                  //                   26,
                                                  //                   23,
                                                  //                   44,
                                                  //                   1),
                                                  //           letterSpacing: 0.3,
                                                  //           wordSpacing: 0.5,
                                                  //           fontSize: 16)),
                                                  // ),
                                                ],
                                              )),
                                    ],
                                  ),
                                  //CARD CONTENT
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      // height: MediaQuery.of(context).size.height / 4,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                                  255, 228, 232, 236)
                                              .withOpacity(0.7),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: const Offset(0, 3))
                                          ]),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                width: 150,
                                                height: 150,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  imageUrl:
                                                      ImagesAPI.getImagesUrl(
                                                          data.image
                                                              .toString()),
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              DecorationImage(
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "Type of Report: ",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
                                                            children: [
                                                          TextSpan(
                                                              text: data
                                                                  .typeOfReport
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 16))
                                                        ])),
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "Location Incident: ",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
                                                            children: [
                                                          TextSpan(
                                                              text: data
                                                                  .locationIncident
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal))
                                                        ])),
                                                    RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "Describe Incident: ",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
                                                            children: [
                                                          TextSpan(
                                                              text: data
                                                                  .describeIncident
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal))
                                                        ])),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: const Color.fromRGBO(
                                                    143, 143, 156, 1)
                                                .withOpacity(0.1),
                                            thickness: 2,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) =>
                                                                ReportDiscussion(
                                                                    id: data
                                                                        .rid,
                                                                    rdid: data
                                                                        .rdid,
                                                                    uid: data
                                                                        .uid),
                                                            transitionDuration:
                                                                Duration.zero,
                                                            reverseTransitionDuration:
                                                                Duration.zero));
                                                  },
                                                  icon: const Icon(
                                                      EvaIcons.email,
                                                      size: 25,
                                                      color: ColorTheme.secondaryColor),
                                                  label: const Text(
                                                      "Discussions...",
                                                      style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        wordSpacing: 0.5,
                                                        fontSize: 16,
                                                        color: ColorTheme.secondaryColor
                                                      )),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (data.name.toString() ==
                                                        name.toString()) {
                                                      deleteReportData(
                                                          data.rid);
                                                    } else {
                                                      ArtSweetAlert.show(
                                                          context: context,
                                                          artDialogArgs: ArtDialogArgs(
                                                              type:
                                                                  ArtSweetAlertType
                                                                      .warning,
                                                              title: "Oops...",
                                                              text:
                                                                  "Sorry this is not your post, you cannot delete it"));
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      EvaIcons.trash,
                                                      size: 25,
                                                      color: ColorTheme.secondaryColor)),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  ])),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 228, 232, 236),
          shape: const CircleBorder(),
          isExtended: true,
          onPressed: () async {
            ArtDialogResponse response =
                await ArtSweetAlert.show(
                    barrierDismissible: false,
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        confirmButtonColor:
                            ColorTheme.primaryColor,
                        title: "Alert",
                        showCancelBtn: true,
                        text: "Send an alert",
                        confirmButtonText: "Confirm",
                        type:
                            ArtSweetAlertType.question));

          
            if (response == null) {
              return;
            }

            if (response.isTapConfirmButton) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                   UserController.insertAlert(
                    pref.getInt("uid"),
                    MapFunctions.currentPosition!.latitude,
                    MapFunctions.currentPosition!.longitude)
                    .then((value) {
                    ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "Success",
                      text: "Successfully sent the alert"));
                  });
                
            }
          },
          child: const Icon(EvaIcons.alert_triangle,
              color: ColorTheme.primaryColor),
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
                  currentScreen = ScreenNames.home;
                  // Navigator.of(context).pushNamed('/');
                  break;
                case 1:
                  currentScreen = ScreenNames.report;
                  Navigator.of(context).pushNamed(RouteName.emergency);
                  break;
                case 2:
                  currentScreen = ScreenNames.bulletin;
                  Navigator.of(context).pushNamed(RouteName.bulletinBoard);
                  break;
                case 3:
                  currentScreen = ScreenNames.lostfound;
                  Navigator.of(context).pushNamed(RouteName.lostFoundNews);
                  break;
              }

              // print(currentScreen);
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
