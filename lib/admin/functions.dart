import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/user_map_display.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/alert_controller.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/lostfound_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/models/alert_model.dart';
import 'package:capstone_project/models/claim_model.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:capstone_project/models/report_model.dart';
import 'package:capstone_project/models/usernotif_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/theme/colors.dart';
import '../controllers/claim_controller.dart';

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

Widget buildNotifications(Incident incidentController, BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.all(20),
    contentPadding: const EdgeInsets.all(20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Notifications",
            style: TextStyle(
                color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5)),
        Container(
          decoration: const BoxDecoration(
              color: ColorTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: () => incidentController.updateEmergencySeenData(),
            child: const Text("Clear All",
                style: TextStyle(
                    color: ColorTheme.accentColor,
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
          ),
        )
      ],
    ),
    content: StreamBuilder<List<AllIncident>>(
      stream: incidentController.readingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                ArtDialogResponse response =
                                    // ignore: use_build_context_synchronously
                                    await ArtSweetAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            denyButtonText: "Cancel",
                                            title: "Notification",
                                            text: "Send to guard",
                                            confirmButtonText: "Yes",
                                            type: ArtSweetAlertType.success));
                                // Navigator.of(context).pop();

                                // ignore: unnecessary_null_comparison
                                if (response == null) {
                                  return;
                                }

                                if (response.isTapConfirmButton) {
                                  GuardAPI.insertGuardEmergency(data.rid);
                                  incidentController
                                      .updateNotification(data.rid);
                                  return;
                                }
                             
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            ImagesAPI.getImagesUrl(
                                                data.image.toString()),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.name.toString(),
                                            style: const TextStyle(
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          ReadMoreText(
                                            data.address.toString(),
                                            trimLines: 6,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: data.seen.toString() == "0"
                                            ? Colors.grey.shade700
                                            : Colors.transparent),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}

Widget buildUserNotifications(
    UserNotification userNotification, BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.all(20),
    contentPadding: const EdgeInsets.all(20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Notifications",
            style: TextStyle(
                color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5)),
        Container(
          decoration: const BoxDecoration(
              color: ColorTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: () => GuardAPI.updateGuardEmergencySeen(),
            child: const Text("Clear All",
                style: TextStyle(
                    color: ColorTheme.accentColor,
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
          ),
        )
      ],
    ),
    content: StreamBuilder<List<UserNotificationModel>>(
      stream: userNotification.readingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      var currentDate =
                          "${months[data.date!.month.toInt() - 1]} ${data.date!.day.toInt()}, ${data.date!.year.toInt()}";

                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (data.isResolved.toString() == "1") {
                                  return;
                                } else {
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                              denyButtonText: "Cancel",
                                              title: "Resolve Report",
                                              text:
                                                  "Do you want to resolve this report? You cannot revert this once you click yes!",
                                              confirmButtonText: "Yes",
                                              type: ArtSweetAlertType.success));
                                  // Navigator.of(context).pop();

                                  // ignore: unnecessary_null_comparison
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapConfirmButton) {
                                    GuardAPI.updateGuardEmergency0(data.gid);

                                    return;
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          data.isResolved.toString() == "0"
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "From ${data.username.toString()}",
                                                      style: const TextStyle(
                                                          letterSpacing: 1.5,
                                                          wordSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    ReadMoreText(
                                                      data.message.toString(),
                                                      trimLines: 6,
                                                      colorClickableText:
                                                          Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          'Show more',
                                                      trimExpandedText:
                                                          'Show less',
                                                      moreStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      lessStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                text: "To: ",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87),
                                                                children: [
                                                              TextSpan(
                                                                  text: data
                                                                      .name
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          16))
                                                            ])),
                                                        RichText(
                                                            text: TextSpan(
                                                                text: "Type: ",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87),
                                                                children: [
                                                              TextSpan(
                                                                  text: data
                                                                      .type
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          16))
                                                            ])),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.contain,
                                                            image: NetworkImage(
                                                              ImagesAPI
                                                                  .getImagesUrl(data
                                                                      .image
                                                                      .toString()),
                                                            ),
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  "Resolved on: ",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87),
                                                              children: [
                                                            TextSpan(
                                                                text: currentDate
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        16))
                                                          ])),
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}


