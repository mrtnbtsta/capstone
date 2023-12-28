class ClaimModel {
  final int claimID;
  final String uName;
  final String image;
  ClaimModel({required this.claimID, required this.uName, required this.image});

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
        claimID: json["cid"], uName: json["uName"], image: json["claim_image"]);
  }
}
