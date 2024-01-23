// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, iterable_contains_unrelated_type
import 'dart:async';
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'admin_variables.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:capstone_project/theme/colors.dart';
class DashboardLostFoundSearch extends StatefulWidget {
  const DashboardLostFoundSearch({super.key, required this.lostItem});
  final String lostItem;
  @override
  State<DashboardLostFoundSearch> createState() =>
      _DashboardLostFoundSearchStateSearch();
}

class _DashboardLostFoundSearchStateSearch
    extends State<DashboardLostFoundSearch> {
  List<LostFoundModel> dataModel = <LostFoundModel>[];

  final StreamController<List<LostFoundModel>> readingStreamController =
      StreamController<List<LostFoundModel>>();

  Future<void> closeStream() => readingStreamController.close();

  List<String> dropdownItems = [];

  void searchFoundData() async {
    // List<LostFoundModel> data = <LostFoundModel>[];

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();

      try {
        final response = await http.get(
            Uri.parse(API.displayLostFoundDataSearchData(widget.lostItem)),
            headers: {
              "Accept": "application/json",
            });
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          List<LostFoundModel> readings = jsonData.map<LostFoundModel>((json) {
            return LostFoundModel.fromJson(json);
          }).toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
    // return data;
  }

  void deleteLostFoundClaim(int id) async {
    try {
      final response = await http.get(
          Uri.parse(API.deleteLostFoundClaimSearchAPIData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(
            child: Text("Successfully deleted"),
          )));
        }
      }
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    searchFoundData();
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
        appBar: AppBar(),
        // drawer: const AdminSidebar(),
        backgroundColor: const Color.fromARGB(255, 228, 232, 236),
        body: SafeArea(
          child: SingleChildScrollView(
            // physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                StreamBuilder<List<LostFoundModel>>(
                  stream: readingStreamController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: ColorTheme.primaryColor,));
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No claiming request",
                            style: TextStyle(fontSize: 30)),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final model = snapshot.data![index];
                        return Container(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.zero,
                                      margin: const EdgeInsets.only(right: 15),
                                      transformAlignment: Alignment.topRight,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
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
                                        onPressed: () async {
                                          ArtDialogResponse response =
                                              await ArtSweetAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                      denyButtonText: "Cancel",
                                                      title: "Are you sure?",
                                                      text:
                                                          "You can still able to revert this!",
                                                      confirmButtonText:
                                                          "Claim",
                                                      type: ArtSweetAlertType
                                                          .warning));

                                          if (response == null) {
                                            return;
                                          }

                                          if (response.isTapDenyButton) {
                                            // ignore: use_build_context_synchronously
                                            ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type:
                                                      ArtSweetAlertType.warning,
                                                  title: "Cancelled!",
                                                  onDeny: () {},
                                                ));
                                            return;
                                          }

                                          if (response.isTapConfirmButton) {
                                            // ignore: use_build_context_synchronously
                                            ArtSweetAlert.show(
                                                context: context,
                                                artDialogArgs: ArtDialogArgs(
                                                  type:
                                                      ArtSweetAlertType.success,
                                                  title: "Claimed!",
                                                  onConfirm: () {
                                                    Claim.updateClaimStatus1(
                                                        model.cid!.toInt(),
                                                        context);
                                                  },
                                                ));
                                            return;
                                          }
                                        },
                                        child: const Text("Claim",
                                            style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          deleteLostFoundClaim(
                                              model.cid!.toInt());
                                        },
                                        icon: const Icon(EvaIcons.trash,
                                            size: 25,
                                            color: ColorTheme.secondaryColor)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Text("Uploaded by: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5)),
                                      Text(model.name.toString(),
                                          style: const TextStyle(
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text("Proof of Ownership",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 0.5)),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Container(),
                                      imageUrl: ImagesAPI.getImagesUrl(
                                          model.claimImage.toString()),
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Text("Name: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5)),
                                      Text(model.name.toString(),
                                          style: const TextStyle(
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5,
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: const Color.fromRGBO(143, 143, 156, 1)
                                      .withOpacity(0.1),
                                  thickness: 2,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Text("Address: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5)),
                                      SizedBox(
                                        width: 200,
                                        child: Text(model.address.toString(),
                                            style: const TextStyle(
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5,
                                              fontSize: 16,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: const Color.fromRGBO(143, 143, 156, 1)
                                      .withOpacity(0.1),
                                  thickness: 2,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      const Text("Lost of Item: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                              wordSpacing: 0.5)),
                                      Text(model.lostItem.toString(),
                                          style: const TextStyle(
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5,
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: const Color.fromRGBO(143, 143, 156, 1)
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
                                      Text(model.dateOfLost.toString(),
                                          style: const TextStyle(
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5,
                                            fontSize: 16,
                                          ))
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: const Color.fromRGBO(143, 143, 156, 1)
                                      .withOpacity(0.1),
                                  thickness: 2,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          model.description.toString(),
                                          trimLines: 2,
                                          colorClickableText: Colors.pink,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
                                          moreStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          lessStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  color: const Color.fromRGBO(143, 143, 156, 1)
                                      .withOpacity(0.1),
                                  thickness: 2,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text("Original Image Uploaded",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 0.5)),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Container(),
                                      imageUrl: ImagesAPI.getImagesUrl(
                                          model.claimImage.toString()),
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
                              ],
                            ));
                      },
                    );
                  },
                ),
                const SizedBox(height: 50),
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
                  Navigator.of(context).pushNamed(RouteName.dashboardEmergency);
                  break;
                case 1:
                  currentAdminScreen = AdminScreenNames.post;
                  Navigator.of(context).pushNamed(RouteName.post);
                  break;
                case 2:
                  currentAdminScreen = AdminScreenNames.bulletin;
                  Navigator.of(context).pushNamed(RouteName.dashboardBulletin);
                  break;
                case 3:
                  currentAdminScreen = AdminScreenNames.lostfound;
                  // Navigator.of(context).pushNamed("/dashboard-lostfound");
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

  Widget buildLostFound(LostFoundModel model) => Obx(() => Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 228, 232, 236).withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.network(
                        ImagesAPI.getImagesUrl(model.image.toString()),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                      )),
                  Divider(
                    color:
                        const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                    thickness: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text("Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Text(model.name.toString(),
                            style: const TextStyle(
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                    thickness: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text("Address: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Text(model.address.toString(),
                            style: const TextStyle(
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                    thickness: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text("Lost of Item: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Text(model.lostItem.toString(),
                            style: const TextStyle(
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                    thickness: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Text("Date of Lost: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Text(model.dateOfLost.toString(),
                            style: const TextStyle(
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                  Divider(
                    color:
                        const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
                    thickness: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Detail Description: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Expanded(
                          child: ReadMoreText(
                            model.description.toString(),
                            trimLines: 2,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            lessStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 10),
          Divider(
            color: const Color.fromRGBO(143, 143, 156, 1).withOpacity(0.1),
            thickness: 2,
          ),
          const SizedBox(height: 10),
        ],
      ));
}
