import 'package:capstone_project/admin/admin_variables.dart';
import 'package:capstone_project/view/login.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
var currentEnum = AdminSidebarEnum.emergency;

class AdminSidebar extends StatefulWidget {
  const AdminSidebar({super.key});

  @override
  State<AdminSidebar> createState() => _SidebarState();
}

class _SidebarState extends State<AdminSidebar> {
  void removeUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("username");
    currentIndex = 0;
    currentEnum = AdminSidebarEnum.emergency;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 350,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 90,
                        height: 90,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("XEV-CURITY",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  color: Color.fromRGBO(26, 23, 44, 1))),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 120,
                            child: const Text("SAFETY AND CONNECTION",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 1.5,
                                    color: Color.fromRGBO(26, 23, 44, 1))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: const EdgeInsets.only(left: 10),
                //   child: const Text("Reports",
                //       style: TextStyle(
                //           fontSize: 20,
                //           letterSpacing: 1.5,
                //           color: Color.fromRGBO(26, 23, 44, 1))),
                // ),
                const SizedBox(height: 10),
                listTileContents(
                    FontAwesome.kit_medical_solid,
                    "EMERGENCY REPORT",
                    context,
                    currentEnum == AdminSidebarEnum.emergency ? true : false,
                    0),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(EvaIcons.file, "EMERGENCY HAZARD", context,
                    currentEnum == AdminSidebarEnum.hazard ? true : false, 1),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(EvaIcons.file, "EMERGENCY CRIME", context,
                    currentEnum == AdminSidebarEnum.crime ? true : false, 2),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(
                    Iconsax.add_circle_bold,
                    "Add Discussion",
                    context,
                    currentEnum == AdminSidebarEnum.discussion ? true : false,
                    3),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(Iconsax.add_circle_bold, "Add Faq", context,
                    currentEnum == AdminSidebarEnum.faq ? true : false, 4),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(EvaIcons.message_circle, "Chat", context,
                    currentEnum == AdminSidebarEnum.chat ? true : false, 5),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(EvaIcons.person, "Accounts", context,
                    currentEnum == AdminSidebarEnum.account ? true : false, 6),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                listTileContents(Iconsax.logout_bold, "Logout", context,
                    currentEnum == AdminSidebarEnum.logout ? true : false, 7),
                Divider(
                  color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RouteName.summaryAdminReport),
                      child: const Text("Summary Report", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 16, letterSpacing: 1.5, wordSpacing: 0.5)),
                    ),
                  ),
                )
              ], 
            ),
          ),
        ),
      ),
    );
  }

  Widget listTileContents(IconData leadingIcon, String text,
          BuildContext context, bool selected, int pageIndex) =>
      Container(
        decoration: BoxDecoration(
            color: selected
                ? Colors.transparent
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          onTap: () {
            setState(() {
              switch (pageIndex) {
                case 0:
                  currentEnum = AdminSidebarEnum.emergency;
                  Navigator.of(context).pushNamed(RouteName.dashboardEmergency);
                  break;
                case 1:
                  currentEnum = AdminSidebarEnum.hazard;
                  Navigator.of(context).pushNamed(RouteName.dashboardHazard);
                  break;
                case 2:
                  currentEnum = AdminSidebarEnum.crime;
                  Navigator.of(context).pushNamed(RouteName.dashboardCrime);
                  break;
                case 3:
                  currentEnum = AdminSidebarEnum.discussion;
                  Navigator.of(context).pushNamed(RouteName.addDicussion);
                  break;
                case 4:
                  currentEnum = AdminSidebarEnum.faq;
                  Navigator.of(context).pushNamed(RouteName.addFaq);
                  break;
                case 5:
                  currentEnum = AdminSidebarEnum.chat;
                  Navigator.of(context).pushNamed(RouteName.userAdmin);
                  break;
                case 6:
                  currentEnum = AdminSidebarEnum.account;
                  Navigator.of(context).pushNamed(RouteName.accountPending);
                  break;
                case 7:
                  currentEnum = AdminSidebarEnum.logout;
                  removeUsername();
                  Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Login(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero),
                      (route) => false);
                  break;
              }
            });
          },
          leading: Icon(leadingIcon,
              color: ColorTheme.secondaryColor, size: 20),
          title: Text(text,
              style: const TextStyle(
                  color: Color.fromRGBO(26, 23, 44, 1),
                  letterSpacing: 1.5,
                  wordSpacing: 0.5,
                  fontSize: 15)),
          trailing: const SizedBox.shrink(),
        ),
      );
}

enum AdminSidebarEnum {
  emergency,
  hazard,
  crime,
  discussion,
  faq,
  chat,
  account,
  logout
}
