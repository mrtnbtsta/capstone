// import 'dart:html' as html;
// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/controllers/usernotif_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'map_function.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HazardReport extends StatefulWidget {
  const HazardReport({super.key});

  @override
  HazardReportState createState() => HazardReportState();
}

class HazardReportState extends State<HazardReport> {
  final UserNotification userNotification = UserNotification();
  int selectedValue = 0;

  var bottomIndex = 0;

  final iconList = <IconData>[
    EvaIcons.home,
    FontAwesome.file,
    FontAwesome.book_atlas_solid,
    FontAwesome.searchengin_brand
  ];

  String? postStatus;
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final specifiyController = TextEditingController();
  final describeController = TextEditingController();
  final locationController = TextEditingController();

  String? hazard;

  final picker = ImagePicker();
  File? photoFile;

  Future<void> photoUpload() async {
    var photo = await picker.pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    photo != null
        ? setState(() {
            photoFile = File(photo.path);
          })
        : null;
  }

  Future<void> takePhoto() async {
    var photo = await picker.pickImage(source: ImageSource.camera);

    //if there is an image set the image to the imageFIle
    photo != null
        ? setState(() {
            photoFile = File(photo.path);
          })
        : null;
  }

  String? name;
  String? contact;
  String? address;
  void getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name") ?? "";
    contact = pref.getString("contact") ?? "";
    address = pref.getString("address") ?? "";
    nameController.text = name.toString();
    contactController.text = contact.toString();
    addressController.text = address.toString();
    var currentDate =
        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
    dateController.text = currentDate.toString();
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

 
  void getCurrentDateMonth() {
    var current = DateTime.now();
    month = months[current.month.toInt() - 1];
    startDate = "${current.month}/${current.day}/${current.year}";
    endDate = "${current.month}/${current.day}/${current.year}";
  }

