


import 'package:canteenst/homepage.dart';
import 'package:canteenst/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'Authentication_section/Authentication_methods.dart';
import 'loadingscreen.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordnotVisible = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return isLoading
          ? LoadingScreen()
          : Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/images/login.png",
                        ),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      Column(children: [
                        SizedBox(height: 40.h),
                        Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              surfaceIntensity: 2,
                              border: NeumorphicBorder(
                                color: Color(0xffffffff),
                                width: 0.1,
                              ),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(1.h)),
                              depth: 10,
                              lightSource: LightSource.top,
                              intensity: 0.7,
                              color: Color(0xff000000)),
                          child: Container(
                            width: 90.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " Email ID",
                                labelStyle: TextStyle(
                                    color: Colors.grey, fontSize: 11.sp),
                                prefixIcon: Icon(Icons.person,
                                    color: Colors.black, size: 6.w),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Neumorphic(
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              border: NeumorphicBorder(
                                color: Color(0xffffffff),
                                width: 0.1,
                              ),
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(1.h)),
                              depth: 10,
                              lightSource: LightSource.top,
                              surfaceIntensity: 2,
                              intensity: 0.7,
                              color: Color(0xff000000)),
                          child: Container(
                            width: 90.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: password,
                              obscureText: passwordnotVisible,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                labelStyle: TextStyle(
                                    color: Colors.grey, fontSize: 11.sp),
                                prefixIcon: Icon(Icons.lock_person_rounded,
                                    color: Colors.black, size: 6.w),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    passwordnotVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xff056EC8),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      passwordnotVisible = !passwordnotVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.fromLTRB(50.w, 0, 2.w, 0),
                          child: ButtonTheme(
                            minWidth: 20.w,
                            height: 20.w,
                            splashColor: Color(0xff7D54AC),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.w)),
                            child: RaisedButton(
                                onPressed: () async {
                                  if (email.text.isNotEmpty &&
                                      password.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await logIn(email.text.trim(),
                                            password.text.trim())
                                        .then(
                                      (user) {
                                        if (user != null) {
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  type:
                                                      PageTransitionType.scale,
                                                  child: const CanteenHome()));

                                          print("Login Successful");
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.all(15),
                                            content: Text(
                                                "Please enter valid details",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            backgroundColor: Colors.white,
                                          ));
                                        }
                                      },
                                    );
                                  }
                                },
                                color: Color(0xff184F78),
                                child: Text("Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.h, 0, 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 12.w,
                                width: 30.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.w),
                                  color: Color(0xffA0CEE1),
                                  backgroundBlendMode: BlendMode.multiply,
                                ),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              alignment: Alignment.center,
                                              duration:
                                                  Duration(milliseconds: 400),
                                              type: PageTransitionType.size,
                                              child: SignupPage()));
                                    },
                                    child: Text("Sign Up",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ))),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ));
    });
  }
}
