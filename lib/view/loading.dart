// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:capstone_project/view/routes.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController controller;
  bool seenOnBoard = false;
  dynamic currentUserName;
  dynamic currentAdminUsername;
  dynamic currentGuardUsername;
  double percentageProgressValue = 0;
  Future<void> onBoardScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    seenOnBoard = pref.getBool("seenOnBoard") ?? true;
    currentUserName = pref.getString("name");
    currentAdminUsername = pref.getString("username");
    currentGuardUsername = pref.getString("guardUser");
  }

  Future<void> percentage() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        percentageProgressValue = (i * 100 / 100);
      });
    }

    if (percentageProgressValue == 100 && seenOnBoard == true) {
      Navigator.of(context).pushReplacementNamed(RouteName.onBoard);
    } else {
      if (currentUserName != null && seenOnBoard == false) {
        // Navigator.of(context).pushReplacementNamed(RouteName.home);
      } else if (currentAdminUsername != null && seenOnBoard == false) {
        // Navigator.of(context).pushReplacementNamed(RouteName.dashboardEmergency);
        //
      }else if(currentGuardUsername != null && seenOnBoard == false){
        // Navigator.of(context).pushReplacementNamed(RouteName.guardHome);
      }
       else {
        Navigator.of(context).pushReplacementNamed(RouteName.login);
      }
    }
  }

  @override
  void initState() {
    onBoardScreen();
    percentage();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
    controller.reverse();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final loadingPercentage = 1000
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //spacing
            const SizedBox(height: 40),
            //Logo
              Container(
              alignment: Alignment.center,
              width: 90,
              height: 90,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text("XEV-CURITY",
                  style: TextStyle(
                      color: Color.fromRGBO(26, 23, 44, 1),
                      letterSpacing: 1.5,
                      wordSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 50)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: CircularStepProgressIndicator(
                totalSteps: 100,
                currentStep: percentageProgressValue.toInt(),
                stepSize: 10,
                selectedColor: ColorTheme.primaryColor,
                unselectedColor: const Color.fromRGBO(221, 221, 221, 1),
                padding: 0,
                width: 120,
                height: 120,
                selectedStepSize: 10,
                child:
                    Center(child: Text("${percentageProgressValue.toInt()}%")),
                roundedCap: (_, __) => true,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
