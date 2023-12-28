import 'dart:io';

import 'package:capstone_project/admin/chat_admin.dart';
import 'package:capstone_project/admin_sidebar.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:capstone_project/variables.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  UserAdminState createState() => UserAdminState();
}

class UserAdminState extends State<UserAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AdminSidebar(),
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
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: Platform.isAndroid
                            ? const Icon(EvaIcons.menu,
                                color: Color.fromRGBO(123, 97, 255, 1))
                            : const Icon(CupertinoIcons.bars,
                                color: Color.fromRGBO(123, 97, 255, 1)),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     IconButton(
                    //       onPressed: () => {},
                    //       icon: const Icon(EvaIcons.bell,
                    //           color: Color.fromRGBO(123, 97, 255, 1)),
                    //     )
                    //   ],
                    // )
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("USERS",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<UserModel>>(
                  future: UserController.getUserData(),
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
                                data.name.toString(),
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
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ChatAdmin(
                                            userID: data.id,
                                            adminID:
                                                pref.getInt("aid")!.toInt()),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero));
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
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
