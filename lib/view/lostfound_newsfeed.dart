import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/view/lost_found_claim.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/claim_controller.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/lost_found_comment.dart';
import 'package:capstone_project/view/map_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:appinio_video_player/appinio_video_player.dart';

class LostFoundNewsFeed extends StatefulWidget {
  const LostFoundNewsFeed({super.key});

  @override
  State<LostFoundNewsFeed> createState() => _LostFoundNewsFeedState();
}

class _LostFoundNewsFeedState extends State<LostFoundNewsFeed> {
  final UserNotification userNotification = UserNotification();
  final ClaimController claimController = ClaimController();

  final StreamController<List<UserLostFound>> readingStreamController =
      StreamController<List<UserLostFound>>();

  Future<void> closeStream() => readingStreamController.close();
  final LostFound lostFound = LostFound();

  List<String> dropdownItems = ["Image", "Video"];
  String? dropdownValue;

  void fetchLostFound() async {
    // List<UserLostFound> data = [];

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final response = await http.get(Uri.parse(API.displayUserLostFoundAPI),
          headers: {"Accept": "application/json"});
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<UserLostFound> readings = jsonData.map<UserLostFound>((json) {
            return UserLostFound.fromJson(json);
          }).toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        // print(e.toString());
      }
    });
  }

  late CachedVideoPlayerController controller;
  late CustomVideoPlayerController customController;

  void fetchLostFoundVideo() {
    LostFound.fetchLostFoundVideo().then((value) {
      for (var result in value) {
        // if (result.type.toString() == "Video") {
        controller = CachedVideoPlayerController.network(Uri.parse(result.image).toString())..initialize()..addListener(() => setState((){}));
        customController = CustomVideoPlayerController(context: context, videoPlayerController: controller);
        // controller.setLooping(true);
        controller.pause();
      }
      // }
    });
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

  void fetchUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt("uid")!.toInt();
    claimController.fetchClaimData(id);
    // claimController.fetchClaim(id);
  }

  String? name;

  void getcurrentLoginName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name") ?? "";
  }

  @override
  void initState() {
    getcurrentLoginName();
    fetchUserID();
    getUserID();
    fetchLostFound();
    fetchLostFoundVideo();
    lostFound.fetchLostFoundVideo1();
    super.initState();
  }

  @override
  void dispose() {
    userNotification.closeStream();
    closeStream();
    super.dispose();
  }

  final commentController = TextEditingController();

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
                        Container(
                          margin: EdgeInsets.zero,
                          child: Stack(
                            children: [
                              IconButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) =>
                                        buildClaimNotifications(
                                            claimController, context)),
                                icon: const Icon(
                                    LineAwesome.search_location_solid,
                                    color: ColorTheme.primaryColor),
                              ),
                              StreamBuilder(
                                stream: claimController
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
                const SizedBox(height: 10),
                StreamBuilder<List<UserLostFound>>(
                  stream: readingStreamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                          child:
                              Text("No data", style: TextStyle(fontSize: 30)));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        // scrollDirection: Axis.vertical,
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
                                    child: const Icon(EvaIcons.person_outline,
                                        size: 45,
                                        color: ColorTheme.secondaryColor),
                                  ),
                                  data.postStatus.toString() == "Default"
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                        color: Color.fromRGBO(
                                                            26, 23, 44, 1),
                                                        letterSpacing: 0.3,
                                                        wordSpacing: 0.5,
                                                        fontSize: 16)),
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                            ],
                                          ))
                                ],
                              ),
                              // const SizedBox(height: 70),
                              Container(
                                  width: MediaQuery.of(context).size.width,
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
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: const Offset(0, 3))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      // Text(data.lostItem.toString(),
                                      //     style: const TextStyle(
                                      //         fontSize: 16,
                                      //         letterSpacing: 1.5,
                                      //         wordSpacing: 0.5,
                                      //         fontWeight: FontWeight.bold)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: const Text("See comment",
                                                style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  color: Colors.black87
                                                )),
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .push(PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        LostFoundCommentPage(
                                                            lfid: data.id,
                                                            uid: data.uid),
                                                    transitionDuration:
                                                        Duration.zero,
                                                    reverseTransitionDuration:
                                                        Duration.zero)),
                                          ),
                                          IconButton(
                                              onPressed: () =>
                                                  lostFound.deleteLostFound(
                                                      data.id, context),
                                              icon: const Icon(EvaIcons.trash,
                                                  size: 25,
                                                  color: ColorTheme.secondaryColor)),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(),
                                          imageUrl: ImagesAPI.getImagesUrl(
                                              data.image.toString()),
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
                                      Divider(
                                        color: const Color.fromRGBO(
                                                143, 143, 156, 1)
                                            .withOpacity(0.1),
                                        thickness: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              controller: commentController,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(
                                                      IonIcons.chatbox,
                                                      color: ColorTheme.secondaryColor),
                                                  suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      LostFoundCommentController
                                                          .insertLostFoundComment(
                                                              commentController
                                                                  .text,
                                                              data.id,
                                                              pref
                                                                  .getInt(
                                                                      "uid")!
                                                                  .toInt());
                                                      commentController.clear();
                                                    },
                                                    icon: const Icon(Icons.send,
                                                        color: ColorTheme.secondaryColor),
                                                  ),
                                                  hintText: "...",
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          LostFoundClaim(
                                                            id: data.id,
                                                            uid: data.uid,
                                                          ),
                                                      transitionDuration:
                                                          Duration.zero,
                                                      reverseTransitionDuration:
                                                          Duration.zero));
                                            },
                                            child: const Text("Claim",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        26, 23, 44, 1),
                                                    fontSize: 16,
                                                    letterSpacing: 1.5,
                                                    wordSpacing: 0.3,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                StreamBuilder<List<UserLostFoundVideo>>(
                  stream: lostFound.readingStreamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Video data",
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          // scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];

                            return SizedBox(
                              // height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        margin: const EdgeInsets.only(left: 5),
                                        child: const Icon(
                                            EvaIcons.person_outline,
                                            size: 45,
                                            color: Color.fromRGBO(
                                                123, 97, 255, 1)),
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
                                                ],
                                              ))
                                    ],
                                  ),
                                  Center(
                                    child: controller.value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio:
                                                controller.value.aspectRatio,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 15),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 228, 232, 236)
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset:
                                                            const Offset(0, 3))
                                                  ]),
                                              child: Column(
                                                // height: 300,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          lostFound
                                                              .deleteLostFound(
                                                                  data.id,
                                                                  context);
                                                        },
                                                        icon: const Icon(
                                                            EvaIcons.trash,
                                                            size: 25,
                                                            color:
                                                                Color.fromRGBO(
                                                                    123,
                                                                    97,
                                                                    255,
                                                                    1))),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: CustomVideoPlayer(customVideoPlayerController: customController))
                                                ],
                                              ),
                                            ))
                                        : const SizedBox.shrink(),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30)
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

          
            // ignore: unnecessary_null_comparison
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
                  if (index == 0) currentScreen = ScreenNames.home;
                  Navigator.of(context).popAndPushNamed(RouteName.home);
                  break;
                case 1:
                  if (index == 1) currentScreen = ScreenNames.report;
                  Navigator.of(context).popAndPushNamed(RouteName.emergency);
                  break;
                case 2:
                  if (index == 2) currentScreen = ScreenNames.bulletin;
                  Navigator.of(context)
                      .popAndPushNamed(RouteName.bulletinBoard);
                  break;
                case 3:
                  if (index == 3) currentScreen = ScreenNames.lostfound;
                  Navigator.of(context)
                      .popAndPushNamed(RouteName.lostFoundNews);
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