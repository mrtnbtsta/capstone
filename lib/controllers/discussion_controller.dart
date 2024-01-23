// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/discussion_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';

class DiscussionController extends GetxController {
  RxList<DiscussionModel> dataModel = <DiscussionModel>[].obs;
  var currentPage = 1;

  // final ScrollController scrollController =
  //     ScrollController(keepScrollOffset: true);

  @override
  void onInit() {
    // getDiscussion();
    // paginateDiscussion();
    super.onInit();
  }

  Future<void> insertDiscussion(String name, String description,
      File? imageFile, BuildContext context) async {
    if (name.isEmpty || description.isEmpty) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "All fields are required to post discussion"));
    } else if (imageFile == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "Please select an image"));
    } else {
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.insertDiscussionAPI));
        var multiPartFile =
            await http.MultipartFile.fromPath("image", imageFile.path);
        request.fields["name"] = name.toString();
        request.fields["description"] = description.toString();
        request.files.add(multiPartFile);

        var streamReponse = await request.send();

        var response = await http.Response.fromStream(streamReponse);

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully posted"));
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "failed to post"));
        }
      } catch (e) {
        // if (kDebugMode) print(e.toString());
      }
    }
  }

  Future<List<DiscussionModel>> getDiscussionData() async {
    RxList<DiscussionModel> dataModel = <DiscussionModel>[].obs;
    try {
      final response = await http.get(Uri.parse(API.displayDiscussionAPI),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);

      for (var result in jsonData) {
        DiscussionModel model = DiscussionModel(
          id: result["id"],
          name: result["name"],
          time: result["time"],
          image: result["image"],
          description: result["description"],
        );
        dataModel.add(model);
      }
      update();
    } catch (e) {
      //
    }

    return dataModel;
  }

  void getDiscussion() async {
    final result = await getDiscussionData();
    if (result.isNotEmpty) {
      dataModel.value = result;
    }
  }
}
