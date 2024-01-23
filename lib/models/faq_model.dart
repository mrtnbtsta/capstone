class FaqsModel {
  final String title;
  final String content;
  final int fid;

  FaqsModel({required this.title, required this.content, required this.fid});

  factory FaqsModel.fromJson(Map<String, dynamic> json) => FaqsModel(
      title: json["title"], content: json["content"], fid: json["fid"]);
}
