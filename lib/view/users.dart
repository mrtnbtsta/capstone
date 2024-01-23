import 'dart:io';
import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/controllers/admin_controller.dart';
import 'package:capstone_project/models/admin_model.dart';
import 'package:capstone_project/sidebar.dart';
import 'package:capstone_project/view/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:capstone_project/variables.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const Sidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Platform.isAndroid
                          ? const Icon(EvaIcons.arrow_back,
                              color: ColorTheme.primaryColor)
                          : const Icon(CupertinoIcons.arrow_left,
                              color: ColorTheme.primaryColor),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed("Users"),
                          icon: const Icon(EvaIcons.message_circle,
                              color: ColorTheme.primaryColor),
                        ),
                        IconButton(
                          onPressed: () => {},
                          icon: const Icon(EvaIcons.bell,
                              color: ColorTheme.primaryColor),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("ADMIN",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: ColorTheme.secondaryColor,
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<AdminModel>>(
                  future: AdminController.getAdminData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(235, 235, 235, 1),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(211, 210, 210, 1),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: Offset(0, 3))
                                ]),
                            child: ListTile(
                              leading: const Icon(
                                EvaIcons.person,
                                size: 15,
                                color: Color.fromRGBO(123, 97, 255, 1),
                              ),
                              title: Text(
                                data.username.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                    wordSpacing: 0.5),
                              ),
                              trailing: const Icon(EvaIcons.arrow_right,
                                  color: Color.fromRGBO(123, 97, 255, 1)),
                              onTap: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setInt(
                                    "userID", pref.getInt("uid")!.toInt());
                                pref.setInt("adminID", data.id!.toInt());
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(PageRouteBuilder(pageBuilder:(context, animation, secondaryAnimation) => Chat(
                                          userID: pref.getInt("uid")!.toInt(),
                                          adminID: data.id!.toInt(),
                                        ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero));
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(color: ColorTheme.primaryColor,),
                      );
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
