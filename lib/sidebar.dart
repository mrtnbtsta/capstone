import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/view/login.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/variables.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Future<void> removeName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("name");
    //when user logout set back currentIndex back to 0 to reset the index
    currentEnum = SidebarEnum.incidentReport;
    currentIndex = 0;
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
                Column(
                  // shrinkWrap: true,
                  children: [
                    listTileContents(
                        EvaIcons.file,
                        "EMERGENCY CONTACT",
                        context,
                        currentEnum == SidebarEnum.emergencyContact
                            ? true
                            : false,
                        0),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(
                        EvaIcons.file,
                        "INCIDENT REPORT",
                        context,
                        currentEnum == SidebarEnum.incidentReport
                            ? true
                            : false,
                        1),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(
                        FontAwesome.book_atlas_solid,
                        "BULLETIN BOARD",
                        context,
                        currentEnum == SidebarEnum.bulletinBoard ? true : false,
                        2),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(
                        HeroIcons.chat_bubble_bottom_center,
                        "DISCUSSION",
                        context,
                        currentEnum == SidebarEnum.discussion ? true : false,
                        3),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(
                        FontAwesome.searchengin_brand,
                        "LOST & FOUND",
                        context,
                        currentEnum == SidebarEnum.lostAndfound ? true : false,
                        4),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(EvaIcons.person, "PROFILE", context,
                        currentEnum == SidebarEnum.profile ? true : false, 5),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(EvaIcons.settings, "SETTINGS", context,
                        currentEnum == SidebarEnum.settings ? true : false, 6),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(
                        FontAwesome.circle_question,
                        "HELP & FAQs",
                        context,
                        currentEnum == SidebarEnum.faq ? true : false,
                        7),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    listTileContents(Icons.logout, "LOGOUT", context,
                        currentEnum == SidebarEnum.logout ? true : false, 8),
                    // Padding(
                    //   padding: const EdgeInsets.all(8),
                    //   child: Align(
                    //     alignment: FractionalOffset.bottomCenter,
                    //     child: TextButton(
                    //       onPressed: () => Navigator.of(context).pushNamed(RouteName.summaryUserReport),
                    //       child: const Text("Summary Report", style: TextStyle(color: ColorTheme.secondaryColor, fontSize: 16, letterSpacing: 1.5, wordSpacing: 0.5)),
                    //     ),
                    //   ),
                    // )
                  ],
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
                  currentEnum = SidebarEnum.emergencyContact;
                  Navigator.of(context).pushNamed(RouteName.emergencyContact);
                  break;
                case 1:
                  currentIndex = 1;
                  currentEnum = SidebarEnum.incidentReport;
                  Navigator.of(context).pushNamed(RouteName.emergency);
                  break;
                case 2:
                  currentIndex = 2;
                  currentEnum = SidebarEnum.bulletinBoard;
                  Navigator.of(context).pushNamed(
                    RouteName.bulletinBoard,
                  );
                  break;
                case 3:
                  currentEnum = SidebarEnum.discussion;
                  Navigator.of(context).pushNamed(
                    RouteName.discussion,
                  );
                  break;
                case 4:
                  currentEnum = SidebarEnum.lostAndfound;
                  Navigator.of(context).pushNamed(
                    RouteName.lostFoundPost,
                  );
                  break;
                case 5:
                  currentEnum = SidebarEnum.profile;
                  Navigator.of(context).pushNamed(RouteName.profile);
                  break;
                case 6:
                  currentEnum = SidebarEnum.settings;
                  Navigator.of(context).pushNamed(RouteName.settings);
                  break;
                case 7:
                  currentEnum = SidebarEnum.faq;
                  Navigator.of(context).pushNamed(RouteName.helpFaq);
                  break;
                case 8:
                  currentEnum = SidebarEnum.logout;
                  removeName();
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
