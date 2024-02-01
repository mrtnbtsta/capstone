// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/report_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:art_sweetalert/art_sweetalert.dart';

class EmergencyController extends GetxController {
  RxList<EmergencyReportsModel> emergencyModel = <EmergencyReportsModel>[].obs;
  RxList<HazardReportsModel> hazardModel = <HazardReportsModel>[].obs;
  RxList<CrimeReportsModel> crimeModel = <CrimeReportsModel>[].obs;
  RxList<AllReports> allReportsModel = <AllReports>[].obs;

  static Future<void> insertReport(
      String? name,
      String? date,
      String? address,
      String? contact,
      String? typeOfReport,
      String? describeIncident,
      String? locationIncident,
      String? specify,
      String? type,
      File? image,
      int? uid,
      String? postStatus,
      String? monthText,
      // String? endDate,
      BuildContext context) async {
    if (name!.isEmpty ||
        date!.isEmpty ||
        address!.isEmpty ||
        contact!.isEmpty ||
        describeIncident!.isEmpty ||
        type!.isEmpty ||
        locationIncident!.isEmpty) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "Please fill up all the fields"));
    } else if (image == null) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "Oops...",
              text: "Please select an image"));
    } else {

      if(typeOfReport!.isNotEmpty){
        try {
          var request =
              http.MultipartRequest("POST", Uri.parse(API.insertReportAPI));
          var multiPartFile =
              await http.MultipartFile.fromPath("image", image.path);
          request.fields["name"] = name.toString();
          request.fields["date"] = date.toString();
          request.fields["address"] = address.toString();
          request.fields["contact"] = contact.toString();
          request.fields["typeOfReport"] = typeOfReport.toString();
          request.fields["describeIncident"] = describeIncident.toString();
          request.fields["locationIncident"] = locationIncident.toString();
          request.fields["specifyIncident"] = specify.toString();
          request.fields["type"] = type.toString();
          request.fields["uid"] = uid.toString();
          request.fields["post_status"] = postStatus.toString();
          request.fields["monthText"] = monthText.toString();
          // request.fields["endDate"] = endDate.toString();
          request.files.add(multiPartFile);

          final response = await request.send();

          if (response.statusCode == 200) {          
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "Success",
                      text: "Successfully send the report"));
                  Timer(const Duration(seconds: 2),
                  () => Navigator.of(context).popAndPushNamed(RouteName.home));

          } else {
            // print("failed");
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "Oops...",
                    text: "The report did not send successfully"));
          }
        } catch (e) {
          print(e.toString());
        }
      }else if(specify!.isNotEmpty){
        try {
          var request =
              http.MultipartRequest("POST", Uri.parse(API.insertReportAPI));
          var multiPartFile =
              await http.MultipartFile.fromPath("image", image.path);
          request.fields["name"] = name.toString();
          request.fields["date"] = date.toString();
          request.fields["address"] = address.toString();
          request.fields["contact"] = contact.toString();
          request.fields["typeOfReport"] = typeOfReport.toString();
          request.fields["describeIncident"] = describeIncident.toString();
          request.fields["locationIncident"] = locationIncident.toString();
          request.fields["specifyIncident"] = specify.toString();
          request.fields["type"] = type.toString();
          request.fields["uid"] = uid.toString();
          request.fields["post_status"] = postStatus.toString();
          request.files.add(multiPartFile);

          final response = await request.send();

          if (response.statusCode == 200) {
            
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.success,
                      title: "Success",
                      text: "Successfully send the report"));
                  Timer(const Duration(seconds: 2),
                  () => Navigator.of(context).popAndPushNamed(RouteName.home));

          } else {
            // print("failed");
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "Oops...",
                    text: "The report did not send successfully"));
          }
        } catch (e) {
          print(e.toString());
        }
      }else{
         ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Oops...",
            text: "If you did not choose one of the checkboxes please specify the incident"));
      }

      
    }
  }

   


  static Future<List<AllReports>> getAllReportsData() async {
    RxList<AllReports> data = <AllReports>[].obs;
    try {
      final response = await http.get(Uri.parse(API.displayAllReportsAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (var result in jsonData) {
          AllReports reports = AllReports(
              rid: result["rid"],
              typeOfReport: result["typeOfReport"],
              describeIncident: result["describeIncident"],
              locationIncident: result["locationIncident"],
              image: result["image"],
              name: result["name"],
              address: result["address"]);
          data.add(reports);
        }
      }
    } catch (e) {
      //
    }
    return data;
  }

  void getAllReports() async {
    final result = await getAllReportsData();
    if (result.isNotEmpty) {
      allReportsModel.value = result;
      update();
    }
  }

  deleteAllReportData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteEmergencyData(id)),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData["result"] == "success") {
          var index =
              allReportsModel.indexWhere((element) => element.rid == id);
          allReportsModel.removeAt(index);
          update();
          // print("Successfully deleted");
        } else {
          // print("failed to delete data");
        }
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}

