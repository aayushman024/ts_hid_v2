// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comment({
    super.key, required this.text, required this.user, required this.time
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text(text,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
              child: Text('By : ' + user, style: TextStyle(
                  fontFamily: 'NokiaPureText_Bd',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal
              ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 10, 20),
              child: Text('Posted at : ' + time, style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: 12)),
            )

          ],
        ),
      ),
    );
  }
}
