
import 'package:flutter/material.dart';
import 'package:studentqr/Pages/DoctorPage.dart';
import 'package:studentqr/Pages/OnboardingPage.dart';
import 'package:studentqr/Pages/StudentHome.dart';
import 'package:studentqr/Pages/StudentRegisterPage.dart';
import 'package:studentqr/Pages/StudentsPage.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //body: DoctorPage(),
       // body: StudentsPage(),
        body: OnboardingPage(),
      //  body: AttendancePage(),
      //  body: StudentRegisterPage(code: "TEST1234"),
      ),
    );
  }
}

