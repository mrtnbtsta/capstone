// ignore_for_file: use_build_context_synchronously
import 'package:capstone_project/theme/colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/controllers/comment_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/edit_profile.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> removeName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("name");
    //when user logout set back currentIndex back to 0 to reset the index
    setState(() {
      currentEnum = SidebarEnum.incidentReport;
      currentIndex = 0;
    });
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }

  var bottomIndex = 0;

  final iconList = <IconData>[
    EvaIcons.home,
    FontAwesome.file,
    FontAwesome.book_atlas_solid,
    FontAwesome.searchengin_brand
  ];

  final iconNames = ["Home", "Report", "Bulletin Board", "Lost & Found"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RouteName.home);
                          currentIndex = 0;
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ColorTheme.secondaryColor,
                        ),
                      ),
                      const Text("App Settings",
                          style: TextStyle(
                              color: ColorTheme.secondaryColor,
                              letterSpacing: 1.5,
                              wordSpacing: 0.1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 25),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Settings",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: 1.5,
                            wordSpacing: 0.1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromRGBO(219, 219, 238, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3))
                          ]),
                      child: listTileContents(EvaIcons.file_outline,
                          "Edit Profile", EvaIcons.chevron_right, 1),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromRGBO(219, 219, 238, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3))
                          ]),
                      child: listTileContents(EvaIcons.file_outline,
                          "Delete All Report", EvaIcons.chevron_right, 2),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromRGBO(219, 219, 238, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3))
                          ]),
                      child: listTileContents(EvaIcons.file_outline,
                          "Delete All Comment", EvaIcons.chevron_right, 3),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromRGBO(219, 219, 238, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3))
                          ]),
                      child: listTileContents(EvaIcons.file_outline,
                          "Delete Account", EvaIcons.chevron_right, 4),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
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

  Widget listTileContents(IconData leadingIcon, String text,
          IconData trailingIcon, int index) =>
      ListTile(
        onTap: () async {
            switch (index) {
              case 1:
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const EditProfile(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero));
                break;
              case 2:
                      SharedPreferences pref =
                    await SharedPreferences.getInstance();
                    int id = pref.getInt("uid")!.toInt();
                    deleteAllReports(id, context);
              case 3:
                      SharedPreferences pref =
                    await SharedPreferences.getInstance();
                    int id = pref.getInt("uid")!.toInt();
                    deleteAllComments(id, context);
              case 4:
                      SharedPreferences pref =
                    await SharedPreferences.getInstance();
                    int id = pref.getInt("uid")!.toInt();
                    UserAPI.updateUser(context, id);
                          // removeName();
            }
        },
        leading: Icon(leadingIcon,
            color: ColorTheme.primaryColor, size: 30),
        title: Text(text,
            style: const TextStyle(
                color: Color.fromRGBO(26, 23, 44, 1),
                letterSpacing: 1.5,
                wordSpacing: 0.5,
                fontSize: 20)),
        trailing: Icon(trailingIcon,
            color: ColorTheme.secondaryColor, size: 27),
      );
}
