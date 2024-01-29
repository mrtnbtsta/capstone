import 'dart:async';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/bulletin_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/bulletin_controller.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_variables.dart';
import 'package:capstone_project/theme/colors.dart';
class DashboardBulletin extends StatefulWidget {
  const DashboardBulletin({super.key});

  @override
  State<DashboardBulletin> createState() => _DashboardBulletinState();
}

class _DashboardBulletinState extends State<DashboardBulletin> {
  File? imageFile;
  String? value;
  bool showMessage = false;

  List<String> dropdownItems = ["News", "Events", "User Reports"];
  String? dropdownValue;
  List<String> dropdownItemsFilter = ["News", "Events", "User Reports"];
  String? description;
  String? dropdownFilter;

  final BulletinController bulletinController = Get.put(BulletinController());

  Future<void> chooseImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future<void> getDescription() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    description = pref.getString("descriptionText").toString();
  }

  @override
  void initState() {
    getDescription();
    super.initState();
  }

  @override
  void dispose() {
    // bulletinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        drawer: const AdminSidebar(),
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      // IconButton(
                      //   onPressed: () => {},
                      //   icon: const Icon(EvaIcons.bell,
                      //       color: Color.fromRGBO(123, 97, 255, 1)),
                      // )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(221, 221, 221, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(10),
                              dropdownColor:
                                  const Color.fromRGBO(221, 221, 221, 1),
                              isExpanded: false,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Bootstrap.filter,
                                    color: ColorTheme.secondaryColor,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20)),
                              hint: const Text("Filter"),
                              value: dropdownFilter,
                              onChanged: (value) {
                                setState(() {
                                  dropdownFilter = value;
                                });
                                bulletinController
                                    .filterBulletinData(value!)
                                    .then((data) {
                                  setState(() {
                                    bulletinController.dataModel =
                                        data as RxList<BulletinModel>;
                                  });
                                });
                              },
                              items: dropdownItemsFilter
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()),
                        ),
                      ),
                      SizedBox(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(RouteName.addPost);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: ColorTheme.primaryColor,
                              ),
                              child: const Text("ADD POST",
                                  style: TextStyle(
                                      color: ColorTheme.accentColor,
                                      letterSpacing: .5,
                                      wordSpacing: 0.5,
                                      fontSize: 16)),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (dropdownItemsFilter
                          .toString()
                          .contains(dropdownFilter.toString()) &&
                      bulletinController.dataModel.isEmpty) ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Text("${dropdownFilter.toString()} has no data",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 40,
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5)),
                        ],
                      ),
                    )
                  ] else ...[
                    buildBulletin1()
                    // buildBulletin(),
                  ],

                ]),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RouteName.monthlyReport),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: ColorTheme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: const Text("Post Monthly Report", style: TextStyle(color: ColorTheme.accentColor, fontSize: 19, letterSpacing: 1.5, wordSpacing: 0.5),),
                      ),
                  ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (index, isActive) {
              final color = isActive
                  ? ColorTheme.secondaryColor
                  : ColorTheme.primaryColor;
              return Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Icon(
                    iconList[index],
                    size: 25,
                    color: color,
                  ),
                  Text(iconNames[index],
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: color, fontSize: 11))
                ],
              );
            },
            onTap: (int index) {
              setState(() => currentIndex = index);
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
                  // Navigator.of(context).pushNamed("/dashboard-bulletin");
                  break;
                case 3:
                  currentAdminScreen = AdminScreenNames.lostfound;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.dashboardLostfound,
                      (Route<dynamic> route) => false);
                  break;
              }
            },
            shadow: const BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 2,
              color: Color.fromARGB(255, 200, 203, 206),
            ),
            activeIndex: currentIndex,
            leftCornerRadius: 5,
            rightCornerRadius: 5,
            backgroundColor: const Color.fromARGB(255, 228, 232, 236),
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.defaultEdge));
  }

  Widget buildBulletin1() {
    if (dropdownItemsFilter.toString().contains(dropdownFilter.toString()) &&
        bulletinController.dataModel.isNotEmpty) {
      return Obx(
        () => ListView.builder(
          physics: const ScrollPhysics(),
          itemCount: bulletinController.dataModel.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = bulletinController.dataModel[index];

            return SizedBox(
              child: Card(
                color: const Color.fromARGB(255, 234, 236, 238),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data.title.toString(),
                              style: const TextStyle(
                                  color: Colors.black87,
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () async {
                                ArtDialogResponse response =
                                    await ArtSweetAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            denyButtonText: "Cancel",
                                            title: "Are you sure?",
                                            text:
                                                "You won't be able to revert this!",
                                            confirmButtonText: "Yes, delete it",
                                            type: ArtSweetAlertType.warning));

                                // ignore: unnecessary_null_comparison
                                if (response == null) {
                                  return;
                                }

                                if (response.isTapConfirmButton) {
                                  // ignore: use_build_context_synchronously
                                  bulletinController
                                      .deleteBulletinData(data.id);

                                  return;
                                }
                              },
                              icon: const Icon(EvaIcons.trash,
                                  size: 25,
                                  color: Color.fromRGBO(123, 97, 255, 1))),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width / 2.1,
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(),
                            imageUrl:
                                ImagesAPI.getImagesUrl(data.image.toString()),
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: 150,
                                height: 150,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ReadMoreText(
                              data.description.toString(),
                              trimLines: 6,
                              style: const TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  letterSpacing: 1.5,
                                  wordSpacing: 0.5,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              lessStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else if (!dropdownItemsFilter
        .toString()
        .contains(dropdownFilter.toString())) {
      return const Center(
        child: Text("SELECT FILTER TO DISPLAY DATA",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                letterSpacing: 1.5,
                wordSpacing: 0.5)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
