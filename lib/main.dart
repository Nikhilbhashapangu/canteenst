import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Authentication_section/Authentication_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/authenticate',
    routes: {
      '/authenticate': (context) => Authenticate(),
    },
  ));
}
