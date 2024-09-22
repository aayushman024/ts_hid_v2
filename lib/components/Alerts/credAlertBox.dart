import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CredAlertBox extends StatefulWidget {
  const CredAlertBox({super.key});

  @override
  State<CredAlertBox> createState() => _CredAlertBoxState();
}

class _CredAlertBoxState extends State<CredAlertBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('User Credentials can not be empty!', style: GoogleFonts.poppins(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500)),
      backgroundColor: Color(0xff021526),
      contentPadding: EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text('Back', style: GoogleFonts.poppins(
            color: Colors.white
          ),),
        )
      ],
    );
  }
}
