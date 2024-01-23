import 'dart:async';
import 'dart:convert';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/alert_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AlertController extends GetxController {
  RxList<AlertModel> dataAlert = <AlertModel>[].obs;

  StreamController<List<AlertModel>> readingStreamController =
      StreamController<List<AlertModel>>.broadcast();

  void fetchAlertdata() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayAlertAPI),
            headers: {"Accept": "application"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<AlertModel> readings = jsonData
              .map<AlertModel>((json) => AlertModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  void updateAlertSeenData() async {
    try {
      final response = await http.get(Uri.parse(API.updateAlertSeenAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }
}
