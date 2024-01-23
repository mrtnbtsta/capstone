import 'dart:async';
import 'dart:convert';
import 'package:capstone_project/models/lost_found_model.dart';
import 'package:capstone_project/models/usernotif_model.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_project/connection/api.dart';

class UserNotificationController {
  static Future<void> insertNotificationToUser(
      var uid, var gid, var gid1, String message) async {
    try {
      final response =
          await http.post(Uri.parse(API.insertNotificationToUserAPI), body: {
        "uid": uid.toString(),
        "gid": gid.toString(),
        "g_id": gid1.toString(),
        "message": message.toString(),
      });

      if (response.statusCode == 200) {
        // print("Success");
      } else {
        // print("Failed");
      }
    } catch (e) {
      //
    }
  }
}

class UserNotification {
  StreamController<List<UserNotificationModel>> readingStreamController =
      StreamController<List<UserNotificationModel>>.broadcast();

  Future<void> closeStream() => readingStreamController.close();

  void reOpenStream() => readingStreamController =
      StreamController<List<UserNotificationModel>>.broadcast();

  void getUserNotifactionData(int gid, int uid) async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(
            Uri.parse(API.displayUserNotificationData(gid, uid)),
            headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<UserNotificationModel> readings = jsonData
              .map<UserNotificationModel>(
                  (json) => UserNotificationModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }
}

class ClaimedNotification {
  StreamController<List<LostFoundModel>> readingStreamController =
      StreamController<List<LostFoundModel>>.broadcast();


  Future<void> closeStream() => readingStreamController.close();

   void displayLostFoundData() async {
    // List<LostFoundModel> data = <LostFoundModel>[];

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response =
            await http.get(Uri.parse(API.displayLostFoundClaimed), headers: {
          "Accept": "application/json",
        });

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          List<LostFoundModel> readings = jsonData.map<LostFoundModel>((json) {
            return LostFoundModel.fromJson(json);
          }).toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });

    // return data;
  }

   StreamController<List<LostFoundModel>> readingStreamController1 =
      StreamController<List<LostFoundModel>>.broadcast();


  Future<void> closeStream1() => readingStreamController1.close();

  void displayLostFoundClaimedData() async {
    // List<LostFoundModel> data = <LostFoundModel>[];

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (readingStreamController1.isClosed) return timer.cancel();
      try {
        final response =
            await http.get(Uri.parse(API.displayLostFoundClaimed1), headers: {
          "Accept": "application/json",
        });

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          List<LostFoundModel> readings = jsonData.map<LostFoundModel>((json) {
            return LostFoundModel.fromJson(json);
          }).toList();
          readingStreamController1.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });

    // return data;
  }

  void updateLostFoundCLaimSeen() async {
    try {
      final response = await http.get(
          Uri.parse(API.updateClaimSeenAPI1),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }

  
      
}
