import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/comment_controller.dart';
import 'package:capstone_project/controllers/discussion_controller.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/comment_model.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class Discussion extends StatefulWidget {
  const Discussion({super.key});

  @override
  State<Discussion> createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {
  bool showCommentField = false;
  final discussionController = Get.put(DiscussionController());
  final UserNotification userNotification = UserNotification();
  final commentController = Get.put(CommentController());

  final contentController = TextEditingController();
  int commentIndex = -1;
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
    discussionController.getDiscussion();
    getUserID();
    super.initState();
  }


  @override
  void dispose() {
    userNotification.closeStream();
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
                  child: const Text("Discussion",
                      style: TextStyle(
                          color: ColorTheme.secondaryColor,
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                //DISCUSSION CARD

                GetX<DiscussionController>(
                  builder: (controller) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: controller.dataModel.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var data = controller.dataModel[index];

                            var currentTime =
                                DateTime.now().millisecondsSinceEpoch ~/ 1000;

                            var diff = currentTime - data.time;
                            var second = diff;
                            var minutes = diff.round() / 60;
                            var hours = diff.round() / 3600;
                            var day = diff.round() / 86400;
                            var week = diff.round() / 604800;
                            var month = diff.round() / 2592000;
                            // var year = time.round() / 31104000;

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Text(data.name.toString(),
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          26, 23, 44, 1),
                                                      letterSpacing: 1.5,
                                                      wordSpacing: 0.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: Column(
                                                  children: [
                                                    if (second < 60) ...[
                                                      Text(
                                                          second < 1
                                                              ? "${second.toString()}sec"
                                                              : "${second.toString()}secs",
                                                          style:
                                                              const TextStyle(
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
                                                                  fontSize:
                                                                      12)),
                                                    ] else if (minutes
                                                            .toInt() <=
                                                        60) ...[
                                                      if (minutes.toInt() ==
                                                          1) ...[
                                                        Text(
                                                            "${minutes.toInt()}min",
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
                                                                fontSize: 12)),
                                                      ] else ...[
                                                        Text(
                                                            "${minutes.toInt()}mins",
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
                                                                fontSize: 12)),
                                                      ]
                                                    ] else if (hours.toInt() <=
                                                        24) ...[
                                                      if (hours.toInt() ==
                                                          1) ...[
                                                        Text(
                                                            "${hours.toInt()}hr",
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
                                                                fontSize: 12)),
                                                      ] else ...[
                                                        Text(
                                                            "${hours.toInt()}hrs",
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
                                                                fontSize: 12)),
                                                      ]
                                                    ] else if (day.toInt() <=
                                                        7) ...[
                                                      if (day.toInt() == 1) ...[
                                                        Text(
                                                            "${day.toInt()}day",
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
                                                                fontSize: 12)),
                                                      ] else ...[
                                                        Text(
                                                            "${day.toInt()}days",
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
                                                                fontSize: 12)),
                                                      ]
                                                    ] else if (week.toInt() <=
                                                            28 ||
                                                        week.toInt() <= 30 ||
                                                        week.toInt() <= 30) ...[
                                                      if (week.toInt() ==
                                                          1) ...[
                                                        Text(
                                                            "${week.toInt()}week",
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
                                                                fontSize: 12)),
                                                      ] else ...[
                                                        Text(
                                                            "${week.toInt()}weeks",
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
                                                                fontSize: 12)),
                                                      ]
                                                    ] else if (month.toInt() <=
                                                        31) ...[
                                                      if (month.toInt() ==
                                                          1) ...[
                                                        Text(
                                                            "${month.toInt()}month",
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
                                                                fontSize: 12)),
                                                      ] else ...[
                                                        Text(
                                                            "${month.toInt()}months",
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
                                                                fontSize: 12)),
                                                      ]
                                                    ]
                                                  ],
                                                )),
                                            Divider(
                                              color: const Color.fromRGBO(
                                                      143, 143, 156, 1)
                                                  .withOpacity(0.1),
                                              thickness: 2,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              alignment: Alignment.centerLeft,
                                              child: ReadMoreText(
                                                data.description.toString(),
                                                trimLines: 6,
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
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
                                            .withOpacity(0.1),
                                    thickness: 2,
                                  ),
                                  Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          shape: BoxShape.rectangle),
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Container(),
                                        imageUrl: ImagesAPI.getImagesUrl(
                                            data.image.toString()),
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
                                            .withOpacity(0.1),
                                    thickness: 2,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          commentIndex = index;
                                          // showCommentField = !showCommentField;
                                        });
                                      },
                                      icon: const Icon(IonIcons.chatbox,
                                          color:
                                              ColorTheme.secondaryColor),
                                      label: const Text("Comment",
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(26, 23, 44, 1),
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                  ),
                                  Divider(
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
                                            .withOpacity(0.1),
                                    thickness: 2,
                                  ),
                                  commentIndex == index
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

                                                  CommentController()
                                                      .insertComment(
                                                          discussionID: data.id,
                                                          userID: pref
                                                              .getInt("uid"),
                                                          content:
                                                              contentController
                                                                  .text)
                                                      .whenComplete(() {});
                                                  contentController.clear();
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                    FontAwesome
                                                        .arrow_right_long_solid,
                                                    color: ColorTheme.secondaryColor),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        )
                                      : const SizedBox.shrink(),
                                  Divider(
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
                                            .withOpacity(0.1),
                                    thickness: 2,
                                  ),
                                  const SizedBox(height: 20),

                                  //HERE IS THE COMMENT SECTION

                                  hideAllComments
                                      ? FutureBuilder<List<CommentModel>>(
                                          future: CommentController()
                                              .getCommentsData(id: data.id),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const SizedBox.shrink();
                                            } else if (snapshot.data!.isEmpty) {
                                              return const Center(
                                                child: Text("No comment...",
                                                    style: TextStyle(
                                                        fontSize: 30)),
                                              );
                                            } else {
                                              return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.length,
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
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          comment.profile.toString() == "default"
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
                                                                comment.profile
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
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                                                      comment.name.toString() == name.toString()
                                                                          ? "You"
                                                                          : comment
                                                                              .name
                                                                              .toString(),
                                                                      style: const TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              26,
                                                                              23,
                                                                              44,
                                                                              1),
                                                                          letterSpacing:
                                                                              1.5,
                                                                          wordSpacing:
                                                                              0.5,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14)),
                                                                  ReadMoreText(
                                                                    comment.content
                                                                            .toString()
                                                                            .isNotEmpty
                                                                        ? comment
                                                                            .content
                                                                            .toString()
                                                                        : "",
                                                                    trimLines:
                                                                        2,
                                                                    colorClickableText:
                                                                        Colors
                                                                            .pink,
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
                                                                            FontWeight.bold),
                                                                    lessStyle: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
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
                    );
                  },
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