Widget buildLostAndFoundNotification(
    ClaimedNotification claimedNotification, BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.all(20),
    contentPadding: const EdgeInsets.all(20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Lost & Found",
            style: TextStyle(
                color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5)),
        Container(
          decoration: const BoxDecoration(
              color: ColorTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: () => claimedNotification.updateLostFoundCLaimSeen(),
            child: const Text("Clear All",
                style: TextStyle(
                    color: Color.fromARGB(221, 255, 255, 255),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
          ),
        )
      ],
    ),
    content: StreamBuilder<List<LostFoundModel>>(
      stream: claimedNotification.readingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                Claim.updateClaimStatus1(data.cid!.toInt(), context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            RichText(
                                            text: TextSpan(
                                                text: "${data.name}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                    color: Colors
                                                        .black87),
                                                children: [
                                              TextSpan(
                                                  text: " has sent you claiming request"
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontWeight:
                                                          FontWeight
                                                              .normal,
                                                      fontSize:
                                                          16))
                                            ])),

                                        RichText(
                                        text: TextSpan(
                                            text: "Lost item: ",
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: Colors
                                                    .black87),
                                            children: [
                                          TextSpan(
                                              text: data.lostItem.toString(),
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontWeight:
                                                      FontWeight
                                                          .normal,
                                                  fontSize:
                                                      16))
                                          ])),
                                    const SizedBox(height: 5,),
                                             Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            ImagesAPI.getImagesUrl(
                                                data.image.toString()),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(height: 3,),
                                  const Text("Proof of Image",
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 3,),
                                                            Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            ImagesAPI.getImagesUrl(
                                                data.claimImage.toString()),
                                          ),
                                        )),
                                  ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                      
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}

Widget buildAlertNotifications(
    AlertController alertController, BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.all(20),
    contentPadding: const EdgeInsets.all(20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Alerts",
            style: TextStyle(
                color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5)),
        Container(
          decoration: const BoxDecoration(
              color: ColorTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: () => alertController.updateAlertSeenData(),
            child: const Text("Clear All",
                style: TextStyle(
                    color: Color.fromARGB(221, 255, 255, 255),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
          ),
        )
      ],
    ),
    content: StreamBuilder<List<AlertModel>>(
      stream: alertController.readingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        UserMapDisplay(
                                            coordinates: LatLng(
                                                data.latitude, data.longitude)),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero));
                                // alertController
                                //     .updateAlertNotification(data.alertID);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            ImagesAPI.getProfileUrl(
                                                data.profile.toString()),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.uName.toString(),
                                            style: const TextStyle(
                                                letterSpacing: 1.5,
                                                wordSpacing: 0.5,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          ReadMoreText(
                                            data.address.toString(),
                                            trimLines: 6,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: data.seen.toString() == "0"
                                            ? Colors.grey.shade700
                                            : Colors.transparent),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}

Widget buildClaimNotifications(
    ClaimController claimNotification, BuildContext context) {
  return AlertDialog(
    insetPadding: const EdgeInsets.all(20),
    contentPadding: const EdgeInsets.all(20),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Claimed",
            style: TextStyle(
                color: Colors.black87, letterSpacing: 1.5, wordSpacing: 0.5)),
        Container(
          decoration: const BoxDecoration(
              color: ColorTheme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextButton(
            onPressed: () => ClaimController.updateGuardEmergencySeen(),
            child: const Text("Clear All",
                style: TextStyle(
                    color: Color.fromARGB(221, 255, 255, 255),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
          ),
        )
      ],
    ),
    content: StreamBuilder<List<ClaimModels>>(
      stream: claimNotification.readingStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Positioned(
                child: SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 250,
                                            child: Text(
                                              "This item has been claimed by ${data.uName} and has submitted picture as proof",
                                              style: const TextStyle(
                                                  letterSpacing: 1.5,
                                                  wordSpacing: 0.5,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: 300,
                                            height: 200,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                    ImagesAPI.getImagesUrl(
                                                        data.image.toString()),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    ),
  );
}
