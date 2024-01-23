// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:capstone_project/models/admin_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_project/connection/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  StreamController<List<Message>> readingStreamcontroller =
      StreamController<List<Message>>();

  Future<void> closeStream() => readingStreamcontroller.close();

  void getMessageUserData(var userID, var adminID) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamcontroller.isClosed) return timer.cancel();
      try {
        final response = await http.get(
            Uri.parse(API.displayChatData(userID, adminID)),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<Message> readings =
              jsonData.map<Message>((json) => Message.fromJson(json)).toList();

          readingStreamcontroller.sink.add(readings);
        }
      } catch (e) {
        // print(e.toString());
      }
    });
  }

  Future<void> insertChatData(int fromID, int toID, String message) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Uri.parse(API.insertChatAPI), body: {
        "fromID": fromID.toString(),
        "toID": toID.toString(),
        "message": message.toString()
      });

      if (response.statusCode == 200) {
        // print("Success");
        // getMessageUserData(fromID, toID);
      } else {
        // print("failed");
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}

class ReceivedController extends GetxController {
  RxList<ReceivedMessage> data = <ReceivedMessage>[].obs;
  @override
  void onInit() {
    fetchMessage();
    super.onInit();
  }

  Future<List<ReceivedMessage>> fetchMessageData(var id, var id1) async {
    RxList<ReceivedMessage> data = <ReceivedMessage>[].obs;

    try {
      final response = await http.get(
          Uri.parse(API.displayReceivedAdminData(id, id1)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var result in jsonData) {
          ReceivedMessage message = ReceivedMessage(
              uName: result["uName"],
              message: result["message"],
              profile: result["profile"],
              cid: result["cid"],
              uid: result["uid"],
              aid: result["aid"]);
          data.add(message);
        }

        // print("Success");
      } else {
        // print("Failed");
      }
    } catch (e) {
      // print("Error");
    }

    return data;
  }

  Future<void> getAdminID() async {}

  void fetchMessage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int adminID = pref.getInt("adminID") ?? 0;
    int userID = pref.getInt("userID") ?? 0;

    // print("ID =: $id");
    var result = await ReceivedController().fetchMessageData(adminID, userID);
    if (result != null) {
      data.value = result;
      update();
    }
  }

  Future<void> updateReceivedMessage(var id) async {
    final response = await http.put(Uri.parse(API.updateReceivedAdminData(id)));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        var index = data.indexWhere((element) => element.cid == id);
        data.removeAt(index);
        // print("update");
      }
    } else {
      //
    }
  }
}
