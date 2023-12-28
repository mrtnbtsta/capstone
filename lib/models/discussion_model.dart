class DiscussionModel {
  final int id;
  final String name;
  final int time;
  final String image;
  final String description;

  DiscussionModel({
    required this.id,
    required this.name,
    required this.time,
    required this.image,
    required this.description,
  });

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
        id: json["id"],
        name: json["name"],
        time: json["time"],
        image: json["image"],
        description: json["description"]);
  }
}
