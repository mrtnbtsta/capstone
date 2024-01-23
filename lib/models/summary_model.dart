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