import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:capstone_project/connection/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:capstone_project/variables.dart';

class UserAPI {
  // ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

  static void registerWithImageController(
      String? name,
      String? address,
      String? email,
      String? contact,
      String? password,
      String? confirmPassword,
      String? loginType,
      File? imageFile,
      BuildContext context) async {
    try {
      // imageFile ??= File(imageFile!.path);
      if (name!.isEmpty ||
          address!.isEmpty ||
          email!.isEmpty ||
          contact!.isEmpty ||
          loginType!.isEmpty ||
          password!.isEmpty) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "All fields are required"));
      } else if (!email.toString().contains("@") ||
          !email.toString().contains(".com")) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Invalid email"));
      } else if (password.length < 4) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Password is too short"));
      } else if (confirmPassword!.length < 4) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Confirm password is too short"));
      } else if (password != confirmPassword) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Password does not match"));
      } else {
        var request = http.MultipartRequest("POST", Uri.parse(API.registerAPI));
        var multiPartFile =
            await http.MultipartFile.fromPath("image", imageFile!.path);
        request.fields["name"] = name.toString();
        request.fields["address"] = address.toString();
        request.fields["email"] = email.toString();
        request.fields["contact"] = contact.toString();
        request.fields["password"] = password.toString();
        request.fields["loginType"] = loginType.toString();
        request.files.add(multiPartFile);
        var response = await request.send();

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully registered an account"));
          Timer(const Duration(seconds: 1), () {
            Navigator.of(context).pushNamed(RouteName.login);
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to register an account"));
        }
      }
    } catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.question,
              title: "Oops...",
              text: "${e.toString()} :("));
    }
  }

  static void registerWithoutImageController(
      String? name,
      String? address,
      String? email,
      String? contact,
      String? password,
      String? confirmPassword,
      String? loginType,
      BuildContext context) async {
    try {
      if (name!.isEmpty ||
          address!.isEmpty ||
          email!.isEmpty ||
          contact!.isEmpty ||
          loginType!.isEmpty ||
          password!.isEmpty) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "All fields are required"));
      } else if (!email.toString().contains("@") ||
          !email.toString().contains(".com")) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Invalid email"));
      } else if (password.length < 4) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Password is too short"));
      } else if (confirmPassword!.length < 4) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Confirm password is too short"));
      } else if (password != confirmPassword) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Password does not match"));
      } else {
        final response = await http.post(Uri.parse(API.register1API), body: {
          "name": name.toString(),
          "address": address.toString(),
          "email": email.toString(),
          "contact": contact.toString(),
          "password": password.toString(),
          "loginType": loginType.toString(),
          "image": ""
        });

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully registered an account"));
          Timer(const Duration(seconds: 1), () {
            Navigator.of(context).pushNamed(RouteName.login);
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to register an account"));
        }
      }
    } catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.question,
              title: "Oops...",
              text: "${e.toString()} :("));
    }
  }

  static Future<void> userLoginController(String? email, String? password,
      String? loginType, BuildContext context) async {
    try {
      var response = await http.post(Uri.parse(API.userLoginAPI), body: {
        "loginType": loginType.toString(),
        "email": email.toString(),
        "password": password.toString(),
      }, headers: {
        "Accept": "application/json"
      });

      //status code == 200 success
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["all_fields"] == true) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "All fields are empty"));
        } else {
          if (jsonData["success"] == "user") {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.success,
                    title: "Success",
                    text: "Successfully logged in"));
            setUserProfiledata(jsonData["uid"], jsonData["uName"],
                jsonData["address"], jsonData["contact"]);
            Timer(const Duration(seconds: 2), () {
              currentIndex = 0;
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed(RouteName.home);
            });
          } else {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "Oops...",
                    text: "Wrong credentials"));
          }
        }
      } else {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Error"));
      }
    } catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.question,
              title: "Oops...",
              text: e.toString()));
    }
  }

  static Future<void> adminLoginController(String? username, String? password,
      String? loginType, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      var response = await http.post(Uri.parse(API.adminLoginAPI), body: {
        "loginType": loginType.toString(),
        "username": username.toString(),
        "password": password.toString(),
      }, headers: {
        "Accept": "application/json"
      });

      //status code == 200 success
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["all_fields"] == true) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "All fields are empty"));
        } else {
          if (jsonData["success"] == "admin") {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.success,
                    title: "Success",
                    text: "Successfully logged in"));
            pref.setInt("aid", jsonData["aid"]);
            // pref.setString("username", jsonData["username"]);
            pref.setString("username", jsonData["username"]);
            Timer(const Duration(seconds: 2), () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context)
                  .pushReplacementNamed(RouteName.dashboardEmergency);
            });
          } else {
            ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                    type: ArtSweetAlertType.danger,
                    title: "Oops...",
                    text: "Wrong credentials"));
          }
        }
      } else {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Oops...",
                text: "Failed to login an Account"));
      }
    } catch (e) {
      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.question,
              title: "Oops...",
              text: e.toString()));
    }
  }

  static Future<void> updateProfileCredentials(
      int? uid,
      String? name,
      String? address,
      String? email,
      String? contact,
      String? password,
      File? imageFile,
      BuildContext context) async {
    if (name!.isNotEmpty &&
        address!.isNotEmpty &&
        email!.isNotEmpty &&
        contact!.isNotEmpty &&
        password!.isNotEmpty) {
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(API.updateUserData(uid)));
        var multiPartFile =
            await http.MultipartFile.fromPath("image", imageFile!.path);
        request.fields["name"] = name.toString();
        request.fields["address"] = address.toString();
        request.fields["email"] = email.toString();
        request.fields["contact"] = contact.toString();
        request.fields["password"] = password.toString();
        request.files.add(multiPartFile);

        final response = await request.send();

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully updated"));
          currentIndex = 0;
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamed(RouteName.home);
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to update"));
        }
      } catch (e) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Server Problem",
                text: e.toString()));
      }
    }
  }

  static Future<void> updateProfileWithoutImageCredentials(
      int? uid,
      String? name,
      String? address,
      String? email,
      String? contact,
      String? password,
      BuildContext context) async {
    if (name!.isNotEmpty &&
        address!.isNotEmpty &&
        email!.isNotEmpty &&
        contact!.isNotEmpty &&
        password!.isNotEmpty) {
      try {
        final response =
            await http.post(Uri.parse(API.updateUserData(uid)), body: {
          "name": name.toString(),
          "address": address.toString(),
          "email": email.toString(),
          "contact": contact.toString(),
          "password": password.toString()
        });

        if (response.statusCode == 200) {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  title: "Success",
                  text: "Successfully updated"));
          currentIndex = 0;
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamed(RouteName.home);
          });
        } else {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Oops...",
                  text: "Failed to update"));
        }
      } catch (e) {
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Server Problem",
                text: e.toString()));
      }
    }
  }

  static Future<Users> updateCurrentUserData(dynamic id) async {
    try {
      final response = await http.get(Uri.parse(API.getUserData(id)),
          headers: {"Accept": "application/json"});

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Users.fromJson(result[0]);
      }
    } catch (e) {
      //
    }
    return throw Exception("Something went wrong with the data retrieving");
  }

  static void deleteAllUsers(BuildContext context, int? id) async {
    try {
      final response = await http.get(Uri.parse(API.deleteUsersAPIData(id)),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          // print("Success");
        }
      } else {
        // print("Failed");
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}

class UserController {
  static Future<List<UserModel>> getUserData() async {
    List<UserModel> data = <UserModel>[];
    try {
      final response = await http.get(Uri.parse(API.displayUserAPI),
          headers: {"Accept": "application/json"});

      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var result in jsonData) {
          UserModel model = UserModel(id: result["uid"], name: result["uName"]);
          data.add(model);
        }
      } else {
        //
      }
    } catch (e) {
      // print(e.toString());
    }
    // print(data.length);
    return data;
  }

  static Future<void> insertAlert(
      var userid, double? latitude, double? longitude) async {
    final response = await http.post(Uri.parse(API.insertAlertAPI), body: {
      "userid": userid.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    });
    if (response.statusCode == 200) {
      // if (kDebugMode) {
      //   print("success");
      // }
    } else {
      // if (kDebugMode) {
      //   print("failed");
      // }
    }
  }
}

void setUserProfiledata(var uid, var name, var address, var contact) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setInt("uid", uid);
  pref.setString("name", name);
  pref.setString("address", address);
  pref.setString("contact", contact);
}