Future<void> deleteAllReports(int id, BuildContext context) async {
  try {
    final response =
        await http.get(Uri.parse(API.deleteAllReportsAPIData(id)));

    if (response.statusCode == 200) {
         ArtDialogResponse response =
                await ArtSweetAlert.show(
                    barrierDismissible: false,
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        confirmButtonColor:
                            const Color.fromRGBO(
                                123, 97, 255, 1),
                        title: "Delete All Report",
                        showCancelBtn: true,
                        text: "Do you want to delete all your reports?",
                        confirmButtonText: "Confirm",
                        type:
                            ArtSweetAlertType.question));

          
            if (response == null) {
              return;
            }

            if (response.isTapConfirmButton) {
                ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                title: "Success",
                text: "Successfully deleted"));
                // Navigator.of(context).pop();
                return;
            }
      // return;
    }
  } catch (e) {
    print(e.toString()) ;
  }
}

class IncidentController {
  StreamController<List<EmergencyReportsModel>> readingStreamController =
      StreamController<List<EmergencyReportsModel>>();

  Future<void> closeStream() => readingStreamController.close();

  void allReportsData() async {
    // List<EmergencyReportsModel> data = <EmergencyReportsModel>[];

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayEmeregencyAPI),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);

          List<EmergencyReportsModel> readings =
              jsonData.map<EmergencyReportsModel>((json) {
            return EmergencyReportsModel.fromJson(json);
          }).toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });

    // for (var result in jsonData) {
    //   EmergencyReportsModel report = EmergencyReportsModel(
    //       rid: result["rid"],
    //       name: result["name"],
    //       address: result["address"],
    //       typeOfReport: result["typeOfReport"],
    //       describeIncident: result["describeIncident"],
    //       locationIncident: result["locationIncident"],
    //       image: result["image"]);
    //   data.add(report);
    // }
    // return data;
  }

  static Future<List<HazardReportsModel>> userFetchHazardData() async {
    List<HazardReportsModel> data = <HazardReportsModel>[];
    final response = await http.get(Uri.parse(API.displayHazardAPI),
        headers: {"Accept": "application/json"});
    final jsonData = jsonDecode(response.body);

    for (var result in jsonData) {
      HazardReportsModel report = HazardReportsModel(
          rid: result["rid"],
          name: result["name"],
          address: result["address"],
          typeOfReport: result["typeOfReport"],
          describeIncident: result["describeIncident"],
          locationIncident: result["locationIncident"],
          image: result["image"]);
      data.add(report);
    }
    return data;
  }

  static Future<List<CrimeReportsModel>> userFetchCrimeData() async {
    List<CrimeReportsModel> data = <CrimeReportsModel>[];
    final response = await http.get(Uri.parse(API.displayCrimeAPI),
        headers: {"Accept": "application/json"});
    final jsonData = jsonDecode(response.body);

    for (var result in jsonData) {
      CrimeReportsModel report = CrimeReportsModel(
          rid: result["rid"],
          name: result["name"],
          address: result["address"],
          typeOfReport: result["typeOfReport"],
          describeIncident: result["describeIncident"],
          locationIncident: result["locationIncident"],
          image: result["image"]);
      data.add(report);
    }

    return data;
  }
}

class Incident {
  StreamController<List<AllIncident>> readingStreamController =
      StreamController<List<AllIncident>>.broadcast();

  Future<void> closeStream() => readingStreamController.close();

