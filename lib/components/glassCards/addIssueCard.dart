// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIssueCard extends StatelessWidget {

  BorderRadius borderRadius = BorderRadius.circular(15);

  final height;
  final width;
  final child;

 AddIssueCard({
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 24,
                sigmaY: 24,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}