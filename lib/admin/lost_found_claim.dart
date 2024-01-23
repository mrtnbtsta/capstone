// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, iterable_contains_unrelated_type
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:get/get.dart';
import 'admin_variables.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:readmore/readmore.dart';
import 'package:capstone_project/theme/colors.dart';
class DashboardLostFound extends StatefulWidget {
  const DashboardLostFound({super.key});

  @override
  State<DashboardLostFound> createState() => _DashboardLostFoundState();
}

class _DashboardLostFoundState extends State<DashboardLostFound> {
  final LostFoundController lostFoundController =
      Get.put(LostFoundController());
  ClaimedNotification claimedNotification = ClaimedNotification();

  final StreamController<List<LostFoundModel>> readingStreamController =
      StreamController<List<LostFoundModel>>();

  Future<void> closeStream() => readingStreamController.close();

  Future<List<LostFoundModel1>> filterLostFoundData() async {
    List<LostFoundModel1> data = <LostFoundModel1>[];

    try {
      final response =
          await http.get(Uri.parse(API.displayAllLostFoundAPI), headers: {
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var result in jsonData) {
          // dataModel.remove(result);
          LostFoundModel1 model = LostFoundModel1(
              id: result["id"],
              uid: result["uid"],
              cid: result["cid"],
              name: result["uName"],
              address: result["address"],
              image: result["image"],
              description: result["detail_description"],
              lostItem: result["lost_item"],
              dateOfLost: result["date_of_lost"]);
          data.add(model);
        }
      }
    } catch (e) {
      //
    }

    return data;
  }


  void deleteLostFoundClaim(int id, context) async {
    try {
      final response = await http.get(
          Uri.parse(API.deleteLostFoundClaimSearchAPIData(id)),
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
    } catch (e) {
      //
    }
  }



  @override
  void initState() {
    claimedNotification.displayLostFoundData();
    claimedNotification.displayLostFoundClaimedData();
    super.initState();
  }

  
@override
  void dispose() {
    claimedNotification.closeStream();
    claimedNotification.closeStream1();
    closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        drawer: const AdminSidebar(),
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
                      child: Row(
                        // mainAxisAlignment: Ma,
                        children: [
                          
                           Stack(
                            children: [
                              IconButton(
                                onPressed: () => showDialog(context: context, builder: (context) => buildLostAndFoundNotification(claimedNotification, context)),
                                icon: const Icon(FontAwesome.searchengin_brand,
                                    color: ColorTheme.primaryColor),
                              ),
                               StreamBuilder(
                                stream: claimedNotification
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
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("List of claimed",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<LostFoundModel>>(
                  stream: claimedNotification.readingStreamController1.stream,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                          onPressed: () async {
                                            ArtDialogResponse response =
                                                await ArtSweetAlert.show(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    artDialogArgs: ArtDialogArgs(
                                                        denyButtonText:
                                                            "Cancel",
                                                        title: "Are you sure?",
                                                        text:
                                                            "You can still able to revert this!",
                                                        confirmButtonText:
                                                            "Unclaim",
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
                                                    type: ArtSweetAlertType
                                                        .warning,
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
                                                    type: ArtSweetAlertType
                                                        .success,
                                                    title: "Unclaimed!",
                                                    onConfirm: () {
                                                      Claim.updateClaimStatus0(
                                                          model.cid!.toInt(),
                                                          context);
                                                    },
                                                  ));
                                              return;
                                            }
                                          },
                                          child: const Text("Claimed",
                                              style: TextStyle(
                                                  color: ColorTheme.accentColor,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            deleteLostFoundClaim(
                                                model.cid!.toInt(), context);
                                          },
                                          icon: const Icon(EvaIcons.trash,
                                              size: 25,
                                              color: ColorTheme.secondaryColor)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                    ],
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
                                      )),
                                  Divider(
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                          width: 250,
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
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                  Divider(
                                    color:
                                        const Color.fromRGBO(143, 143, 156, 1)
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
                                      child: Image.network(
                                        ImagesAPI.getImagesUrl(
                                            model.image.toString()),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        height: 300,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      )),
                                ],
                              ));
                        },
                      );
                    }
                  },
                )
                // buildPagination(),
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.dashboardEmergency,
                      (Route<dynamic> route) => false);
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
