import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sizer/sizer.dart';

import 'Authentication_section/Authentication_methods.dart';
import 'Authentication_section/vertify.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool passwordnotVisible = true;
  bool isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  CollectionReference stds = FirebaseFirestore.instance.collection('Students');

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController reg_no = TextEditingController();
  final TextEditingController sem = TextEditingController();

// BRANCH

  List<String> branch = ["DSAI", "CSE", "ECE"];
  String selected_branch = "DSAI";
  String? dropdownNames;
  String dropdownScrollable = "I";

// VERSION

  List<String> version = ["Student", "Faculty", "Warden", "Administration"];
  String selected_version = "Student";
  String? dropdownVersion;
  String versionScrollable = "i";

  String? gender;

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50.w, 0, 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Text("REGISTER",
                        style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  ),
                  // USERNAME TFF
                  Container(
                    width: 90.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0XFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0XFFA8B4C5).withOpacity(0.30),
                            spreadRadius: 0,
                            blurRadius: 14,
                            offset: Offset(0, 6.0)),
                      ],
                    ),
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " Username",
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.sp),
                        prefixIcon: Icon(Icons.person_rounded,
                            color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 90.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0XFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0XFFA8B4C5).withOpacity(0.30),
                            spreadRadius: 0,
                            blurRadius: 14,
                            offset: Offset(0, 6.0)),
                      ],
                    ),
                    child: TextFormField(
                      controller: password,
                      obscureText: passwordnotVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " Password",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        prefixIcon: Icon(Icons.lock_person_rounded,
                            color: Colors.black, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordnotVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
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
                  SizedBox(height: 10),
                  Container(
                    width: 90.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0XFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0XFFA8B4C5).withOpacity(0.30),
                            spreadRadius: 0,
                            blurRadius: 14,
                            offset: Offset(0, 6.0)),
                      ],
                    ),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " Email ID",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        prefixIcon: Icon(Icons.mail_rounded,
                            color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("REG NO.        :",
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 11.sp)),
                      Container(
                        width: 61.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0XFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0XFFA8B4C5).withOpacity(0.30),
                                spreadRadius: 0,
                                blurRadius: 14,
                                offset: Offset(0, 6.0)),
                          ],
                        ),
                        child: TextFormField(
                          controller: reg_no,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "   Registration Number",
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 11.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("SEMESTER   :",
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 11.sp)),
                      Container(
                        width: 61.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0XFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0XFFA8B4C5).withOpacity(0.30),
                                spreadRadius: 0,
                                blurRadius: 14,
                                offset: Offset(0, 6.0)),
                          ],
                        ),
                        child: TextFormField(
                          controller: sem,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "   ",
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("BRANCH       :",
                          style: TextStyle(
                              color: Color(0xff000000), fontSize: 11.sp)),
                      Container(
                        height: 12.w,
                        width: 61.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0XFFffffff),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0XFFA8B4C5).withOpacity(0.30),
                                spreadRadius: 0,
                                blurRadius: 14,
                                offset: Offset(0, 6.0)),
                          ],
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(),
                          value: selected_branch,
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              selected_branch = newValue!;
                            });
                          },
                          items: branch.map((category) {
                            return DropdownMenuItem(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 100, right: 4),
                                    child: Text(category)),
                                value: category);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.w),
                  Row(
                    children: [
                      SizedBox(width: 14.w),
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                              height: 14.w,
                              width: 14.w,
                              child: Image.asset("assets/images/man.png")),
                          Radio(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0XFFffffff)),
                              value: "male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              }),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                              height: 14.w,
                              width: 14.w,
                              child: Image.asset("assets/images/woman.png")),
                          Radio(
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => Color(0XFFffffff)),
                              value: "female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              }),
                        ],
                      )),
                    ],
                  ),

                  SizedBox(height: 13.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 3.w, 0, 0),
                        child: Container(
                          height: 10.w,
                          width: 25.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.w),
                            color: Color(0xffffffff),
                          ),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCEL",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ButtonTheme(
                            minWidth: 15.w,
                            height: 15.w,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.w)),
                            child: RaisedButton(
                                elevation: 0,
                                color: Colors.deepPurple,
                                onPressed: () async {
                                  if (username.text.trim().isNotEmpty &&
                                      email.text.trim().isNotEmpty &&
                                      password.text.trim().isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    if (email.text.trim().contains("@")) {
                                      await createAccount(
                                              username.text.trim(),
                                              email.text.trim(),
                                              password.text.trim(),
                                              sem.text.trim(),
                                              gender!,
                                              selected_branch,
                                              reg_no.text.trim())
                                          .then((user) {
                                        if (user != null) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      VerifyScreen()));
                                          print("Account Created Sucessfull");
                                        } else {
                                          print("Login Failed");
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin:
                                            EdgeInsets.fromLTRB(15, 10, 15, 90),
                                        content: Text(
                                            "Please enter your institute mail id only",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        backgroundColor: Colors.white,
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin:
                                          EdgeInsets.fromLTRB(15, 10, 15, 90),
                                      content: Text("Please fill all details",
                                          style:
                                              TextStyle(color: Colors.black)),
                                      backgroundColor: Colors.white,
                                    ));
                                  }
                                },
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.white))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
