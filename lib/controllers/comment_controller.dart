import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentController {
  // RxList<CommentModel> commentModel = <CommentModel>[].obs;

  Future<void> insertComment(
      {var discussionID, var userID, var content}) async {
    try {
      final response = await http.post(Uri.parse(API.insertCommentAPI), body: {
        "did": discussionID.toString(),
        "user_id": userID.toString(),
        "content": content.toString(),
      });

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }

  Future<List<CommentModel>> getCommentsData({var id}) async {
    List<CommentModel> commentModel = <CommentModel>[];
    try {
      final response = await http.get(Uri.parse(API.displayCommentData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // for (var result in jsonData) {
        for (var result in jsonData) {
          CommentModel comment = CommentModel(
              did: result["did"],
              name: result["uName"],
              profile: result["profile"],
              content: result["content"]);
          commentModel.add(comment);
        }
        // }
      }
    } catch (e) {
      //
    }
    // print("Length is: ${commentModel.length}");
    return commentModel;
  }
}

Future<void> deleteAllComments(int id, BuildContext context) async {
  try {
    final response =
        await http.delete(Uri.parse(API.deleteAllCommentAPIData(id)));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
                ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully deleted"));
    }
  } catch (e) {
    //
  }
}
