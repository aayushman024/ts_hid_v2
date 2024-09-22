// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/Models/profileModel.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/controllers/controllers.dart';
import '../components/appDrawer.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileModel> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    await prefs.remove('accessToken');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  final String profileBaseURL = 'http://15.207.244.117/api/profile/';

  Future<ProfileModel> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final responseProfile = await http.get(Uri.parse(profileBaseURL), headers: {'Authorization': 'Token $token'});

      if (responseProfile.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(responseProfile.body);
        ProfileModel profileModel = ProfileModel.fromJson(jsonData);
        return profileModel;
      } else {
        throw Exception('Failed to load details');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset('assets/logo.png', height: screenHeight * 0.015),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        drawer: CustomAppDrawer(),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff000000), Color(0xff11307A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FutureBuilder<ProfileModel>(
                  future: futureProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading profile data!',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final profile = snapshot.data!;
                      return Column(
                        children: [
                          Text(
                            'MY PROFILE',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            endIndent: screenWidth * 0.42,
                            indent: screenWidth * 0.42,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Username :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.username ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Employee ID :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.employeeId ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Email :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.email ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Region :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.region ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Country :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.country ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Technology :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.technology ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.066,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: ListTile(
                                    leading: Text(
                                      'Role :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                    ),
                                    trailing: Text(
                                      profile.role ?? 'N/A',
                                      style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: GlassCard(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    child: Column(
                                      children: [
                                        Text('Privileges :', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 30),
                                          child: ListTile(
                                              minVerticalPadding: 0,
                                              minTileHeight: 0,
                                              leading: Text('View Issues :    ', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
                                              horizontalTitleGap: 0,
                                              title: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ListTile(
                                            minVerticalPadding: 0,
                                            minTileHeight: 0,
                                            leading: Text('Add Issues :     ', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
                                            horizontalTitleGap: 0,
                                            title: (profile.role == 'Global Manager' || profile.role == 'Regional Manager' || profile.role == 'Managers')
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.do_not_disturb,
                                                    color: Colors.red,
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ListTile(
                                              minVerticalPadding: 0,
                                              minTileHeight: 0,
                                              leading: Text('Edit Issues :      ', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
                                              horizontalTitleGap: 0,
                                              title: (profile.role == 'Global Manager' || profile.role == 'Regional Manager' || profile.role == 'Managers')
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.do_not_disturb,
                                                      color: Colors.red,
                                                    )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ListTile(
                                              minVerticalPadding: 0,
                                              minTileHeight: 0,
                                              leading: Text('Add Updates : ', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
                                              horizontalTitleGap: 0,
                                              title: (profile.role == 'Global Manager' || profile.role == 'Regional Manager' || profile.role == 'Managers')
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.do_not_disturb,
                                                      color: Colors.red,
                                                    )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ListTile(
                                              minVerticalPadding: 0,
                                              minTileHeight: 0,
                                              leading: Text('Edit Status :     ', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11)),
                                              horizontalTitleGap: 0,
                                              title: (profile.role == 'Global Manager' || profile.role == 'Regional Manager' || profile.role == 'Managers')
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.do_not_disturb,
                                                      color: Colors.red,
                                                    )),
                                        ),
                                      ],
                                    ),
                                  )),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: GestureDetector(
                              onTap: () {
                                logout(context);
                              },
                              child: GlassCard(
                                width: screenWidth * 0.35,
                                height: screenHeight * 0.07,
                                child: Center(
                                  child: Text(
                                    'LOGOUT',
                                    style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No profile data available.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                ),
              ),
            )));
  }
}
