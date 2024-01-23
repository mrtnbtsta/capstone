import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/map_function.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmergencyContact extends StatefulWidget {
  const EmergencyContact({ super.key });

  @override
  EmergencyContactState createState() => EmergencyContactState();
}

class EmergencyContactState extends State<EmergencyContact> {

  final UserNotification userNotification = UserNotification();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
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
              const SizedBox(height: 20,),
              const Center(
                child: Text("Emergency Contact", 
                style: TextStyle(color: ColorTheme.secondaryColor, 
                fontSize: 30, letterSpacing: 1.5, 
                wordSpacing: 0.5),),
              ),
              const SizedBox(height: 30,),
              buildContacts(image: "assets/images/police.png", title: "Mabalacat Police", firstNumber: "0998-698-5458", secondNumber: "0948-552-4384"),
              Divider(
                color: const Color.fromRGBO(143, 143, 156, 1)
                    .withOpacity(0.1),
                thickness: 2,
              ),
              buildContacts(image: "assets/images/cdrrmo.png", title: "Mabalacat CDRRMO", firstNumber: "0939 924 3166", secondNumber: ""),
              Divider(
                color: const Color.fromRGBO(143, 143, 156, 1)
                    .withOpacity(0.1),
                thickness: 2,
              ),
              buildContacts(image: "assets/images/fire_station.png", title: "Mabalacat Fire Station", firstNumber: "0933 990 9960", secondNumber: ""),

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
              // Future.delayed(const Duration(seconds: 1));
              // Navigator.of(context).pop();
            });
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
                  Navigator.of(context).pushNamed(RouteName.home);
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
  

  Widget buildContacts({required String image, required String title, required String firstNumber, required String secondNumber}) => ListTile(
    leading: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(image))
      ),
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 18)),
        Text(firstNumber, style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16)),
        Text(secondNumber, style: const TextStyle(color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5, fontSize: 16)),
      ],
    ),
  );

}