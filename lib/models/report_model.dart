class EmergencyReportsModel {
  int rid;
  int rdid;
  int uid;
  String name;
  String address;
  String typeOfReport;
  String describeIncident;
  String locationIncident;
  String image;
  String postStatus;

  EmergencyReportsModel(
      {required this.rid,
      required this.rdid,
      required this.uid,
      required this.name,
      required this.address,
      required this.typeOfReport,
      required this.describeIncident,
      required this.locationIncident,
      required this.image,
      required this.postStatus});

  factory EmergencyReportsModel.fromJson(Map<String, dynamic> json) {
    return EmergencyReportsModel(
        rid: json["rid"],
        rdid: json["rdid"],
        uid: json["uid"],
        name: json["name"],
        address: json["address"],
        typeOfReport: json["typeOfReport"],
        describeIncident: json["describeIncident"],
        locationIncident: json["locationIncident"],
        image: json["image"],
        postStatus: json["post_status"]);
  }
}

class EmergencyReportsModel1 {
  int rid;
  String name;
  String address;
  String typeOfReport;
  String describeIncident;
  String locationIncident;
  String image;

  EmergencyReportsModel1(
      {required this.rid,
      required this.name,
      required this.address,
      required this.typeOfReport,
      required this.describeIncident,
      required this.locationIncident,
      required this.image});

  factory EmergencyReportsModel1.fromJson(Map<String, dynamic> json) {
    return EmergencyReportsModel1(
        rid: json["rid"],
        name: json["name"],
        address: json["address"],
        typeOfReport: json["typeOfReport"],
        describeIncident: json["describeIncident"],
        locationIncident: json["locationIncident"],
        image: json["image"]);
  }
}

class ReportDiscussionModel {
  final String name;
  final String image;
  final String postStatus;

  ReportDiscussionModel({required this.name, required this.image, required this.postStatus});

  factory ReportDiscussionModel.fromJson(Map<String, dynamic> json) {
    return ReportDiscussionModel(name: json["name"], image: json["image"], postStatus: json["post_status"]);
  }
}

class ReportCommentModel {
  final String name;
  final String image;
  final String comment;

  ReportCommentModel(
      {required this.name, required this.image, required this.comment});

  factory ReportCommentModel.fromJson(Map<String, dynamic> json) {
    return ReportCommentModel(
        name: json["name"], image: json["profile"], comment: json["comment"]);
  }
}

class HazardReportsModel {
  final int rid;
  final String name;
  final String address;
  final String typeOfReport;
  final String describeIncident;
  final String locationIncident;
  final String image;

  HazardReportsModel(
      {required this.rid,
      required this.name,
      required this.address,
      required this.typeOfReport,
      required this.describeIncident,
      required this.locationIncident,
      required this.image});

  static HazardReportsModel fromJson(json) => HazardReportsModel(
      rid: json["rid"],
      name: json["name"],
      address: json["address"],
      typeOfReport: json["typeOfReport"],
      describeIncident: json["describeIncident"],
      locationIncident: json["locationIncident"],
      image: json["image"]);
}

class CrimeReportsModel {
  final int rid;
  final String name;
  final String address;
  final String typeOfReport;
  final String describeIncident;
  final String locationIncident;
  final String image;

  CrimeReportsModel(
      {required this.rid,
      required this.name,
      required this.address,
      required this.typeOfReport,
      required this.describeIncident,
      required this.locationIncident,
      required this.image});

  static CrimeReportsModel fromJson(json) => CrimeReportsModel(
      rid: json["rid"],
      name: json["name"],
      address: json["address"],
      typeOfReport: json["typeOfReport"],
      describeIncident: json["describeIncident"],
      locationIncident: json["locationIncident"],
      image: json["image"]);
}

class AllIncident {
  final String seen;
  final String name;
  final String address;
  final int rid;
  final int uid;
  final String image;

  AllIncident(
      {required this.seen,
      required this.name,
      required this.address,
      required this.rid,
      required this.uid,
      required this.image});

  factory AllIncident.fromJson(Map<String, dynamic> json) => AllIncident(
      seen: json["seen"],
      name: json["name"],
      address: json["address"],
      rid: json["rid"],
      uid: json["uid"],
      image: json["image"]);
}

class AllReports {
  final int rid;
  final String typeOfReport;
  final String describeIncident;
  final String locationIncident;
  final String image;
  final String name;
  final String address;

  AllReports(
      {required this.rid,
      required this.typeOfReport,
      required this.describeIncident,
      required this.locationIncident,
      required this.image,
      required this.name,
      required this.address});
}
