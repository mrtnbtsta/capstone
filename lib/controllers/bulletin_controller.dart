// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/bulletin_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BulletinController extends GetxController {
  RxList<BulletinModel> dataModel = <BulletinModel>[].obs;

  Future<void> insertBulletinData(String title, String description, File? image,
      String? type, BuildContext context) async {
    if (title.isEmpty || description.isEmpty || type!.isEmpty) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "All fields are required to add bulletin"));
    } else if (image == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "Please select an image"));
    } else {
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.insertBulletinAPI));
        var multiPartFile =
            await http.MultipartFile.fromPath("image", image.path);
        request.fields["title"] = title.toString();
        request.fields["description"] = description.toString();
        request.fields["type"] = type.toString();
        request.files.add(multiPartFile);

        final response = await request.send();

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully added bulletin"));
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pushNamed(RouteName.dashboardBulletin);
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to add bulletin"));
        }
      } catch (e) {
        //
      }
    }
  }

  Future<List<BulletinModel>> filterBulletinData(String filter) async {
    RxList<BulletinModel> list = <BulletinModel>[].obs;
    final response = await http.get(Uri.parse(API.fillterBulletinData(filter)),
        headers: {"Accept": "application/json"});
    var jsonData = jsonDecode(response.body);
    for (var result in jsonData) {
      BulletinModel model = BulletinModel(
          id: result["id"],
          title: result["title"],
          image: result["image"],
          description: result["description"],
          type: result["type"]);
      list.add(model);
    }

    return list;
  }

  deleteBulletinData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteBulletinData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          var index = dataModel.indexWhere((element) => element.id == id);
          dataModel.removeAt(index);
          update();
        }
      }
    } catch (e) {
      //
    }
  }
}

class Bulletin {
  final StreamController<List<AllReports>> readiingStreamReports =
      StreamController<List<AllReports>>();

  Future<void> closeStream() => readiingStreamReports.close();

  void fetchAllReports() async {
    // List<AllReports> data = <AllReports>[];
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readiingStreamReports.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayUserAllReportsAPI),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<AllReports> readings = jsonData.map<AllReports>((json) {
            return AllReports.fromJson(json);
          }).toList();
          readiingStreamReports.sink.add(readings);
          // for (var result in jsonData) {
          //   AllReports news = AllReports(
          //       id: result["id"],
          //       title: result["title"],
          //       image: result["image"],
          //       description: result["description"]);
          //   data.add(news);
          //   // return BulletinNews.fromJson(result);
          // }
        }
      } catch (e) {
        //
      }
    });
    // return data;
  }
}
