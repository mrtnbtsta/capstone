class UserNotificationModel {
  final String username;
  final String message;
  final String isResolved;
  final int gid;
  final String? type;
  final String? image;
  final String? name;
  final DateTime? date;

  UserNotificationModel(
      {required this.username,
      required this.message,
      required this.isResolved,
      required this.gid,
      this.type,
      this.image,
      this.name,
      this.date});

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
          username: json["username"],
          message: json["message"],
          isResolved: json["resolve"],
          gid: json["gid"],
          type: json["type"].toString().isNotEmpty ? json["type"] : "",
          image: json["image"].toString().isNotEmpty ? json["image"] : "",
          name: json["name"].toString().isNotEmpty ? json["name"] : "",
          date: DateTime.parse(json["resolveDate"]));
}
