// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';

import '../components/glassCards/frostedGlass.dart';
import '../globals/global_variables.dart';

class TeamSelector extends StatefulWidget {
  const TeamSelector({super.key});

  @override
  State<TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff000000), Color(0xff11307A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: screenHeight*0.1,),
              Image.asset(
                'assets/logo.png',
                height: 20,
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Image.asset('assets/tshid.png', scale: 4,),

              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Select Your Region :',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.22,
                width: screenWidth * 0.5,
                child: CupertinoPicker(
                  looping: false,
                  magnification: 1.2,
                  itemExtent: 50,
                  scrollController: FixedExtentScrollController(
                    initialItem: 1,
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedItemsIndex = index;
                    });
                  },
                  backgroundColor: Colors.transparent,
                  children: List<Widget>.generate(teams.length, (int index) {
                    return Center(
                      child: Text(
                        teams[index],
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                'Select Your Team :',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=> AllIssuesPage()));
                  },
                  child: GlassCard(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.9,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/opticalFiber.png', height: screenHeight*0.075,),
                          Text('OPTICS', style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22
                          ),),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.white, size: 40,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        duration: Duration(seconds: 4),
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: 'Hold On!',
                          message: 'This section is under construction',
                          contentType: ContentType.warning,
                          messageTextStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        )));
                  },
                  child: GlassCard(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.9,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/dns.png', height: screenHeight*0.075,),
                          Text('IP NETWORKS', style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20
                          ),),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.white, size: 40,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.transparent,
                        duration: Duration(seconds: 4),
                        elevation: 0,
                        content: AwesomeSnackbarContent(
                          title: 'Hold On!',
                          message: 'This section is under construction',
                          contentType: ContentType.warning,
                          messageTextStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        )));
                  },
                  child: GlassCard(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.9,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/fn.png', height: screenHeight*0.075,),
                          Text('FIXED NETWORKS', style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ),),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.white, size: 40,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
