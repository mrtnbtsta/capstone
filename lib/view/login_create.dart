import 'package:capstone_project/view/login.dart';
import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';

class LoginCreate extends StatelessWidget {
  const LoginCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //spacing
            const SizedBox(height: 40),
            //Logo
            Container(
              alignment: Alignment.center,
              child: const FlutterLogo(size: 300),
            ),

            const SizedBox(height: 40),

            //Login Button
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 4, 163, 255),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextButton(
                child: const Text("Log In",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login())),
              ),
            ),

            const SizedBox(height: 30),

            //Login Button
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 4, 163, 255),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextButton(
                child: const Text("Create new account",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(RouteName.register),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
