class AdminModel {
  final int? id;
  final String? username;

  AdminModel({required this.id, required this.username});
}

class Message {
  final int cid;
  final int aid;
  final int uid;
  final String message;
  final String uName;
  final String username;
  final String sentBy;
  final DateTime now;

  Message(
      {required this.cid,
      required this.aid,
      required this.uid,
      required this.message,
      required this.uName,
      required this.username,
      required this.sentBy,
      required this.now});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        cid: json["cid"],
        aid: json["aid"],
        uid: json["uid"],
        message: json["message"],
        uName: json["uName"],
        username: json["username"],
        sentBy: json["sentBy"],
        now: DateTime.parse(json["date"]));
  }
}

class MessageAdmin {
  final int cid;
  final int aid;
  final int uid;
  final String message;
  final String uName;
  final String username;
  final String sentBy;
  final DateTime now;

  MessageAdmin(
      {required this.cid,
      required this.aid,
      required this.uid,
      required this.message,
      required this.uName,
      required this.username,
      required this.sentBy,
      required this.now});

  factory MessageAdmin.fromJson(Map<String, dynamic> json) {
    return MessageAdmin(
        cid: json["cid"],
        aid: json["aid"],
        uid: json["uid"],
        message: json["message"],
        uName: json["uName"],
        username: json["username"],
        sentBy: json["sentBy"],
        now: DateTime.parse(json["date"]));
  }
}

class ReceivedMessage {
  final String uName;
  final String message;
  final String profile;
  final int cid;
  final int uid;
  final int aid;

  ReceivedMessage(
      {required this.uName,
      required this.message,
      required this.profile,
      required this.cid,
      required this.uid,
      required this.aid});
}
