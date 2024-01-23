import 'dart:async';
import 'dart:convert';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/claim_model.dart';
import 'package:http/http.dart' as http;

class ClaimController {
  StreamController<List<ClaimModels>> readingStreamController =
      StreamController<List<ClaimModels>>.broadcast();

  void fetchClaimData(int? id) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(
            Uri.parse(API.displayLostFoundClaimNotificationData(id)),
            headers: {"Accept": "application"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<ClaimModels> readings = jsonData
              .map<ClaimModels>((json) => ClaimModels.fromJson(json))
              .toList();
          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  static void updateGuardEmergencySeen() async {
    try {
      final response = await http.get(
          Uri.parse(API.updateClaimSeenAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }
}
