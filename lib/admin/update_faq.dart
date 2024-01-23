import 'dart:io';
import 'package:capstone_project/controllers/faq_controller.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class UpdateFaq extends StatefulWidget {
  const UpdateFaq({super.key, required this.id});
  final int id;

  @override
  State<UpdateFaq> createState() => UpdateFaqState();
}

class UpdateFaqState extends State<UpdateFaq> {
  FaqController faq = FaqController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  @override
  void initState() {
    faq.displayFaqDataID(widget.id).then((value) => {
          for (var result in value)
            {
              setState(() {
                titleController.text = result.title.toString();
                contentController.text = result.content.toString();
              })
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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
              const SizedBox(
                height: 10,
              ),
              const Text("EDIT FAQ",
                  style: TextStyle(
                      color: ColorTheme.secondaryColor,
                      letterSpacing: 1.5,
                      wordSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 4, right: 4),
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      hintText: "Title", border: OutlineInputBorder()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 4, right: 4),
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                      hintText: "Content", border: OutlineInputBorder()),
                ),
              ),
              TextButton(
                  onPressed: () => FaqController.updateFaq(widget.id, context,
                      titleController.text, contentController.text),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: ColorTheme.primaryColor,
                    ),
                    child: const Text("UPDATE",
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
