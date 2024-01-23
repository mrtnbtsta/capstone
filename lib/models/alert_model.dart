class AlertModel {
  final int alertID;
  final String uName;
  final String address;
  final String profile;
  final double latitude;
  final double longitude;
  final String seen;

  AlertModel(
      {required this.alertID,
      required this.uName,
      required this.address,
      required this.profile,
      required this.latitude,
      required this.longitude,
      required this.seen});

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
      alertID: json["alertid"],
      uName: json["uName"],
      address: json["address"],
      profile: json["profile"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      seen: json["seen"]);
}
