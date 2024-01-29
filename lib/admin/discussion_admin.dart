import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/admin_variables.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/discussion_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/theme/colors.dart';

class DiscussionAdmin extends StatefulWidget {
  const DiscussionAdmin({super.key});

  @override
  State<DiscussionAdmin> createState() => _DiscussionAdminState();
}

class _DiscussionAdminState extends State<DiscussionAdmin> {
  StreamController<List<DiscussionModel>> readingStreamController =
      StreamController<List<DiscussionModel>>();

  Future<void> closeStream() => readingStreamController.close();

  void getAdminDiscussion() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayDiscussionAPI),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          List<DiscussionModel> readings = jsonData
              .map<DiscussionModel>((json) => DiscussionModel.fromJson(json))
              .toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  void deleteDiscussion(int id) async {
    try {
      final response = await http.get(
          Uri.parse(API.deleteDiscussionAPIData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          // ignore: use_build_context_synchronously
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully deleted"));
        }
      }
      // deleteDiscussionAPIData
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    getAdminDiscussion();
    super.initState();
  }

  @override
  void dispose() {
    closeStream();
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
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: const Text("Discussion",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                //DISCUSSION CARD
                StreamBuilder<List<DiscussionModel>>(
                  stream: readingStreamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No data", style: TextStyle(fontSize: 30)),
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];

                            return Container(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(data.name.toString(),
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    26, 23, 44, 1),
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      IconButton(
                                          onPressed: () =>
                                              deleteDiscussion(data.id),
                                          icon: const Icon(EvaIcons.trash,
                                              size: 25,
                                              color: Color.fromRGBO(
                                                  123, 97, 255, 1))),
                                    ],
                                  ),
                                  Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          shape: BoxShape.rectangle),
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: Image.network(
                                        ImagesAPI.getImagesUrl(
                                            data.image.toString()),
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 300,
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
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
                  currentAdminScreen = AdminScreenNames.home;
                  // Navigator.of(context).pushNamed('/dashboard-emergency');
                  break;
                case 1:
                  currentAdminScreen = AdminScreenNames.post;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.post, (Route<dynamic> route) => false);
                  break;
                case 2:
                  currentAdminScreen = AdminScreenNames.bulletin;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.dashboardBulletin,
                      (Route<dynamic> route) => false);
                  break;
                case 3:
                  currentAdminScreen = AdminScreenNames.lostfound;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.dashboardLostfound,
                      (Route<dynamic> route) => false);
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
