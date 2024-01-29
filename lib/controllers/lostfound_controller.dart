// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/variables.dart';

class LostFoundController extends GetxController {
  RxList<LostFoundModel> dataModel = <LostFoundModel>[].obs;

  static Future<void> insertLostFoundImageData(
      String lostItem,
      String dateOfLost,
      String detailDescription,
      File? attachfile,
      int id,
      String? type,
      String? postStatus,
      BuildContext context) async {
    if (lostItem.isEmpty ||
        dateOfLost.isEmpty ||
        detailDescription.isEmpty ||
        attachfile == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "All fields are required to post"));
    } else {
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.insertLostFoundAPI));
        var multiPartFile =
            await http.MultipartFile.fromPath("image", attachfile.path);

        request.fields["lost_item"] = lostItem.toString();
        request.fields["date_of_lost"] = dateOfLost.toString();
        request.fields["uid"] = id.toString();
        request.fields["type"] = type.toString();
        request.fields["detail_description"] = detailDescription.toString();
        request.fields["post_status"] = postStatus.toString();
        request.files.add(multiPartFile);

        var streamResponse = await request.send();

        var response = await http.Response.fromStream(streamResponse);

        // var jsonData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully posted"));
          print('SUccess!!!!!!!!!');
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pushNamed(RouteName.lostFoundNews);
            currentIndex = 3;
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to post"));
        }
      } catch (e) {
        //
      }
    }
  }

  static Future<void> insertLostFoundVideoData(
      String lostItem,
      String dateOfLost,
      String detailDescription,
      File? attachVideo,
      int id,
      BuildContext context) async {
    if (lostItem.isEmpty ||
        dateOfLost.isEmpty ||
        detailDescription.isEmpty ||
        attachVideo == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "All fields are required to post"));
    } else {
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.insertLostFoundAPI1));
        var multiPartFile =
            await http.MultipartFile.fromPath("video", attachVideo.path);

        request.fields["lost_item"] = lostItem.toString();
        request.fields["date_of_lost"] = dateOfLost.toString();
        request.fields["uid"] = id.toString();
        request.fields["detail_description"] = detailDescription.toString();
        request.files.add(multiPartFile);

        var streamResponse = await request.send();

        var response = await http.Response.fromStream(streamResponse);

        // var jsonData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully posted"));
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pushNamed(RouteName.lostFoundNews);
            currentIndex = 3;
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to post"));
        }
      } catch (e) {
        //
      }
    }
  }

  // Future<List<LostFoundModel>> filterLostFoundData() async {
  //   // RxList<LostFoundModel> data = <LostFoundModel>[].obs;

  //   final response =
  //       await http.get(Uri.parse(API.displayAllLostFoundAPI), headers: {
  //     "Accept": "application/json",
  //   });

  //   if (response.statusCode == 200) {
  //     final List jsonData = jsonDecode(response.body);
  //     return jsonData.map((e) => LostFoundModel.fromJson(e)).toList();
  //   } else {
  //     return throw Exception("Error");
  //   }
  //   for (final result in jsonData) {
  //     // dataModel.remove(result);
  //     if (result["success_found"] == true) {
  //       LostFoundModel model = LostFoundModel(
  //           id: result["id"],
  //           uid: result["uid"],
  //           name: result["uName"],
  //           address: result["address"],
  //           image: result["image"],
  //           description: result["detail_description"],
  //           lostItem: result["lost_item"],
  //           dateOfLost: result["date_of_lost"]);
  //       data.add(model);
  //     } else {
  //       print("NO DATA GOKU FOUND");
  //     }
  //   }
  //   displayAllLostFoundAPI
  //   return data;
  // }
}

class LostFound {
  static Future<List<UserLostFoundVideo>> fetchLostFoundVideo() async {
    List<UserLostFoundVideo> data = <UserLostFoundVideo>[];
    final response = await http.get(Uri.parse(API.displayUserLostFoundAPI1),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body) as List;
      // return jsonData.map((e) => UserLostFoundVideo.fromJson(e)).toList();
      for (var result in jsonData) {
        UserLostFoundVideo user = UserLostFoundVideo(
            id: result["id"],
            uid: result["uid"],
            name: result["name"],
            image: ImagesAPI.getVideosUrl(result["image"]),
            lostItem: result["lost_item"],
            address: result["address"],
            type: result["type"],
            postStatus: result["post_status"]);
        data.add(user);
      }
    } else {
      return throw Exception("Error");
    }

