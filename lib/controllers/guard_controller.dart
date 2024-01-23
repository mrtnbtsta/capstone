// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/models/guard_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_project/connection/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuardAPI {
  StreamController<List<GuardModel>> readingStreamController =
      StreamController<List<GuardModel>>();

  Future<void> closeStream() => readingStreamController.close();

  static void userGuardController(String? username, String? password,
      String? loginType, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(API.userGuardAPI), body: {
        "loginType": loginType.toString(),
        "username": username.toString(),
        "password": password.toString(),
      }, headers: {
        "Accept": "application/json"
      });

      //status code == 200 success
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["all_fields"] == true) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "All fields are empty"));
        } else {
          if (jsonData["success"] == "guard") {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.success,
                    title: "Success",
                    text: "Successfully logged in"));
            pref.setString("guardUser", jsonData["guardUser"]);
            pref.setInt("gid", jsonData["gid"]);
            Timer(const Duration(seconds: 2), () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed(RouteName.guardHome);
            });
          } else {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "Oops...",
                    text: "Wrong credentials"));
          }
        }
      } else {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Failed to login an Account"));
      }
    } catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.question,
              title: "Oops...",
              text: e.toString()));
    }
  }

  static void updateGuardEmergency1(int gid) async {
    try {
      final response = await http.get(
          Uri.parse(API.updateGuardEmergencyData1(gid)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {}
      }
    } catch (e) {
      //
    }
  }

  static void updateGuardEmergency0(int gid) async {
    try {
      final response = await http.get(
          Uri.parse(API.updateGuardEmergencyData0(gid)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {}
      }
    } catch (e) {
      //
    }
  }

  static void updateGuardEmergencySeen() async {
    try {
      final response = await http.get(
          Uri.parse(API.updateGuardEmergencySeenAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }

  static void insertGuardEmergency(int rid) async {
    try {
      final response =
          await http.post(Uri.parse(API.insertGuardEmergencyAPI), body: {
        "rid": rid.toString(),
      });

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      //
    }
  }

  void displayGuardEmergency() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayGuardEmergencyAPI),
            headers: {"Acceept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<GuardModel> readings = jsonData
              .map<GuardModel>((json) => GuardModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  static Future<List<GuardModel1>> displayGuardEmergency1() async {
    // List<GuardModel> data = [];
    try {
      final response = await http.get(Uri.parse(API.displayGuardEmergencyAPI1),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return jsonData
            .map<GuardModel1>((json) => GuardModel1.fromJson(json))
            .toList();
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }
}

class GuardUserAPI {
  static Future<List<GuardUserModel>> displayGuardUserData() async {
    try {
      final response = await http.get(Uri.parse(API.displayGuardUserAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return jsonData
            .map<GuardUserModel>((json) => GuardUserModel.fromJson(json))
            .toList();
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }
}
