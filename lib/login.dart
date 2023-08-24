import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/dashboard.dart';
import 'package:todo_app/register.dart';
import 'package:velocity_x/velocity_x.dart';
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };
      var response = await http.post(Uri.parse(Config.login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        print('Something went wrong');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.white],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Password",
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // FilledButton(
                  //   onPressed: () {
                  //     loginUser();
                  //     //print("You press login button!");
                  //   },
                  //   child: Text(
                  //     "Login",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  //   style: TextButton.styleFrom(backgroundColor: Colors.orange),
                  // ),
                  GestureDetector(
                    onTap: () {
                      loginUser();
                    },
                    child: HStack([
                      VxBox(child: "LogIn".text.white.makeCentered().p16())
                          .orange400
                          .roundedLg
                          .make()
                          .px16()
                          .py16(),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registration(),
                          ));
                    },
                    child: HStack([
                      "Create a new Account..!".text.make(),
                      " Sign Up".text.black.make()
                    ]).centered(),
                  ),
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: GestureDetector(
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => Registration()));
        //   },
        //   child: Container(
        //       height: 25,
        //       color: Colors.orange,
        //       child: Center(
        //           child: "Create a new Account..! Sign Up"
        //               .text
        //               .xl
        //               .white
        //               .makeCentered())),
        // ),
      ),
    );
  }
}
