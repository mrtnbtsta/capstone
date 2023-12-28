class Users {
  final int id;
  final String uName;
  final String address;
  final String email;
  final String contact;
  final String password;
  final String profile;

  Users(
      {required this.id,
      required this.uName,
      required this.address,
      required this.email,
      required this.contact,
      required this.password,
      required this.profile});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
      id: json["uid"],
      uName: json["uName"],
      address: json["address"],
      email: json["email"],
      contact: json["contact"],
      password: json["password"],
      profile: json["profile"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": uName,
        "address": address,
        "email": email,
        "contact": contact,
        "password": password,
        "profile": profile
      };
}

class UserModel {
  final int id;
  final String name;

  UserModel({required this.id, required this.name});
}