  @override
  void initState() {
    getCurrentDateMonth();
    MapFunctions.getUserLocation();
    getUsername();
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
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        drawer: const Sidebar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            reportIndex = 0;
                          });
                          Navigator.of(context).pushNamed(RouteName.emergency);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 188, 192, 197),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ColorTheme.primaryColor,
                          ),
                          child: const Column(
                            children: <Widget>[
                              Icon(FontAwesome.kit_medical_solid,
                                  size: 30, color: ColorTheme.secondaryColor),
                              Text("EMERGENCY",
                                  style: TextStyle(
                                      color: ColorTheme.accentColor, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(255, 188, 192, 197),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 3))
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: reportIndex == 1
                                ? ColorTheme.activeColor
                                : ColorTheme.primaryColor,
                          ),
                          child: const Column(
                            children: <Widget>[
                              Icon(EvaIcons.activity,
                                  size: 30, color: ColorTheme.secondaryColor),
                              Text("HAZARD",
                                  style: TextStyle(
                                      color: ColorTheme.accentColor, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            reportIndex = 2;
                          });
                          Navigator.of(context).pushNamed(RouteName.crime);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 188, 192, 197),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ColorTheme.primaryColor,
                          ),
                          child: const Column(
                            children: <Widget>[
                              Icon(EvaIcons.activity,
                                  size: 30, color: ColorTheme.secondaryColor),
                              Text("CRIME",
                                  style: TextStyle(
                                      color: ColorTheme.accentColor, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 10, left: 5, right: 5),
                  child: const Text("HAZARD REPORTS",
                      style: TextStyle(
                          color: ColorTheme.secondaryColor,
                          fontSize: 20,
                          letterSpacing: 1.5)),
                ),
                //spacing
                const SizedBox(height: 10),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          const Text("Name: ",
                              style: TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5)),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: nameController,
                            ),
                          ),
                          const Text("Date: ",
                              style: TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5)),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Address: ",
                              style: TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5)),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: addressController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Contact No: ",
                              style: TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5)),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              expands: false,
                              controller: contactController,
                              decoration:
                                  const InputDecoration(counterText: ''),
                            ),
                          ),
                        ],
                      ),

                      //spacing
                      const SizedBox(height: 10),

                      const Divider(),

                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "What type of Hazard?",
                          style: TextStyle(
                              color: Color.fromRGBO(26, 23, 44, 1),
                              letterSpacing: 1.5,
                              wordSpacing: 0.5,
                              fontSize: 18),
                        ),
                      ),

                      //TEXTBOX FIRST ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 30),
                            child: Checkbox(
                              value: selectedValue == 1,
                              onChanged: (value) => setState(() {
                                selectedValue = 1;
                                hazard = "Road Hazard";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Road Hazard",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Checkbox(
                              value: selectedValue == 2,
                              onChanged: (value) => setState(() {
                                selectedValue = 2;
                                hazard = "Physical Hazards";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Physical Hazards",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      // TEXTBOX SECOND ROW
                      //spacing``
                      // const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 30),
                            child: Checkbox(
                              value: selectedValue == 3,
                              onChanged: (value) => setState(() {
                                selectedValue = 3;
                                hazard = "Workload hazards";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Workload hazards",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Checkbox(
                              value: selectedValue == 4,
                              onChanged: (value) => setState(() {
                                selectedValue = 4;
                                hazard = "Trash Problem";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Trash Problem",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      //THIRD ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 30),
                            child: Checkbox(
                              value: selectedValue == 5,
                              onChanged: (value) => setState(() {
                                selectedValue = 5;
                                hazard = "Electric Hazard";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Electric Hazard",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Checkbox(
                              value: selectedValue == 6,
                              onChanged: (value) => setState(() {
                                selectedValue = 6;
                                hazard = "Gas Leak";
                                // print(hazard);
                              }),
                            ),
                          ),
                          const Expanded(
                            child: Text("Gas Leak",
                                style: TextStyle(
                                    color: Color.fromRGBO(26, 23, 44, 1),
                                    letterSpacing: 0.5,
                                    wordSpacing: 0.5,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 5),
                            child: const Text("If Others, Please Specify: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    color: Color.fromRGBO(26, 23, 44, 1))),
                          ),
                          Expanded(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: specifiyController,
                              maxLines: null,
                            ),
                          )
                        ],
                      ),
                       const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 5),
                            child: const Text("Describe Incidents: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    color: Color.fromRGBO(26, 23, 44, 1))),
                          ),
                          Expanded(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: describeController,
                              maxLines: null,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 2, left: 5),
                            child: const Text("Location of Incidents: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    color: Color.fromRGBO(26, 23, 44, 1))),
                          ),
                          Expanded(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: locationController,
                              maxLines: null,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorTheme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  currentIndex = 0;
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                              confirmButtonColor:
                                                  const Color.fromRGBO(
                                                      123, 97, 255, 1),
                                              denyButtonColor:
                                                  const Color.fromRGBO(
                                                      123, 97, 255, 1),
                                              denyButtonText: "User",
                                              title: "Emergency Report",
                                              showCancelBtn: true,
                                              text: "POST AS",
                                              confirmButtonText: "Anonymous",
                                              type:
                                                  ArtSweetAlertType.question));

                                  // ignore: unnecessary_null_comparison
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapConfirmButton) {
                                    EmergencyController.insertReport(
                                        nameController.text,
                                        dateController.text,
                                        addressController.text,
                                        contactController.text,
                                        hazard ??= "",
                                        describeController.text,
                                        locationController.text,
                                        specifiyController.text,
                                        "Hazard",
                                        photoFile,
                                        pref.getInt("uid")!.toInt(),
                                        "Anonymous",
                                        month,
                                        context);

                                    // Navigator.of(context).pop();
                                    return;
                                  }

                                  if (response.isTapDenyButton) {
                                    EmergencyController.insertReport(
                                        nameController.text,
                                        dateController.text,
                                        addressController.text,
                                        contactController.text,
                                        hazard ??= "",
                                        describeController.text,
                                        locationController.text,
                                        specifiyController.text,
                                        "Hazard",
                                        photoFile,
                                        pref.getInt("uid")!.toInt(),
                                        "Default",
                                        month,
                                        context);
                                  }
                                },
                                child: const Text("Submit",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorTheme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                onPressed: () {
                                  locationController.clear();
                                  describeController.clear();
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorTheme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                onPressed: () {
                                  photoUpload();
                                },
                                child: const Text("Upload Photo",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorTheme.primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                onPressed: () {
                                  takePhoto();
                                },
                                child: const Text("Take Photo",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 40)
                    ],
                  ),
                )
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
