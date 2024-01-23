// ignore_for_file: unnecessary_null_comparison
// import 'dart:html' as html;
import 'dart:io';
import 'package:capstone_project/admin/admin_variables.dart';
import 'package:capstone_project/admin/functions.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/faq_controller.dart';
import 'package:capstone_project/controllers/report_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/theme/colors.dart';
class AddFaq extends StatefulWidget {
  const AddFaq({super.key});

  @override
  AddFaqState createState() => AddFaqState();
}

class AddFaqState extends State<AddFaq> {
  final Incident incidentController = Incident();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
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
                  const Text("ADD FAQ",
                      style: TextStyle(
                          color: ColorTheme.secondaryColor,
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(RouteName.faq),
                    child: const Text("Manage",
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
                        controller: titleController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Title",
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
                    //Address Field
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Content",
                          prefixIcon: Icon(
                            Bootstrap.paragraph,
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
                    FaqController.addFaq(
                        titleController.text, contentController.text, context);
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
                    child: const Text("SUBMIT",
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
