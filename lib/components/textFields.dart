import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {

  final controller;
  final hintText;
  final maxLines;
  final maxLength;
  final textInputType;

  const CustomTextField({super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.maxLength,
    this.textInputType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: widget.controller,
          minLines: 1,
          keyboardType: widget.textInputType,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
      filled: true,
      fillColor: Color(0xff021526),
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10)
      ),
      hintText: widget.hintText,
      hintStyle: GoogleFonts.poppins(
      color: Colors.white54,
      fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic
      ),)),
    );
  }
}
