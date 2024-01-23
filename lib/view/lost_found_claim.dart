import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class LostFoundClaim extends StatefulWidget {
  const LostFoundClaim({super.key, required this.id, required this.uid});
  final int id;
  final int uid;
  @override
  State<LostFoundClaim> createState() => _LostFoundClaimState();
}

class _LostFoundClaimState extends State<LostFoundClaim> {
  var bottomIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final UserNotification userNotification = UserNotification();
  File? imageFile;
  final iconList = <IconData>[
    EvaIcons.home,
    FontAwesome.file,
    FontAwesome.book_atlas_solid,
    FontAwesome.searchengin_brand
  ];

  Future<void> chooseImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    image != null
        ? setState(() {
            imageFile = File(image.path);
          })
        : null;
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
    getUserID();
    super.initState();
  }

  @override
  void dispose() {
    userNotification.closeStream();
    super.dispose();
  }

  final iconNames = ["Home", "Report", "Bulletin Board", "Lost & Found"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Sidebar(),
        backgroundColor: const Color.fromARGB(255, 228, 232, 236),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 15),
                        child: const Text("RECENT POST",
                            style: TextStyle(
                                color: ColorTheme.secondaryColor,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 25))),
                  ],
                ),
                const SizedBox(height: 30),
                FutureBuilder<List<ClaimModel>>(
                  future: getLostFoundData(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        // scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final dataList = snapshot.data![index];
                          return Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                              255, 228, 232, 236)
                                          .withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: ImageNetwork(
                                            image: ImagesAPI.getImagesUrl(
                                                dataList.image.toString()),
                                            height: 300,
                                            width: 300,
                                            onPointer: true,
                                            debugPrint: false,
                                            fullScreen: false,
                                            fitAndroidIos: BoxFit.cover,
                                            fitWeb: BoxFitWeb.cover,
                                            onLoading:
                                                const CircularProgressIndicator(color: ColorTheme.primaryColor,),
                                          )),
                                      Divider(
                                        color: const Color.fromRGBO(
                                                143, 143, 156, 1)
                                            .withOpacity(0.1),
                                        thickness: 2,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            const Text("Lost of Item/Pet: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5,
                                                    wordSpacing: 0.5)),
                                            Text(dataList.lostItem.toString(),
                                                style: const TextStyle(
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 16,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: const Color.fromRGBO(
                                                143, 143, 156, 1)
                                            .withOpacity(0.1),
                                        thickness: 2,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            const Text("Date of Lost: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5,
                                                    wordSpacing: 0.5)),
                                            Text(dataList.dateOfLost.toString(),
                                                style: const TextStyle(
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 16,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: const Color.fromRGBO(
                                                143, 143, 156, 1)
                                            .withOpacity(0.1),
                                        thickness: 2,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Detail Description: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5,
                                                    wordSpacing: 0.5)),
                                            Expanded(
                                              child: ReadMoreText(
                                                dataList.detailDescription
                                                    .toString(),
                                                trimLines: 2,
                                                colorClickableText: Colors.pink,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'Show more',
                                                trimExpandedText: 'Show less',
                                                moreStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                lessStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.zero,
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        transformAlignment: Alignment.topRight,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        decoration: const BoxDecoration(
                                            color:
                                                ColorTheme.primaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 158, 161, 165),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                                offset: Offset(0, 3),
                                              )
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: TextButton(
                                          onPressed: () {
                                            Claim.updateClaimStatus(
                                                widget.id, imageFile, context);
                                          },
                                          child: const Text("Claiming",
                                              style: TextStyle(
                                                  color: ColorTheme.accentColor,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text("PROOF OF OWNERSHIP",
                        style: TextStyle(
                            color: Color.fromRGBO(26, 23, 44, 1),
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 25))),
                const SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                        Center(
                          child: imageFile != null
                              ? Container(
                                  width: 350,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              File(imageFile!.path)))))
                              : Container(
                                  width: 350,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/blank.jpg")))),
                        )
                      ],
                    )),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorTheme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 158, 161, 165),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              )
                            ]),
                        child: TextButton(
                          onPressed: () => chooseImage(),
                          child: const Text("Upload File",
                              style: TextStyle(
                                  color: ColorTheme.accentColor,
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: ColorTheme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 158, 161, 165),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              )
                            ]),
                        child: TextButton(
                          onPressed: () => Claim.insertClaimData(
                              imageFile, widget.id, widget.uid, context),
                          child: const Text("Submit",
                              style: TextStyle(
                                  color: ColorTheme.accentColor,
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30)
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
}
