// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/bulletin_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'map_function.dart';
import 'package:capstone_project/controllers/bulletin_controller.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:capstone_project/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/theme/colors.dart';
class BulletinEvents extends StatefulWidget {
  const BulletinEvents({super.key});

  @override
  State<BulletinEvents> createState() => _BulletinEventsState();
}



class _BulletinEventsState extends State<BulletinEvents> {
  bool showCommentField = false;
  final newsController = PageController(initialPage: 0);
  final eventController = PageController(initialPage: 0);
  final userReportController = PageController(initialPage: 0);
  final UserNotification userNotification = UserNotification();
  List<AllReports> allReports = [];
  final Bulletin bulletin = Bulletin();

  void deleteBulletinData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteBulletinData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          // ignore: use_build_context_synchronously
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully deleted"));
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int uid = pref.getInt("uid") ?? 0;

    GuardUserAPI.displayGuardUserData().then((value) {
      for (var id in value) {
        userNotification.getUserNotifactionData(id.gid!.toInt(), uid);
      }
    });
  }

  @override
  void initState() {
    bulletin.fetchAllReports();
    getUserID();
    super.initState();
  }

  @override
  void dispose() {
    userNotification.closeStream();
    bulletin.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconNames = ["Home", "Report", "Bulletin Board", "Lost & Found"];
    return Scaffold(
        drawer: const Sidebar(),
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) => buildUserNotifications(
                                    userNotification, context)),
                            icon: const Icon(EvaIcons.bell,
                                color: ColorTheme.primaryColor),
                          ),
                          StreamBuilder(
                            stream:
                                userNotification.readingStreamController.stream,
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                ),
                const SizedBox(height: 10),

                
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
                const SizedBox(height: 20),

                StreamBuilder<List<AllReports>>(
                  stream: bulletin.readiingStreamReports.stream,
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
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final dataNews = snapshot.data![index];

                          return SizedBox(
                            child: Card(
                              color: const Color.fromARGB(255, 228, 232, 236),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(dataNews.title.toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: ImagesAPI.getImagesUrl(
                                              dataNews.image.toString()),
                                          placeholder: (context, url) =>
                                              Container(),
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ReadMoreText(
                                            dataNews.description.toString(),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5,
                                            ),
                                            trimLines: 4,
                                            colorClickableText: Colors.pink,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'Show more',
                                            trimExpandedText: 'Show less',
                                            moreStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            lessStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                )

                //XEVERA NEWS
              ],
            ),
          ),
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
              final color = isActive
                  ? ColorTheme.secondaryColor
                  : ColorTheme.primaryColor;
              return Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Icon(
                    iconList[index],
                    size: 25,
                    color: color,
                  ),
                  Text(iconNames[index],
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: color, fontSize: 11))
                ],
              );
            },
            onTap: (int index) {
              setState(() => currentIndex = index);
              switch (index) {
                case 0:
                  if (index == 0) currentScreen = ScreenNames.home;
                  Navigator.of(context).pushNamed(RouteName.home);
                  break;
                case 1:
                  if (index == 1) currentScreen = ScreenNames.report;
                  Navigator.of(context).pushNamed(RouteName.emergency);
                  break;
                case 2:
                  if (index == 2) currentScreen = ScreenNames.bulletin;
                  Navigator.of(context).pushNamed(RouteName.bulletinBoard);
                  break;
                case 3:
                  if (index == 3) currentScreen = ScreenNames.lostfound;
                  Navigator.of(context).pushNamed(RouteName.lostFoundNews);
                  break;
              }
            },
            shadow: const BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 2,
              color: Color.fromARGB(255, 200, 203, 206),
            ),
            activeIndex: currentIndex,
            leftCornerRadius: 5,
            rightCornerRadius: 5,
            backgroundColor: const Color.fromARGB(255, 228, 232, 236),
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.defaultEdge));
  }

  Widget buildTextButton(bool isSelected, int index, String text) => InkWell(
    onTap: () {
      setState((){
        switch(index){
          case 0:
          // currentEnumButton = ButtonEnum.bulletinBoard;
          //  Navigator.of(context).pushNamed(
          //     RouteName.bulletinBoard,
          // );
          break;
          case 1:
          currentEnumButton = ButtonEnum.resolvedReport;
           Navigator.of(context).pushNamed(
              RouteName.actionedUser,
          );
          break;
          case 2:
          currentEnumButton = ButtonEnum.summaryReport;
           Navigator.of(context).pushNamed(
              RouteName.summaryUserReport,
          );
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