    return data;
  }

  StreamController<List<UserLostFoundVideo>> readingStreamController =
      StreamController<List<UserLostFoundVideo>>();
  void fetchLostFoundVideo1() async {
    // List<UserLostFoundVideo> data = <UserLostFoundVideo>[];
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayUserLostFoundAPI1),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<UserLostFoundVideo> readings = jsonData
              .map<UserLostFoundVideo>(
                  (json) => UserLostFoundVideo.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        // print(e.toString());
      }
    });

    // return data;
  }

  void deleteLostFound(int id, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(API.deleteLostFoundAPIData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        //
      } else {
        //
      }
    } catch (e) {
      //
    }
  }
}

Future<List<ClaimModel>> getLostFoundData(int id) async {
  List<ClaimModel> data = <ClaimModel>[];

  final response = await http.get(Uri.parse(API.displayLostFoundData(id)),
      headers: {"Accept": "application/json"});

  try {
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (var result in jsonData) {
        ClaimModel model = ClaimModel(
            id: result["id"],
            lostItem: result["lost_item"],
            dateOfLost: result["date_of_lost"],
            detailDescription: result["detail_description"],
            image: result["image"]);
        data.add(model);
      }
    }
  } catch (e) {
    //
  }
  return data;
}

class LostFoundCommentController extends GetxController {
  RxList<LostFoundComment> lostFoundData = <LostFoundComment>[].obs;
  static Future<void> insertLostFoundComment(
      String comment, int? lfid, int? uid) async {
    try {
      final response = await http.post(Uri.parse(API.insertLostFoundComment),
          body: {
            "comment": comment.toString(),
            "lfid": lfid.toString(),
            "uid": uid.toString()
          });
      if (response.statusCode == 200) {
      } else {
        // print("Failed");
      }
    } catch (e) {
      //
    }
  }
}

class LostFoundSingleController {
  Future<List<UserLostFound1>> displayLostFoundSingleDataRecord(int id) async {
    List<UserLostFound1> data = [];
    try {
      final response = await http.get(
          Uri.parse(API.displayLostFoundSingleDataRecord(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        UserLostFound1 comment = UserLostFound1(
            name: jsonData["uName"],
            image: jsonData["image"],
            address: jsonData["address"],
            postStatus: jsonData["post_status"]);
        data.add(comment);
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      //
    }
    return data;
  }

  StreamController<List<LostFoundComment>> readingStreamController =
      StreamController<List<LostFoundComment>>.broadcast();

  void displayLostFoundCommentData(int id) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(
            Uri.parse(API.displayLostFoundCommentData(id)),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<LostFoundComment> readings = jsonData
              .map<LostFoundComment>((json) => LostFoundComment.fromJson(json))
              .toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }
}

class Claim {
  static Future<void> updateClaimStatus(
      int? id, File? image, BuildContext context) async {
    if (image == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.warning,
              title: "Oops...",
              text: "Please upload image file to claim the Lost item/pet"));
    } else {
      try {
        final response = await http.get(
            Uri.parse(API.updateLostFoundClaimData(id!)),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text:
                      "Success, Please wait for the admin to confirm the claiming request"));
        } else {
          // print("Failed");
        }
      } catch (e) {
        // print(e.toString());
      }
    }
  }

  static Future<void> updateClaimStatus1(int id, BuildContext context) async {
    try {
      final response = await http.get(
          Uri.parse(API.updateLostFoundClaimData1(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Claimed successfully"),)));
      } else {
        // print("Failed");
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  static Future<void> updateClaimStatus0(int id, BuildContext context) async {
    try {
      final response = await http.get(
          Uri.parse(API.updateLostFoundClaimData0(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
       
      } else {
        // print("Failed");
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  static Future<void> insertClaimData(
      File? image, int id, int uid, BuildContext context) async {
    try {
      if (image == null) {
        //
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.warning,
                title: "Oops...",
                text: "Please select an image"));
      } else {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.insertClaimAPI));
        request.fields["id"] = id.toString();
        request.fields["uid"] = uid.toString();
        var multiPartFile =
            await http.MultipartFile.fromPath("image", image.path);
        request.files.add(multiPartFile);

        var response = await request.send();

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully uploaded the proof image"));
        } else {
          // print("failed");
        }
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}
