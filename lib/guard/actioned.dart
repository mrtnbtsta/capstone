import 'dart:io';
import 'package:capstone_project/theme/colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/guard_sidebar.dart';
import 'package:capstone_project/models/guard_model.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Actioned extends StatefulWidget {
  const Actioned({super.key});

  @override
  ActionedState createState() => ActionedState();
}

class ActionedState extends State<Actioned> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const GuardSidebar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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

              const SizedBox(
                height: 10,
              ),

              Container(
                alignment: Alignment.topCenter,
                child: const Text("Resolved Report",
                    style: TextStyle(
                        color: Color.fromRGBO(26, 23, 44, 1),
                        letterSpacing: 1.5,
                        wordSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ),

              const SizedBox(
                height: 20,
              ),

              FutureBuilder<List<GuardModel1>>(
                future: GuardAPI.displayGuardEmergency1(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No data",
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = snapshot.data![index];
                        var currentdate =
                            "${months[data.date!.month.toInt() - 1]} ${data.date!.day.toInt()}, ${data.date!.year.toInt()}";
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: const EdgeInsets.only(left: 5),
                                  child: const Icon(EvaIcons.person_outline,
                                      size: 45,
                                      color: ColorTheme.secondaryColor),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 5),
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        SizedBox(
                                          width: 300,
                                          child: Text(data.address.toString(),
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      26, 23, 44, 1),
                                                  letterSpacing: 0.3,
                                                  wordSpacing: 0.5,
                                                  fontSize: 16)),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.height / 4,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 228, 232, 236)
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 150,
                                          height: 150,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(),
                                            imageUrl: ImagesAPI.getImagesUrl(
                                                data.image.toString()),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 500,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                )),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                      text: "Type of Report: ",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                      children: [
                                                    TextSpan(
                                                        text: data.typeOfReport
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16))
                                                  ])),
                                              RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "Location Incident: ",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                      children: [
                                                    TextSpan(
                                                        text: data
                                                            .locationIncident
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                  ])),
                                              RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "Describe Incident: ",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87),
                                                      children: [
                                                    TextSpan(
                                                        text: data
                                                            .describeIncident
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal))
                                                  ])),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color:
                                          const Color.fromRGBO(143, 143, 156, 1)
                                              .withOpacity(0.1),
                                      thickness: 2,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: "Resolved on: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                color: ColorTheme.secondaryColor,
                                                fontSize: 16),
                                            children: [
                                          TextSpan(
                                              text: currentdate.toString(),
                                              style: const TextStyle(
                                                  color: ColorTheme.secondaryColor,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16))
                                        ])),
                                  ],
                                )),
                          ],
                        );
                      },
                    );
                  }
                },
              ),

              //CARD CONTENT
            ],
          ),
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: itemList.length,
            tabBuilder: (index, isActive) {
              // var selected = isActive;
              final colorActive = isActive
                  ? ColorTheme.primaryColor
                  : const Color.fromARGB(255, 199, 203, 207);
              return Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Text(itemList[index],
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: colorActive,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          wordSpacing: 0.5))
                ],
              );
            },
            onTap: (int index) {
              switch (index) {
                case 0:
                  Navigator.of(context).pushNamed(RouteName.guardHome);
                  break;
                case 1:
                  //  Navigator.of(context).pushNamed('Actioned');
                  break;
              }
              setState(() {
                guardIndex = index;
              });
              // print(currentScreen);
            },
            shadow: const BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 2,
              color: Color.fromARGB(255, 228, 232, 236),
            ),
            activeIndex: guardIndex,
            leftCornerRadius: 5,
            rightCornerRadius: 5,
            backgroundColor: const Color.fromARGB(255, 228, 232, 236),
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.defaultEdge));
  }
}
