class GuardModel {
  String? name;
  String? address;
  String? image;
  String? typeOfReport;
  String? locationIncident;
  String? describeIncident;
  String? status;
  String? resolve;
  int? uid;
  int? gid;

  GuardModel(
      {required this.name,
      required this.address,
      required this.image,
      required this.typeOfReport,
      required this.locationIncident,
      required this.describeIncident,
      required this.status,
      required this.resolve,
      required this.uid,
      required this.gid});

  factory GuardModel.fromJson(Map<String, dynamic> json) => GuardModel(
      name: json["name"],
      address: json["address"],
      image: json["image"],
      typeOfReport: json["type"],
      locationIncident: json["location"],
      describeIncident: json["describe"],
      status: json["status"],
      resolve: json["resolve"],
      uid: json["uid"],
      gid: json["gid"]);
}

class GuardModel1 {
  String? name;
  String? address;
  String? image;
  String? typeOfReport;
  String? locationIncident;
  String? describeIncident;
  String? status;
  String? resolve;
  DateTime? date;
  int? uid;
  int? gid;

  GuardModel1(
      {required this.name,
      required this.address,
      required this.image,
      required this.typeOfReport,
      required this.locationIncident,
      required this.describeIncident,
      required this.status,
      required this.resolve,
      required this.date,
      required this.uid,
      required this.gid});

  factory GuardModel1.fromJson(Map<String, dynamic> json) => GuardModel1(
      name: json["name"],
      address: json["address"],
      image: json["image"],
      typeOfReport: json["type"],
      locationIncident: json["location"],
      describeIncident: json["describe"],
      status: json["status"],
      resolve: json["resolve"],
      date: DateTime.parse(json["date"]),
      uid: json["uid"],
      gid: json["gid"]);
}

class GuardUserModel {
  int? gid;

  GuardUserModel({required this.gid});

  factory GuardUserModel.fromJson(Map<String, dynamic> json) =>
      GuardUserModel(gid: json["gid"]);
}
