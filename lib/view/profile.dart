import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/theme/colors.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic uid;
  String? name;
  String? address;
  String? email;
  String? contact;
  String? password;
  String? profile;

  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var contactController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> getCurrentUsersCredentials() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getInt("uid");

    // setState(() {
    UserAPI.updateCurrentUserData(uid).then((value) {
      setState(() {
        name = value.uName.toString();
        address = value.address.toString();
        email = value.email.toString();
        contact = value.contact.toString();
        password = value.password.toString();
        profile = value.profile.toString();
        nameController.text = name.toString();
        addressController.text = address.toString();
        emailController.text = email.toString();
        contactController.text = contact.toString();
        passwordController.text = password.toString();
      });
    });
  }

  bool passwordObsecureText = true;

  @override
  void initState() {
    getCurrentUsersCredentials();

    // print(image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(EvaIcons.arrow_back, color: ColorTheme.secondaryColor,),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          title: const Text("PROFILE",
              style: TextStyle(
                  color: ColorTheme.secondaryColor,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700)),
        ),
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //HEADER
                const SizedBox(height: 20),

                Stack(
                    // fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 1))
                            ]),
                        child: Center(
                          child: profile.toString() == "default"
                              ? Container(
                                  width: 140,
                                  height: 140,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/default_profile.jpg"),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  width: 140,
                                  height: 140,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            ImagesAPI.getProfileUrl(
                                                profile.toString()),
                                          ))),
                                ),
                        ),
                      ),
                    ]),

                //SPACING
                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Basic Details",
                      style: TextStyle(
                          color: Color.fromRGBO(143, 143, 156, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                //FORMS

                //Full name
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Name",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),

                //FullName field
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: TextFormField(
                    readOnly: true,
                    controller: nameController,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: const InputDecoration(
                        hintText: "Your full name*",
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(143, 143, 156, 1)),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),

                //ADDRESS
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Address",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),

                //ADDRESS field
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: TextFormField(
                    readOnly: true,
                    controller: addressController,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: const InputDecoration(
                        hintText:
                            "Blk 12 Lot 10/12 Michael St. Xevera Tabun Xevera Mabalcat Pampanga",
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(143, 143, 156, 1)),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),

                //EMAIL
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Email Address",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),

                //EMAIL field
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: TextFormField(
                    readOnly: true,
                    controller: emailController,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: const InputDecoration(
                        hintText: "example@gmail.com",
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(143, 143, 156, 1)),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),

                //PHONE #
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Phone Number",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),

                //PHONE # field
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: TextFormField(
                    readOnly: true,
                    controller: contactController,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: const InputDecoration(
                        hintText: "(+63) 123-456-789",
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(143, 143, 156, 1)),
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),

                //Password
                const Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text("Password",
                      style: TextStyle(
                          color: Color.fromRGBO(26, 23, 44, 1),
                          letterSpacing: 1.5,
                          wordSpacing: 0.1,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),

                //Password field
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: TextFormField(
                    readOnly: true,
                    controller: passwordController,
                    obscureText: passwordObsecureText,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() =>
                              passwordObsecureText = !passwordObsecureText),
                          icon: Icon(
                            passwordObsecureText
                                ? EvaIcons.eye
                                : EvaIcons.eye_off,
                            color: const Color.fromRGBO(123, 97, 255, 1),
                          ),
                        ),
                        hintText: "********",
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(143, 143, 156, 1)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
