class LostFoundModel {
  final int? id;
  final int? uid;
  final int? cid;
  final String? name;
  final String? address;
  final String? image;
  final String? description;
  final String? lostItem;
  final String? dateOfLost;
  final String? claimImage;
  final String? status;
  final String? statusClaim;

  LostFoundModel(
      {required this.id,
      required this.uid,
      required this.cid,
      required this.name,
      required this.address,
      required this.image,
      required this.description,
      required this.lostItem,
      required this.dateOfLost,
      required this.claimImage,
      required this.status,
      required this.statusClaim});

  static LostFoundModel fromJson(json) => LostFoundModel(
      id: json["id"],
      uid: json["uid"],
      cid: json["cid"],
      name: json["uName"],
      address: json["address"],
      image: json["image"],
      description: json["detail_description"],
      lostItem: json["lost_item"],
      dateOfLost: json["date_of_lost"],
      claimImage: json["claim_image"],
      status: json["status"],
      statusClaim: json["status_claim"]);
}

class LostFoundModel1 {
  final int? id;
  final int? uid;
  final int? cid;
  final String? name;
  final String? address;
  final String? image;
  final String? description;
  final String? lostItem;
  final String? dateOfLost;

  LostFoundModel1({
    required this.id,
    required this.uid,
    required this.cid,
    required this.name,
    required this.address,
    required this.image,
    required this.description,
    required this.lostItem,
    required this.dateOfLost,
  });

  static LostFoundModel1 fromJson(json) => LostFoundModel1(
        id: json["id"],
        uid: json["uid"],
        cid: json["cid"],
        name: json["uName"],
        address: json["address"],
        image: json["image"],
        description: json["detail_description"],
        lostItem: json["lost_item"],
        dateOfLost: json["date_of_lost"],
      );
}

class UserLostFound {
  final int id;
  final int uid;
  final String name;
  final String image;
  final String lostItem;
  final String address;
  final String type;
  final String postStatus;

  UserLostFound(
      {required this.id,
      required this.uid,
      required this.name,
      required this.image,
      required this.lostItem,
      required this.address,
      required this.type,
      required this.postStatus});

  factory UserLostFound.fromJson(Map<String, dynamic> json) {
    return UserLostFound(
        id: json["id"],
        uid: json["uid"],
        name: json["name"],
        image: json["image"],
        lostItem: json["lost_item"],
        address: json["address"],
        type: json["type"],
        postStatus: json["post_status"]);
  }
}

class UserLostFound1 {
  final String name;
  final String image;
  final String address;
  final String postStatus;

  UserLostFound1({
    required this.name,
    required this.image,
    required this.address,
    required this.postStatus
  });

  factory UserLostFound1.fromJson(Map<String, dynamic> json) {
    return UserLostFound1(
      name: json["name"],
      image: json["image"],
      address: json["address"],
      postStatus: json["post_status"]
    );
  }
}

class UserLostFoundVideo {
  final int id;
  final int uid;
  final String name;
  final String image;
  final String lostItem;
  final String address;
  final String type;
  final String postStatus;

  UserLostFoundVideo(
      {required this.id,
      required this.uid,
      required this.name,
      required this.image,
      required this.lostItem,
      required this.address,
      required this.type,
      required this.postStatus});

  factory UserLostFoundVideo.fromJson(Map<String, dynamic> json) {
    return UserLostFoundVideo(
        id: json["id"],
        uid: json["uid"],
        name: json["name"],
        image: json["image"],
        lostItem: json["lost_item"],
        address: json["address"],
        type: json["type"],
        postStatus: json["post_status"]);
  }
}

class ClaimModel {
  final int id;
  final String lostItem;
  final String dateOfLost;
  final String detailDescription;
  final String image;

  ClaimModel(
      {required this.id,
      required this.lostItem,
      required this.dateOfLost,
      required this.detailDescription,
      required this.image});
}

class LostFoundComment {
  final int id;
  final int uid;
  final String? comment;
  final String name;
  final String image;
  final String profile;

  LostFoundComment(
      {required this.id,
      required this.uid,
      required this.comment,
      required this.name,
      required this.image,
      required this.profile});

  factory LostFoundComment.fromJson(Map<String, dynamic> json) {
    return LostFoundComment(
        id: json["id"],
        uid: json["uid"],
        comment: json["comment"],
        name: json["name"],
        image: json["image"],
        profile: json["profile"]);
  }
}

class LostFoundComment1 {
  final String name;
  final String image;

  LostFoundComment1({
    required this.name,
    required this.image,
  });

  factory LostFoundComment1.fromJson(Map<String, dynamic> json) {
    return LostFoundComment1(
      name: json["name"],
      image: json["image"],
    );
  }
}

class LostFoundSingleRecord {
  final int id;
  final int uid;
  final String? comment;
  final String name;
  final String image;
  final String profile;

  LostFoundSingleRecord(
      {required this.id,
      required this.uid,
      required this.comment,
      required this.name,
      required this.image,
      required this.profile});
}
