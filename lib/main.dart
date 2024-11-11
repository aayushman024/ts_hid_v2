// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import 'package:ts_hid/pages/loginPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HID());
}

class HID extends StatefulWidget {
  const HID({super.key});

  @override
  State<HID> createState() => _HIDState();
}

class _HIDState extends State<HID> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
      isLoading
          ? Scaffold(
        backgroundColor: Colors.black87,
              body: Center(
                child:
                    CircularProgressIndicator(
                      backgroundColor: Colors.black12,
                      color: Colors.white60,
                    ),
              ),
            )
          : isLoggedIn
              ? AllIssuesPage()
              : LoginPage(),
    );
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      isLoggedIn = loggedIn;
      isLoading = false;
    });
  }
}
