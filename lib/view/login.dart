import 'package:capstone_project/theme/colors.dart';
import 'package:capstone_project/controllers/guard_controller.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:capstone_project/controllers/user_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  List<String> dropdownItems = ["User", "Admin", "Guard"];

  String? dropdownValue;
  bool toggleForm = true;

  bool passwordObsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.center,
                    child: const Text("LOGIN",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: .5,
                            wordSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  //Login Button
                  TextButton(
                      onPressed: () => setState(() => toggleForm = !toggleForm),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: ColorTheme.primaryColor,
                        ),
                        child: Text(toggleForm ? "USER" : "ADMIN/GUARD",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                letterSpacing: .5,
                                wordSpacing: 0.5,
                                fontSize: 16)),
                      )),
                ],
              ),

              //spacing

              const SizedBox(height: 30),

              Container(
                alignment: Alignment.center,
                child: const Text("Welcome Back",
                    style: TextStyle(
                        color: ColorTheme.secondaryColor,
                        letterSpacing: .5,
                        wordSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text("Put your password to explore again",
                    style: TextStyle(
                        color: ColorTheme.secondaryColor,
                        letterSpacing: .5,
                        wordSpacing: 0.5,
                        fontSize: 16)),
              ),

              const SizedBox(height: 30),

              const SizedBox(height: 20),
              //Form

              Form(
                  child: Column(
                    children: <Widget>[
                      // const SizedBox(height: 20),
                      //Email Field
                      toggleForm
                          ? Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(221, 221, 221, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Email",
                                  prefixIcon: Icon(
                                    EvaIcons.email,
                                    color: ColorTheme.secondaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                      gapPadding: 5,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(221, 221, 221, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Username",
                                  prefixIcon: Icon(
                                    EvaIcons.person,
                                    color: ColorTheme.secondaryColor,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                              color: ColorTheme.secondaryColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() =>
                                  passwordObsecureText = !passwordObsecureText),
                              icon: Icon(
                                passwordObsecureText
                                    ? EvaIcons.eye
                                    : EvaIcons.eye_off,
                                color: ColorTheme.secondaryColor
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
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(221, 221, 221, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButtonFormField(
                            borderRadius: BorderRadius.circular(10),
                            dropdownColor:
                                const Color.fromRGBO(221, 221, 221, 1),
                            isExpanded: false,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  EvaIcons.person,
                                  color: ColorTheme.secondaryColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20)),
                            hint: const Text("Select login type"),
                            value: dropdownValue,
                            onChanged: (value) =>
                                setState(() => dropdownValue = value),
                            items: dropdownItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),

              //Spacing
              const SizedBox(height: 30),

              //Login Button
              TextButton(
                  onPressed: () {
                    if (dropdownValue == "User") {
                        UserAPI.userLoginController(
                            emailController.text,
                            passwordController.text,
                            dropdownValue,
                            context);
                      } else if (dropdownValue == "Admin") {
                        UserAPI.adminLoginController(
                            usernameController.text,
                            passwordController.text,
                            dropdownValue,
                            context);
                      } else if (dropdownValue == "Guard") {
                        GuardAPI.userGuardController(
                            usernameController.text,
                            passwordController.text,
                            dropdownValue,
                            context);
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
                    child: const Text("Sign In",
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
                    const Text("Don't have an account?",
                        style: TextStyle(
                            color: ColorTheme.secondaryColor,
                            letterSpacing: .5,
                            wordSpacing: 0.5,
                            fontSize: 16)),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(RouteName.register),
                      child: const Text("Sign Up",
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
