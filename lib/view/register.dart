// ignore_for_file: unnecessary_null_comparison
import 'dart:io';
import 'dart:math';
import 'package:capstone_project/controllers/user_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_project/theme/colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final contactNoController = TextEditingController();
  final addressController = TextEditingController();
  final picker = ImagePicker();
  File? imageFile;

  String randomfileName = Random().toString();

  bool passwordObsecureText = true;
  bool confirmPasswordObsecureText = true;

  Future<void> chooseImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    //if there is an image set the image to the imageFIle
    image != null
        ? setState(() {
            imageFile = File(image.path);
          })
        : null;
  }

  // variable to hold image to be displayed
  //   dynamic fileImage;
  // Uint8List? bytesData;
  // List<int>? selectedFile;
  // webFilePicker() async {
  //   html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  //   uploadInput.multiple = true;
  //   uploadInput.click();

  //   uploadInput.onChange.listen((event) {
  //     final files = uploadInput.files;
  //     final file = files![0];
  //     final reader = html.FileReader();
  //     reader.onLoadEnd.listen((event) {
  //       setState(() {
  //         fileImage = file;
  //         bytesData = const Base64Decoder()
  //             .convert(reader.result.toString().split(",").last);
  //         selectedFile = bytesData;
  //       });
  //     });
  //     reader.readAsDataUrl(file);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(EvaIcons.arrow_back, color: ColorTheme.primaryColor,),
          onPressed: () => {Navigator.of(context).pop()},
        ),
        title: const Text("SIGN UP",
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
            children: <Widget>[
              //spacing

              const SizedBox(height: 60),

              Container(
                alignment: Alignment.center,
                child: const Text("Let's Create an Account",
                    style: TextStyle(
                        color: ColorTheme.secondaryColor,
                        letterSpacing: .5,
                        wordSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text("Create a new account for more explore",
                    style: TextStyle(
                        color: ColorTheme.secondaryColor,
                        letterSpacing: .5,
                        wordSpacing: 0.5,
                        fontSize: 16)),
              ),
              const SizedBox(height: 35),
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
                            ? Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            FileImage(File(imageFile!.path)))))
                            : const CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage(
                                    "assets/images/default_profile.jpg"),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: MediaQuery.of(context).size.width / 3,
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
                            color: ColorTheme.secondaryColor,
                          ),
                          onPressed: () {
                            chooseImage();
                          },
                        ),
                      ),
                    ),
                  ]),
              const SizedBox(height: 30),
              //Form
              Form(
                child: Column(
                  children: <Widget>[
                    //Name field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Name",
                          prefixIcon: Icon(
                            EvaIcons.person,
                            color: ColorTheme.primaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Address Field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Address",
                          prefixIcon: Icon(
                            FontAwesome.address_card,
                            color: ColorTheme.primaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Emaill address Field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Email",
                          prefixIcon: Icon(
                            EvaIcons.email,
                            color: ColorTheme.primaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Contact No Field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        controller: contactNoController,
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.all(20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Contact No.",
                          prefixIcon: Icon(
                            EvaIcons.phone,
                            color: ColorTheme.primaryColor,
                          ),
                          border: OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Password Field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        obscureText: passwordObsecureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Password",
                          prefixIcon: const Icon(
                            EvaIcons.lock,
                            color: ColorTheme.primaryColor,
                          ),
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
                          border: const OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Confirm password Field
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(221, 221, 221, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextFormField(
                        obscureText: confirmPasswordObsecureText,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(
                            EvaIcons.lock,
                            color: ColorTheme.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() =>
                                confirmPasswordObsecureText =
                                    !confirmPasswordObsecureText),
                            icon: Icon(
                              confirmPasswordObsecureText
                                  ? EvaIcons.eye
                                  : EvaIcons.eye_off,
                              color: ColorTheme.secondaryColor,
                            ),
                          ),
                          border: const OutlineInputBorder(
                              gapPadding: 5,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Spacing
              const SizedBox(height: 30),

              //Register Button
              TextButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      if (imageFile == null) {
                        UserAPI.registerWithoutImageController(
                            usernameController.text,
                            addressController.text,
                            emailController.text,
                            contactNoController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            "User",
                            context);
                      } else {
                        UserAPI.registerWithImageController(
                            usernameController.text,
                            addressController.text,
                            emailController.text,
                            contactNoController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            "User",
                            imageFile!,
                            context);
                      }
                    } else if (Platform.isAndroid) {
                      if (imageFile == null) {
                        UserAPI.registerWithoutImageController(
                            usernameController.text,
                            addressController.text,
                            emailController.text,
                            contactNoController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            "user",
                            context);
                      } else {
                        UserAPI.registerWithImageController(
                            usernameController.text,
                            addressController.text,
                            emailController.text,
                            contactNoController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            "user",
                            imageFile!,
                            context);
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: ColorTheme.primaryColor,
                    ),
                    child: const Text("Sign Up",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            letterSpacing: .5,
                            wordSpacing: 0.5,
                            fontSize: 16)),
                  )),

              //Sign up button
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account??",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: .5,
                            wordSpacing: 0.5,
                            fontSize: 16)),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(RouteName.login),
                      child: const Text("Sign In",
                          style: TextStyle(
                              color: ColorTheme.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
