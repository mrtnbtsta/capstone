import 'package:capstone_project/view/login.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
var currentEnum = GuardSidebarEnum.logout;

class GuardSidebar extends StatefulWidget {
  const GuardSidebar({super.key});

  @override
  State<GuardSidebar> createState() => _GuardSidebarState();
}

class _GuardSidebarState extends State<GuardSidebar> {
  void removeUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("guardUser");
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
              const SizedBox(height: 10),
              listTileContents(Iconsax.logout_bold, "Logout", context,
                  currentEnum == GuardSidebarEnum.logout ? true : false, 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RouteName.summaryGuardReport),
                      child: const Text("Summary Report", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 16, letterSpacing: 1.5, wordSpacing: 0.5)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listTileContents(IconData leadingIcon, String text,
          BuildContext context, bool selected, int pageIndex) =>
      Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            color: selected ? Colors.transparent : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          onTap: () {
            setState(() {
              switch (pageIndex) {
                case 0:
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
              color:  ColorTheme.secondaryColor, size: 20),
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

enum GuardSidebarEnum { logout }
