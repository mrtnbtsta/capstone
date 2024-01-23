import 'dart:io';
import 'package:capstone_project/admin/update_faq.dart';
import 'package:capstone_project/controllers/faq_controller.dart';
import 'package:capstone_project/models/faq_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/theme/colors.dart';
class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  FaqState createState() => FaqState();
}

class FaqState extends State<Faq> {
  FaqController faq = FaqController();

  @override
  void initState() {
    faq.displayFaqDataAdmin();
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
              StreamBuilder<List<FaqsModel>>(
                stream: faq.readingStreamController.stream,
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
                        final data = snapshot.data![index];
                        return Container(
                          margin: const EdgeInsets.all(8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(data.title.toString(),
                                        style: const TextStyle(
                                            color: ColorTheme.secondaryColor,
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 300,
                                  child: Text(
                                    data.content.toString(),
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        letterSpacing: 1.5,
                                        wordSpacing: 0.5,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Divider(
                                color: const Color.fromRGBO(143, 143, 156, 1)
                                    .withOpacity(0.1),
                                thickness: 2,
                              ),
                              Container(
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  UpdateFaq(
                                                    id: data.fid,
                                                  ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero)),
                                      icon: const Icon(
                                        EvaIcons.edit,
                                        color: ColorTheme.primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          faq.deleteFaq(data.fid),
                                      icon: const Icon(
                                        EvaIcons.trash,
                                        color: Color.fromRGBO(245, 92, 81, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
