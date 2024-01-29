// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:capstone_project/theme/colors.dart';
class LostFoundPost extends StatefulWidget {
  const LostFoundPost({super.key});

  @override
  State<LostFoundPost> createState() => _LostFoundPostState();
}

class _LostFoundPostState extends State<LostFoundPost> {
  final UserNotification userNotification = UserNotification();
  var bottomIndex = 0;
  int? uid;
  final iconList = <IconData>[
    EvaIcons.home,
    FontAwesome.file,
    FontAwesome.book_atlas_solid,
    FontAwesome.searchengin_brand
  ];

  final picker = ImagePicker();
  File? attachFile;
  File? attachVideo;
  dynamic type;

  Future<void> uploadImage() async {
    var photo = await picker.pickImage(source: ImageSource.gallery);

    //if there is an image set the image to the imageFIle
    if(photo != null){
      setState(() =>  attachFile = File(photo.path));
    }
  }

  Future<void> uploadVideo() async {
    var photo = await picker.pickVideo(source: ImageSource.gallery);

    //if there is an image set the image to the imageFIle
    if(photo != null){
      setState(() =>  attachVideo = File(photo.path));
    }
  }

  Future<void> getCurrentUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getInt("uid");
  }

  final lostItemController = TextEditingController();
  final dateOfLostController = TextEditingController();
  final detailDescriptionController = TextEditingController();

  void setDate() {
    var currentDate =
        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
    dateOfLostController.text = currentDate.toString();
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
    getCurrentUserID();
    getUserID();
    setDate();
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      transformAlignment: Alignment.topRight,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: const BoxDecoration(
                          color: ColorTheme.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 158, 161, 165),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 3),
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextButton(
                        onPressed: () async {
                          ArtDialogResponse response = await ArtSweetAlert.show(
                              barrierDismissible: false,
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                  confirmButtonColor:
                                      ColorTheme.primaryColor,
                                  denyButtonColor:
                                      ColorTheme.secondaryColor,
                                  denyButtonText: "User",
                                  title: "Lost Found",
                                  showCancelBtn: true,
                                  text: "POST AS",
                                  confirmButtonText: "Anonymous",
                                  type: ArtSweetAlertType.question));

                          // ignore: unnecessary_null_comparison
                          if (response == null) {
                            return;
                          }

                          if (response.isTapConfirmButton) {
                            LostFoundController.insertLostFoundImageData(
                                    lostItemController.text,
                                    dateOfLostController.text,
                                    detailDescriptionController.text,
                                    type.toString() == "Image"
                                        ? attachFile
                                        : attachVideo,
                                    uid!,
                                    type,
                                    "Anonymous",
                                    context)
                                .whenComplete(() {
                              attachFile = null;
                            });

                            // Navigator.of(context).pop();
                            return;
                          }

                          if (response.isTapDenyButton) {
                            LostFoundController.insertLostFoundImageData(
                                    lostItemController.text,
                                    dateOfLostController.text,
                                    detailDescriptionController.text,
                                    type.toString() == "Image"
                                        ? attachFile
                                        : attachVideo,
                                    uid!,
                                    type,
                                    "Default",
                                    context)
                                .whenComplete(() {
                              attachFile = null;
                            });
                          }
                        },
                        child: const Text("Post",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: lostItemController,
                    decoration: const InputDecoration(
                      hintText: "Lost Item/Pet: ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: dateOfLostController,
                    decoration: const InputDecoration(
                        hintText: "Date of Lost: ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: detailDescriptionController,
                    decoration: const InputDecoration(
                        hintText: "Detail Description: ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        )),
                  ),
                ),

                //PHOTO
                const SizedBox(height: 25),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 232, 236),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3))
                      ]),
                  child: attachFile != null
                      ? Container(
                          width: 500,
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(attachFile!.path)))))
                      : Container(
                          width: 500,
                          height: 200,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/error_image.png")))),
                ),

                //BUTTONS
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: kIsWeb
                            ? const EdgeInsets.all(8)
                            : const EdgeInsets.all(4),
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
                            onPressed: () {
                              setState(() {
                                type = "Image";
                                print('Type: $type');
                              });
                              uploadImage();
                            },
                            child: const Text("Upload Image",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: kIsWeb
                            ? const EdgeInsets.all(8)
                            : const EdgeInsets.all(4),
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
                            onPressed: () {
                              setState(() {
                                type = "Video";
                                print('Type: $type');
                              });
                              uploadVideo();
                            },
                            child: const Text("Upload Video",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     padding: kIsWeb
                    //         ? const EdgeInsets.all(8)
                    //         : const EdgeInsets.all(4),
                    //     margin: const EdgeInsets.all(8),
                    //     decoration: const BoxDecoration(
                    //         color: Color.fromRGBO(123, 97, 255, 1),
                    //         borderRadius: BorderRadius.all(Radius.circular(5)),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Color.fromARGB(255, 158, 161, 165),
                    //             blurRadius: 10,
                    //             spreadRadius: 1,
                    //             offset: Offset(0, 3),
                    //           )
                    //         ]),
                    //     child: TextButton(
                    //         onPressed: () => {},
                    //         child: const Text("Cancel",
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 letterSpacing: 1.5,
                    //                 wordSpacing: 0.5,
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold))),
                    //   ),
                    // )
                  ],
                ),
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
