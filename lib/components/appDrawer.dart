import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/pages/addressedIssues.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import 'package:ts_hid/pages/contactUs.dart';
import 'package:ts_hid/pages/loginPage.dart';
import 'package:ts_hid/pages/profile.dart';
import 'package:ts_hid/pages/teamSelector.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.9,
      backgroundColor: const Color(0xff021526),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight*0.1,
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AllIssuesPage()));
              },
              leading: const Icon(
                Icons.all_inbox_rounded,
                color: Colors.white,
              ),
              title: Text(
                'A L L  I S S U E S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            // ListTile(
            //   leading: const Icon(
            //     Icons.edit_note,
            //     color: Colors.white,
            //   ),
            //   title: Text(
            //     ' P R E F E R E N C E S',
            //     style: GoogleFonts.poppins(color: Colors.white),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => const TeamSelector()));
            //   },
            // ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddressedIssues()));
              },
              leading: const Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.white,
              ),
              title: Text(
                'A D D R E S S E D  I S S U E S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              title: Text(
                'P R O F I L E',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
              },
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUs()));
              },
              leading: const Icon(
                Icons.call,
                color: Colors.white,
              ),
              title: Text(
                'C O N T A C T  U S',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