  void getIncidentData() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.getDataAPI),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          List<AllIncident> readings = jsonData
              .map<AllIncident>((json) => AllIncident.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        }
      } catch (e) {
        //
      }
    });
  }

  void updateEmergencySeenData() async {
    try {
      final response = await http.get(Uri.parse(API.updateEmergencySeenAPI),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      //
    }
  }

  Future<void> updateNotification(var id) async {
    final response = await http.get(Uri.parse(API.updateNotificationData(id)),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {}
  }
}

class ReportStreamController {
  StreamController<List<ReportCommentModel>> readingStreamController =
      StreamController<List<ReportCommentModel>>.broadcast();

  Future<void> closeStream() => readingStreamController.close();

  Future<List<ReportDiscussionModel>> reportDiscussionCard(int id) async {
    try {
      final response = await http.get(
          Uri.parse(API.displayReportDataAPIData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return jsonData
            .map<ReportDiscussionModel>(
                (json) => ReportDiscussionModel.fromJson(json))
            .toList();
      } else {
        return throw Exception("Error");
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  void insertReportComment(String comment, int rid, int uid) async {
    try {
      final response =
          await http.post(Uri.parse(API.insertReportCommentAPI), body: {
        "comment": comment.trim().toString(),
        "rid": rid.toString(),
        "uid": uid.toString()
      });

      if (response.statusCode == 200) {
      } else {
        // print("What qwe");
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void displayReportCommentData(int id) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(
            Uri.parse(API.displayReportCommentDataAPIData(id)),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          // print(jsonData);
          List<ReportCommentModel> readings = jsonData
              .map<ReportCommentModel>(
                  (json) => ReportCommentModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);
        } else {
          // print("Error");
        }
      } catch (e) {
        // print(e.toString());
      }
    });
  }
}


class Emergency {

  StreamController<List<EmergencyReportsModel1>> readingStreamController =
    StreamController<List<EmergencyReportsModel1>>();


  Future<void> closeStream() => readingStreamController.close();

    //EMERGENCY REPORT
  void fetchEmergencyData() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async { 
      if(readingStreamController.isClosed) return timer.cancel();
      try {
      final response = await http.get(Uri.parse(API.displayEmeregencyAPI1),
          headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
          List<EmergencyReportsModel1> readings = jsonData
              .map<EmergencyReportsModel1>((json) => EmergencyReportsModel1.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);

      } else {
        //
      }
    } catch (e) {
      //
    }
    });
  }

  void deleteEmergencyReportData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteEmergencyData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {}
    } catch (e) {
      // print(e.toString());
    }
  }

    Future<void> updateEmergencyData(var id) async {
    try{
      final response = await http.get(Uri.parse(API.updateEmergencyData(id)));

      if (response.statusCode == 200) {}
    }catch(e){
      //
    }
  }

}

class Hazard {

  StreamController<List<HazardReportsModel>> readingStreamController =
    StreamController<List<HazardReportsModel>>();

   Future<void> closeStream() => readingStreamController.close();

    void fetchHazardData() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async { 
      if(readingStreamController.isClosed) return timer.cancel();
      try {
     final response = await http.get(Uri.parse(API.displayHazardAPI),
        headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

          List<HazardReportsModel> readings = jsonData
              .map<HazardReportsModel>((json) => HazardReportsModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);

      } else {
        //
      }
    } catch (e) {
      //
    }
    });

  }

  deleteHazardReportData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteHazardData(id)),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData["result"] == "success") {
          // print("Successfully deleted");
        } else {
          // print("failed to delete data");
        }
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> updateHazardData(var id) async {
    final response = await http.get(Uri.parse(API.updateHazardData(id)));

    if (response.statusCode == 200) {}
  }


}


class Crime {

   StreamController<List<CrimeReportsModel>> readingStreamController =
    StreamController<List<CrimeReportsModel>>();

    Future<void> closeStream() => readingStreamController.close();

        // CrimeReportsModel
    void fetchCrimeData() async {
      
      Timer.periodic(const Duration(seconds: 2), (timer) async { 
      if(readingStreamController.isClosed) return timer.cancel();
      try {
        final response = await http.get(Uri.parse(API.displayCrimeAPI),
        headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

          List<CrimeReportsModel> readings = jsonData
              .map<CrimeReportsModel>((json) => CrimeReportsModel.fromJson(json))
              .toList();

          readingStreamController.sink.add(readings);

      } else {
        //
      }
    } catch (e) {
      //
    }
    });

    }

  deleteCrimeReportData(int id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteCrimeData(id)),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonData["result"] == "success") {
          // print("Successfully deleted");
        } else {
          // print("failed to delete data");
        }
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> updateCrimeData(var id) async {
    final response = await http.get(Uri.parse(API.updateCrimeData(id)));

    if (response.statusCode == 200) {
    } else {
      // if (kDebugMode) {
      //   print("Failed Update");
      // }
    }
  }

}
