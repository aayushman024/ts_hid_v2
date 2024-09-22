import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIssueCredAlert extends StatefulWidget {
  const AddIssueCredAlert({super.key});

  @override
  State<AddIssueCredAlert> createState() => _AddIssueCredAlertState();
}

class _AddIssueCredAlertState extends State<AddIssueCredAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('One or more fields is empty!', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
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
    );;
  }
}
