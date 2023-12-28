import 'dart:async';
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/faq_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FaqController {
  static Future<void> addFaq(
      String? title, String? content, BuildContext context) async {
    if (title!.isEmpty || content!.isEmpty) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "You need to fill up the fields to add FAQ"));
    } else {
      try {
        final response = await http.post(Uri.parse(API.insertFaqAPI),
            body: {"title": title.toString(), "content": content.toString()});

        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully added FAQ"));
          // ignore: use_build_context_synchronously
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context)
                .pushReplacementNamed(RouteName.dashboardEmergency);
          });
        }
      } catch (e) {
        //
      }
    }
  }

  static Future<List<FaqsModel>> displayFaqData() async {
    List<FaqsModel> dataList = [];
    try {
      final response = await http.get(Uri.parse(API.displayFaqAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var data in jsonData) {
          FaqsModel faq = FaqsModel(
              title: data["title"], content: data["content"], fid: data["fid"]);
          dataList.add(faq);
        }
      }
    } catch (e) {
      //
    }
    return dataList;
  }

  Future<List<FaqsModel>> displayFaqDataID(int id) async {
    List<FaqsModel> dataList = [];
    try {
      final response = await http.get(Uri.parse(API.displayFaqIDData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        FaqsModel faq = FaqsModel(
            title: jsonData["title"],
            content: jsonData["content"],
            fid: jsonData["fid"]);
        dataList.add(faq);
      }
    } catch (e) {
      //
    }
    return dataList;
  }

  StreamController<List<FaqsModel>> readingStreamController =
      StreamController<List<FaqsModel>>();

  void displayFaqDataAdmin() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayFaqAPI),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<FaqsModel> readings = jsonData
              .map<FaqsModel>((json) => FaqsModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  void deleteFaq(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteFaqData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {}
      }
    } catch (e) {
      //
    }
  }

  static void updateFaq(
      int id, BuildContext context, String? title, String? content) async {
    try {
      final response = await http.post(Uri.parse(API.updateFaqAPI), body: {
        "title": title.toString(),
        "content": content.toString(),
        "fid": id.toString()
      }, headers: {
        "Accept": "application/json"
      });

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Success",
                text: "Successfully updated"));
        // ignore: use_build_context_synchronously
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushNamed(RouteName.faq);
        });
      }
    } catch (e) {
      //
    }
  }
}
