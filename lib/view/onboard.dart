
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:capstone_project/onboard_model.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  dynamic isLastPage;
  late PageController controller;

  Future<void> seenBoard() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("seenOnBoard", false);
  }

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Step> getSteps() => [
        Step(
            title: const Text("Safety",
                style: TextStyle(
                    color: Color.fromRGBO(26, 23, 44, 1),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
            content: const SizedBox.shrink(),
            state: currentIndex >= 0 ? StepState.complete : StepState.indexed,
            isActive: currentIndex >= 0),
        Step(
            title: const Text("Peace",
                style: TextStyle(
                    color: Color.fromRGBO(26, 23, 44, 1),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
            content: const SizedBox.shrink(),
            state: currentIndex >= 1 ? StepState.complete : StepState.indexed,
            isActive: currentIndex >= 1),
        Step(
            title: const Text("Community",
                style: TextStyle(
                    color: Color.fromRGBO(26, 23, 44, 1),
                    letterSpacing: 1.5,
                    wordSpacing: 0.5)),
            content: const SizedBox.shrink(),
            state: currentIndex >= 2 ? StepState.complete : StepState.indexed,
            isActive: currentIndex >= 2),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                width: 60,
                height: 60,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("XEV-CURITY",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 30, letterSpacing: 1)),
                    Text("SAFETY AND CONNECTION",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 15, letterSpacing: 1.5)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 72,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color.fromRGBO(235, 235, 235, 1),
                ),
                child: Stepper(
                  elevation: 0,
                  connectorColor: MaterialStateColor.resolveWith(
                      (states) => ColorTheme.secondaryColor),
                  connectorThickness: 2,
                  currentStep: currentIndex,
                  controlsBuilder: (context, details) {
                    return const SizedBox.shrink();
                  },
                  type: StepperType.horizontal,
                  steps: getSteps(),
                ),
              ),
            ),
            // const SizedBox(height: 25),
            Expanded(
              child: PageView.builder(
                itemCount: contentsBoarding.length,
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemBuilder: (context, i) {
                  final content = contentsBoarding[i];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 120,
                          backgroundImage: AssetImage(content.image.toString()),
                        ),
                        Container(
                          padding:  const EdgeInsets.only(top: 4),
                          child: Text(content.title.toString(),
                              style: const TextStyle(
                                  color: Color.fromRGBO(26, 23, 44, 1),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // const SizedBox(height: 100),
            SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const WormEffect(
                    dotColor: Color.fromRGBO(26, 23, 44, 1),
                    activeDotColor: ColorTheme.secondaryColor,
                    radius: 32)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contentsBoarding.length,
                    itemBuilder: (_, i) {
                      final content = contentsBoarding[i];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(content.stepperTitle.toString(),
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(26, 23, 44, 1),
                                            letterSpacing: 1.5,
                                            wordSpacing: 0.5))),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 2,
                                  decoration: BoxDecoration(
                                      color: currentIndex == i
                                          ? ColorTheme.secondaryColor
                                          : Colors.transparent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (currentIndex < getSteps().length - 1) {
                      setState(() {
                        currentIndex += 1;
                        controller.animateToPage(controller.page!.toInt() + 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      });
                    } else {
                      isLastPage = getSteps().length - 1;
                      //if we are in the last page navigate to the home screen
                      if (isLastPage == 2) {
                        seenBoard();
                        Navigator.of(context).popAndPushNamed(RouteName.login);
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                        color: ColorTheme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(right: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("NEXT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1.5,
                                wordSpacing: 0.5)),
                        Icon(
                          EvaIcons.arrow_right,
                          size: 20,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
