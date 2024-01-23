// ignore_for_file: use_build_context_synchronously
// import 'dart:html' as html;
import 'dart:io';
import 'package:capstone_project/connection/api.dart';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_project/variables.dart';
import 'package:capstone_project/theme/colors.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //image temp
  File? imageFile;

  //bool toggle for showing the password
  bool passwordObsecureText = true;

  //variables for the logged in users
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

  Future<void> chooseImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    if (image != null) {
      imageFile = File(image.path);
    }
  }

  @override
  void initState() {
    getCurrentUsersCredentials();

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
          title: const Text("EDIT PROFILE",
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                          child: imageFile != null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      FileImage(File(imageFile!.path)),
                                )
                              : profile.toString() == "default"
                                  ? Container(
                                      width: 140,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                "assets/images/default_profile.jpg",
                                              ),
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
                                              onError: (exception, stackTrace) {
                                                Container(
                                                  width: 140,
                                                  height: 140,
                                                  decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/error_image.jpg"),
                                                          fit: BoxFit.cover)),
                                                );
                                              },
                                              image: NetworkImage(
                                                  ImagesAPI.getProfileUrl(
                                                      profile.toString())))),
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: MediaQuery.of(context).size.width / 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(width: 3, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ]),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: ColorTheme.primaryColor,
                            ),
                            onPressed: () => chooseImage(),
                          ),
                        ),
                      )
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
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    controller: contactController,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 143, 156, 1)),
                    decoration: const InputDecoration(
                        counterText: '',
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
                            color: ColorTheme.secondaryColor,
                          ),
                        ),
                        hintText: "********",
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(143, 143, 156, 1)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                ),

                //SPACING
                const SizedBox(height: 20),

                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: ColorTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: TextButton(
                    onPressed: () {
                      if (imageFile == null) {
                        UserAPI.updateProfileWithoutImageCredentials(
                            uid,
                            nameController.text,
                            addressController.text,
                            emailController.text,
                            contactController.text,
                            passwordController.text,
                            context);
                        currentIndex = 0;
                      } else {
                        UserAPI.updateProfileCredentials(
                            uid,
                            nameController.text,
                            addressController.text,
                            emailController.text,
                            contactController.text,
                            passwordController.text,
                            imageFile,
                            context);
                        currentIndex = 0;
                      }
                    },
                    child: const Text("UPDATE",
                        style: TextStyle(
                            color: ColorTheme.accentColor,
                            letterSpacing: 1.5,
                            wordSpacing: 0.5,
                            fontSize: 18)),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
