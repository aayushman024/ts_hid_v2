import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals/global_variables.dart';

class TagsButton extends StatefulWidget {

  final tagBoxColor;
  final textColor;
  final tags;

  TagsButton({
    required this.tagBoxColor,
    required this.tags,
    this.textColor
});

  @override
  State<TagsButton> createState() => _TagsButtonState();
}

class _TagsButtonState extends State<TagsButton> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: widget.tagBoxColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Text(widget.tags, style:
    GoogleFonts.poppins(
    color: widget.textColor,
    fontSize: 15,
    fontWeight: FontWeight.w500
    ))
        // TextStyle(
        //   fontFamily: 'NokiaPureText_Lt',
        //   color: widget.textColor,
        //   fontSize: 15,
        // ),),
      ),
    );
  }
}
