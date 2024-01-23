class ClaimModels {
  final int claimID;
  final String uName;
  final String image;
  ClaimModels({required this.claimID, required this.uName, required this.image});

  factory ClaimModels.fromJson(Map<String, dynamic> json) {
    return ClaimModels(
        claimID: json["cid"], uName: json["uName"], image: json["claim_image"]);
  }
}
