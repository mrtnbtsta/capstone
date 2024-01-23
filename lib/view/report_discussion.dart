import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/comment_controller.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/report_model.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';

class ReportDiscussion extends StatefulWidget {
  const ReportDiscussion(
      {super.key, required this.id, required this.rdid, required this.uid});
  final int id;
  final int rdid;
  final int uid;

  @override
  State<ReportDiscussion> createState() => _ReportDiscussionState();
}

class _ReportDiscussionState extends State<ReportDiscussion> {
  bool showCommentField = false;
  int commentIndex = -1;
  final commentController = Get.put(CommentController());
  final UserNotification userNotification = UserNotification();
  ReportStreamController reportStreamController = ReportStreamController();

  List<ReportDiscussionModel> dataReport = <ReportDiscussionModel>[];

  final contentController = TextEditingController();
  bool hideAllComments = true;

  String? name;

  void getcurrentLoginName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name") ?? "";
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
    getcurrentLoginName();
    reportStreamController
        .reportDiscussionCard(widget.id)
        .then((value) => setState(() => dataReport.addAll(value)));

    reportStreamController.displayReportCommentData(widget.id);
    getUserID();
    super.initState();
  }

  @override
  void dispose() {
    userNotification.closeStream();
    reportStreamController.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: const Sidebar(),
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Platform.isAndroid
                          ? const Icon(EvaIcons.arrow_back,
                              color: ColorTheme.primaryColor)
                          : const Icon(CupertinoIcons.arrow_left,
                              color: ColorTheme.primaryColor),
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
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: const Text("Report Discussion",
                      style: TextStyle(
                          color: ColorTheme.secondaryColor,
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                //DISCUSSION CARD

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: dataReport.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var data = dataReport[index];
                        // print("Dicussion => ${data.id}");

                        return Container(
                          width: MediaQuery.of(context).size.width / 4,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 228, 232, 236),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  color: Color.fromARGB(255, 200, 203, 206),
                                )
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: "Posted by: ",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87),
                                                children: [
                                              TextSpan(
                                                  text: data.postStatus
                                                              .toString() ==
                                                          "Anonymous"
                                                      ? "Anonymous User"
                                                      : data.name.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal))
                                            ])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: const Color.fromRGBO(143, 143, 156, 1)
                                    .withOpacity(0.1),
                                thickness: 2,
                              ),
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      shape: BoxShape.rectangle),
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.zero,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(),
                                    imageUrl: ImagesAPI.getImagesUrl(
                                        data.image.toString()),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                      );
                                    },
                                  )),
                              Divider(
                                color: const Color.fromRGBO(143, 143, 156, 1)
                                    .withOpacity(0.1),
                                thickness: 2,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      commentIndex = index;
                                      showCommentField = !showCommentField;
                                    });
                                  },
                                  icon: const Icon(IonIcons.chatbox,
                                      color: ColorTheme.secondaryColor),
                                  label: const Text("Comment",
                                      style: TextStyle(
                                          color: Color.fromRGBO(26, 23, 44, 1),
                                          letterSpacing: 1.5,
                                          wordSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                              Divider(
                                color: const Color.fromRGBO(143, 143, 156, 1)
                                    .withOpacity(0.1),
                                thickness: 2,
                              ),
                              commentIndex == index && showCommentField
                                  ? TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: contentController,
                                      decoration: InputDecoration(
                                          hintText: "Write a comment...",
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();

                                              int uid =
                                                  pref.getInt("uid")!.toInt();
                                              reportStreamController
                                                  .insertReportComment(
                                                      contentController.text,
                                                      widget.id,
                                                      uid);

                                              contentController.clear();
                                            },
                                            icon: const Icon(
                                                FontAwesome
                                                    .arrow_right_long_solid,
                                                color: ColorTheme.secondaryColor),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    )
                                  : const SizedBox.shrink(),
                              Divider(
                                color: const Color.fromRGBO(143, 143, 156, 1)
                                    .withOpacity(0.1),
                                thickness: 2,
                              ),
                              const SizedBox(height: 20),

                              //HERE IS THE COMMENT SECTION

                              hideAllComments
                                  ? StreamBuilder<List<ReportCommentModel>>(
                                      stream: reportStreamController
                                          .readingStreamController.stream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                                          );
                                        } else if (snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text("No comment...",
                                                style: TextStyle(fontSize: 30)),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final comment =
                                                  snapshot.data![index];
                                              return Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      comment.image.toString() == "default"
                                                          ? Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/images/default_profile.jpg"),
                                                                      fit: BoxFit.cover)),
                                                            )
                                                          : CachedNetworkImage(
                                                        placeholder: (context, url) =>
                                                            Container(),
                                                        imageUrl:
                                                            ImagesAPI.getProfileUrl(
                                                                comment.image
                                                                    .toString()),
                                                        imageBuilder:
                                                            (context, imageProvider) {
                                                          return Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                                image:
                                                                    DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.cover,
                                                            )),
                                                          );
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          decoration: const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      219,
                                                                      219,
                                                                      238,
                                                                      1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  comment.name.toString() ==
                                                                          name
                                                                              .toString()
                                                                      ? "You"
                                                                      : comment.name
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              26,
                                                                              23,
                                                                              44,
                                                                              1),
                                                                      letterSpacing:
                                                                          1.5,
                                                                      wordSpacing:
                                                                          0.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14)),
                                                              ReadMoreText(
                                                                comment.comment
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? comment
                                                                        .comment
                                                                        .toString()
                                                                    : "",
                                                                trimLines: 2,
                                                                colorClickableText:
                                                                    Colors.pink,
                                                                trimMode:
                                                                    TrimMode
                                                                        .Line,
                                                                trimCollapsedText:
                                                                    'Show more',
                                                                trimExpandedText:
                                                                    'Show less',
                                                                moreStyle: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                lessStyle: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              Container(
                                alignment: Alignment.center,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        hideAllComments = !hideAllComments;
                                      });
                                    },
                                    child: Text(hideAllComments
                                        ? "Hide all comments..."
                                        : "Show all comments...", style: const TextStyle(color: ColorTheme.secondaryColor),)),
                              ),
                            ],
                          ),
                        );
                      }),
                )

                //HERE

                // const SizedBox(height: 10),
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
