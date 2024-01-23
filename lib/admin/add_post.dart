import 'dart:async';
import 'dart:io';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/controllers/bulletin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  BulletinController bulletinController = Get.put(BulletinController());
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imagefile;
  String? dropdownValue;
  List<String> dropdownItems = ["News", "Events", "User Reports"];
  Future<void> chooseImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    image != null
        ? setState(() {
            imagefile = File(image.path);
          })
        : null;
  }

  @override
  void dispose() {
    bulletinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: const Text("POST",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: imagefile != null
                          ? Image.file(
                              File(imagefile!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                            )
                          : Image.asset(
                              "assets/images/default_profile.jpg",
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(240, 239, 239, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Title",
                          prefixIcon: Icon(
                            EvaIcons.lock,
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
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(240, 239, 239, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Description",
                          prefixIcon: Icon(
                            EvaIcons.lock,
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
                    const SizedBox(height: 10),
                    //ADD IMAGE
                    TextButton(
                        onPressed: () {
                          chooseImage();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: const Color.fromRGBO(240, 239, 239, 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2))
                              ]),
                          child: const Row(
                            children: [
                              Icon(
                                EvaIcons.file,
                                color: ColorTheme.secondaryColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text("Add image",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(80, 80, 80, .875),
                                        letterSpacing: .5,
                                        wordSpacing: 0.5,
                                        fontSize: 16)),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(240, 239, 239, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: const Color.fromRGBO(221, 221, 221, 1),
                          isExpanded: false,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                EvaIcons.person,
                                color: ColorTheme.secondaryColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20)),
                          hint: const Text("Select type of Bulletin"),
                          value: dropdownValue,
                          onChanged: (value) =>
                              setState(() => dropdownValue = value),
                          items: dropdownItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      bulletinController.insertBulletinData(
                          titleController.text,
                          descriptionController.text,
                          imagefile,
                          dropdownValue,
                          context);
                     
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(17),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: ColorTheme.primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 2))
                          ]),
                      child: const Text("ADD POST",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              letterSpacing: .5,
                              wordSpacing: 0.5,
                              fontSize: 16)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
