import 'dart:io';
import 'package:capstone_project/controllers/faq_controller.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:capstone_project/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:readmore/readmore.dart';
import 'package:capstone_project/models/faq_model.dart';

class HelpFaq extends StatefulWidget {
  const HelpFaq({super.key});

  @override
  State<HelpFaq> createState() => _HelpFaqState();
}

class _HelpFaqState extends State<HelpFaq> {
  List<FaqsModel> faq = [];
  List<FaqsModel> foundSearch = <FaqsModel>[];

  @override
  void initState() {
    FaqController.displayFaqData().then((value) {
      setState(() {
        faq.addAll(value);
      });
      foundSearch = faq;
    });
    super.initState();
  }

  void filterSearch(String text) {
    List<FaqsModel> result = [];
    if (text.isEmpty) {
      result = faq;
    } else {
      result = faq
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSearch = result;
    });
  }

  bool isFaqOpen = false;
  int currentIndex = 0;
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      drawer: const Sidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: foundSearch.length > 3
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
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
                          : const Icon(CupertinoIcons.barcode,
                              color: ColorTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topCenter,
                child: const Text("FAQ",
                    style: TextStyle(
                        color: ColorTheme.secondaryColor,
                        letterSpacing: 1.5,
                        wordSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 229, 229, 1),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        color: const Color.fromARGB(255, 200, 203, 206)
                            .withOpacity(0.5),
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    shape: BoxShape.rectangle),
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: TextFormField(
                  controller: search,
                  onChanged: (value) => filterSearch(value),
                  decoration: const InputDecoration(
                      hintText: "Search question...",
                      prefixIcon: Icon(EvaIcons.search),
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              const SizedBox(height: 30),
              faqCards()
            ],
          ),
        ),
      ),
    );
  }

  Widget faqCards() {
    return Column(
      children: [
        for (int i = 0; i < foundSearch.length; i++) ...[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 24, right: 24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromRGBO(219, 219, 238, 1)
                          .withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3))
                ]),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(foundSearch[i].title.toString(),
                                softWrap: false,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: ColorTheme.secondaryColor,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                currentIndex = i;
                                isFaqOpen = !isFaqOpen;
                              });
                            },
                            icon: Icon(
                                currentIndex == i && isFaqOpen
                                    ? EvaIcons.arrow_down
                                    : EvaIcons.arrow_right,
                                color: ColorTheme.secondaryColor),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: const Color.fromRGBO(143, 143, 156, 1)
                          .withOpacity(0.1),
                      thickness: 2,
                    ),
                    currentIndex == i && isFaqOpen
                        ? ReadMoreText(
                            foundSearch[i].content.toString(),
                            trimLines: 2,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            lessStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20)
        ]
      ],
    );
  }
}
