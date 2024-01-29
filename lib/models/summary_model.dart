class SummaryModel {

  final String monthText;
  final DateTime startDate;
  final DateTime endDate;
  final int totalReport;
  SummaryModel({required this.monthText, required this.startDate, required this.endDate, required this.totalReport});


  factory SummaryModel.fromJson(Map<String, dynamic> json) => 
  SummaryModel(monthText: json["month_text"], 
  startDate: DateTime.parse(json["start_date"]), 
  endDate: DateTime.parse(json["end_date"]),
  totalReport: json["total"]);
}


class SummaryUserModel {
  final String monthText;
  final String typeOfReport;

  SummaryUserModel({required this.monthText, required this.typeOfReport});

  factory SummaryUserModel.fromJson(Map<String, dynamic> json) => SummaryUserModel(monthText: json["month_text"], typeOfReport: json["type"]);

}

class SummaryUserModel1 {
  final String typeOfReport;
  final int count;
  SummaryUserModel1({required this.typeOfReport, required this.count});

  factory SummaryUserModel1.fromJson(Map<String, dynamic> json) => SummaryUserModel1(typeOfReport: json["typeOfReport"], count: json["total_count"]);

}


class MonthlyModel {
  final String monthText;
  final String typeOfReport;

  MonthlyModel({required this.monthText, required this.typeOfReport});

  factory MonthlyModel.fromJson(Map<String, dynamic> json) => MonthlyModel(monthText: json["month_text"], typeOfReport: json["type"]);

}

class MonthlyModel1 {
  final String typeOfReport;
  final int count;
  MonthlyModel1({required this.typeOfReport, required this.count});

  factory MonthlyModel1.fromJson(Map<String, dynamic> json) => MonthlyModel1(typeOfReport: json["typeOfReport"], count: json["total_count"]);

}