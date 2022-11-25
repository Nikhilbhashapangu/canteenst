import 'dart:async';

import 'package:canteenst/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/load.png",
                  ),
                  fit: BoxFit.cover),
            ),
            child: const Center(
                child: Text("Click on the link sent to your mail\nto register",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20)))));
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();

    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => const CanteenHome()));
    }
  }
}
