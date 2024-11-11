// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/components/Alerts/credAlertBox.dart';
import 'package:ts_hid/components/glassCards/frostedGlass.dart';
import 'package:ts_hid/controllers/controllers.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import 'package:ts_hid/pages/teamSelector.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

Future<bool> login(String username, String password) async {
  final url = Uri.parse('$apiURL/api-token-auth/');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //temp access token
    await prefs.setString('accessToken', data['token']);
    //isLoggedIn
    await prefs.setBool('isLoggedIn', true);
    //user role
    await prefs.setString('userRole', data['role']);

    await prefs.setString('username', data['username']);
    print('login successful');
    return true;
  } else {
    print('login failed');
    return false;
  }
}

class LoginPageState extends State<LoginPage> {

  bool isPasswordVisible = true;
  void togglePasswordView(){
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff000000), Color(0xff11307A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: screenHeight * 0.1),

                Image.asset(
                  'assets/logo.png',
                  height: 20,
                ),

                SizedBox(
                  height: screenHeight * 0.06,
                ),

                Text('Executive Dashboard',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
                ),
                Divider(
                  endIndent: screenWidth*0.4,
                    indent: screenWidth*0.4,
                  height: screenHeight*0.03,
                  color: Colors.white,
                ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text('TS - Hot Issues',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),

                // Image.asset(
                //   'assets/tshid.png',
                //   height: 40,
                // ),

                SizedBox(height: screenHeight * 0.10),

                FrostedGlass(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Enter Username',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextField(
                          controller: usernameController,
                          autofocus: true,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            filled: true,
                            fillColor: Colors.white30,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: '    e.g., john24',
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          'Enter Password',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          obscureText: isPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            suffixIcon: IconButton(
                              onPressed: togglePasswordView,
                              icon : Icon(isPasswordVisible? Icons.visibility_off : Icons.visibility,
                              color: Colors.white38,)
                            ),
                            hintText: '   ●●●●●●●●',
                            filled: true,
                            fillColor: Colors.white30,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.07),

                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (usernameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        // Show error snackbar if fields are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.transparent,
                            duration: Duration(seconds: 4),
                            elevation: 0,
                            content: AwesomeSnackbarContent(
                              title: 'Error!',
                              message: 'One or more fields are empty',
                              contentType: ContentType.failure,
                              messageTextStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      } else {
                        final bool loginSuccessful = await login(
                            usernameController.text, passwordController.text);

                        if (loginSuccessful) {
                          passwordController.clear();


                          // final SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // final String? role = prefs.getString('userRole');

                          // ignore: prefer_const_constructors
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> AllIssuesPage()));
                          // if (role == 'admin') {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       CupertinoPageRoute(
                          //           builder: (context) => TeamSelector()));
                          // } else if (role == 'manager') {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       CupertinoPageRoute(
                          //           builder: (context) => TeamSelector()));
                          // } else if (role == 'contributor') {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       CupertinoPageRoute(
                          //           builder: (context) => TeamSelector()));
                          // } else {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       CupertinoPageRoute(
                          //           builder: (context) => TeamSelector()));
                          // }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.transparent,
                              duration: Duration(seconds: 4),
                              elevation: 0,
                              content: AwesomeSnackbarContent(
                                title: 'Login Failed!',
                                titleTextStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                                message:
                                    'Please check your credentials and try again.',
                                contentType: ContentType.failure,
                                messageTextStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Colors.black.withOpacity(0.6)),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      padding: WidgetStateProperty.all(
                          EdgeInsets.fromLTRB(120, 18, 120, 18)),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15 ,bottom: 15),
                //   child: ElevatedButton(
                //     onPressed: (){
                //       if (usernameController.text.isEmpty || passwordController.text.isEmpty){
                //         // showDialog(context: context, builder: (context)=> CredAlertBox());
                //         ScaffoldMessenger.of(context).showSnackBar(
                //          SnackBar(
                //            backgroundColor: Colors.transparent,
                //              duration: Duration(seconds: 4),
                //              elevation: 0,
                //              content: AwesomeSnackbarContent(
                //                title: 'Error!',
                //                message: 'One or more field is empty',
                //                contentType: ContentType.failure,
                //                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                //              )
                //          )
                //         );
                //       }
                //       else {
                //       Navigator.pushReplacement(
                //           context, CupertinoPageRoute(builder: (context)=> TeamSelector()));
                //       usernameController.clear();
                //       passwordController.clear();
                //       }
                //     },
                //     style: ButtonStyle(
                //       backgroundColor: WidgetStateProperty.all(Colors.black.withOpacity(0.6)),
                //       shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                //       padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(120, 18, 120, 18))
                //     ),
                //     child: Text('Continue', style: GoogleFonts.poppins(
                //       color: Colors.white,
                //       fontWeight: FontWeight.w600
                //     ),),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
