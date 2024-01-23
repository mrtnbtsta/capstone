import 'dart:convert';

import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/models/summary_model.dart';
import 'package:http/http.dart' as http;

class SummaryController {

    static Future<List<SummaryModel>> getAll() async {

      try{
      final response = await http.get(Uri.parse(API.displayAdminSummaryAPI), headers: {"Accept": "application"});

      if(response.statusCode == 200){
        var jsonData = jsonDecode(response.body);

        return jsonData.map<SummaryModel>((json) => SummaryModel.fromJson(json)).toList();

      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }

    }


    


}