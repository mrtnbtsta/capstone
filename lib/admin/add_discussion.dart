// ignore_for_file: unnecessary_null_comparison
// import 'dart:html' as html;
import 'dart:io';
import 'package:capstone_project/admin/admin_variables.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/discussion_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class AddDiscussion extends StatefulWidget {
  const AddDiscussion({super.key});

  @override
  State<AddDiscussion> createState() => AddDiscussionState();
}

class AddDiscussionState extends State<AddDiscussion> {
  final Incident incidentController = Incident();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imageFile;
  late String username;
  Future<void> chooseImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    image != null
        ? setState(() {
            imageFile = File(image.path);
          })
        : null;
  }

  Future<void> getLoginUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username") ?? "";
    nameController.text = username;
  }

  @override
  void initState() {
    getLoginUsername();
    incidentController.getIncidentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminSidebar(),
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  const Text("ADD DISCUSSION",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => buildNotifications(
                                incidentController, context)),
                        icon: const Icon(EvaIcons.bell,
                            color: ColorTheme.primaryColor),
                       
                      ),
                     StreamBuilder(
                                stream: incidentController
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
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  decoration: const BoxDecoration(
                      color: ColorTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(RouteName.discussionAdmin),
                    child: const Text("Discussion",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            color: ColorTheme.accentColor,
                            fontSize: 20)),
                  ),
                ),
              ),
              //spacing

              const SizedBox(height: 35),
              Stack(
                  // fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 1))
                          ]),
                      child: Center(
                        child: imageFile != null
                            ? Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            FileImage(File(imageFile!.path)))))
                            : const CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage(
                                    "assets/images/default_profile.jpg"),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: MediaQuery.of(context).size.width / 3.5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(width: 3, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: ColorTheme.secondaryColor,
                          ),
                          onPressed: () {
                            chooseImage();
                          },
                        ),
                      ),
                    ),
                  ]),
              const SizedBox(height: 30),
              //Form
              Form(
                child: Column(
                  children: <Widget>[
                    //Name field
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Name",
                          prefixIcon: Icon(
                            EvaIcons.person,
                            color: ColorTheme.secondaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Address Field
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Description",
                          prefixIcon: Icon(
                            EvaIcons.text_outline,
                            color: ColorTheme.secondaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              //Spacing

              //Register Button
              TextButton(
                  onPressed: () {
                    currentIndex = 0;
                    DiscussionController()
                        .insertDiscussion(nameController.text,
                            descriptionController.text, imageFile, context)
                        .whenComplete(() {
                      setState(() {
                        imageFile = null;
                        nameController.clear();
                        descriptionController.clear();
                      });
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: ColorTheme.primaryColor,
                    ),
                    child: const Text("POST",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            letterSpacing: .5,
                            wordSpacing: 0.5,
                            fontSize: 16)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
