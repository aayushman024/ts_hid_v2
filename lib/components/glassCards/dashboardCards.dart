// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardCard extends StatelessWidget {

  BorderRadius borderRadius = BorderRadius.circular(15);

  final height;
  final width;
  final child;

  DashBoardCard({
    this.height,
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
            Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: borderRadius,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}