import 'dart:convert';
import 'package:capstone_project/connection/api.dart';
import 'package:http/http.dart' as http;
import 'package:capstone_project/models/admin_model.dart';

class AdminController {
  static Future<List<AdminModel>> getAdminData() async {
    List<AdminModel> data = <AdminModel>[];
    try {
      final response = await http.get(Uri.parse(API.displayAdminAPI),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var result in jsonData) {
          AdminModel model =
              AdminModel(id: result["aid"], username: result["username"]);
          data.add(model);
        }
      } else {
        // print("Something went wrong");
      }
    } catch (e) {
      // print(e.toString());
    }
    // print(data.length);
    return data;
  }

  static Future<void> updateChatAdmin(var chatCID, String reply) async {
    final response = await http.post(Uri.parse(API.updateChatAdminAPI),
        body: {"reply": reply.toString(), "chatCID": chatCID.toString()});

    if (response.statusCode == 200) {
      // print("Success");
    } else {
      // print("Failed");
    }
  }
}
