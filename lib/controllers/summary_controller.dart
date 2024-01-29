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

class SummaryUserController {

  static Future<List<SummaryUserModel>> getAll() async {
    try{
        final response = await http.get(Uri.parse(API.displayUserSummary), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<SummaryUserModel>((json) => SummaryUserModel.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<SummaryUserModel1>> getAll1() async {
    try{
        final response = await http.get(Uri.parse(API.displayUserSummary1), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<SummaryUserModel1>((json) => SummaryUserModel1.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

}

class MonthlyController {

  static Future<List<MonthlyModel>> getAllEmergency() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyReportEmergencyAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel>((json) => MonthlyModel.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<MonthlyModel1>> getAllEmergencyDataCount() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyEmergencyDataCountAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel1>((json) => MonthlyModel1.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<MonthlyModel>> getAllHazard() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyReportHazardAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel>((json) => MonthlyModel.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<MonthlyModel1>> getAllHazardDataCount() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyHazardDataCountAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel1>((json) => MonthlyModel1.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<MonthlyModel>> getAllCrime() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyReportHazardAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel>((json) => MonthlyModel.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

  static Future<List<MonthlyModel1>> getAllCrimeDataCount() async {
    try{
        final response = await http.get(Uri.parse(API.displayMonthlyCrimeDataCountAPI), headers: {"Accept": "application"});

        if(response.statusCode == 200){
           var jsonData = jsonDecode(response.body);

          return jsonData.map<MonthlyModel1>((json) => MonthlyModel1.fromJson(json)).toList();
      }else{
        return throw Exception("Error");
      }

    }catch(e){
      return throw Exception(e.toString());
    }
  }

}