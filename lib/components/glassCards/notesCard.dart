// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/components/tagsButton.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'issueCards.dart';

class NotesCard extends StatefulWidget {

  final severity;
  final region;
  final country;
  final customer;
  final prodFamily;
  final titleText;
  final description;
  final postedTime;
  final productName;
  final softwareVersion;
  final requesterName;
  final ticketNumber;
  final textColor;
  final status;
  final lastUpdated;
  final bool wasReopened;


  NotesCard({
    required this.severity,
    required this.region,
    required this.country,
    required this.customer,
    required this.prodFamily,
    required this.titleText,
    required this.postedTime,
    required this.ticketNumber,
    required this.wasReopened,
    //to be updated from database
    this.status,
    this.description,
    this.productName,
    this.softwareVersion,
    this.requesterName,
    this.textColor,
    this.lastUpdated,
});

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15, left: 15, right: 15),
      child: IssueCard(
        width: screenWidth * 0.95,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 20, 3, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                      TagsButton(
                        tagBoxColor: Color(0xff021526),
                        tags: widget.severity,
                        textColor: widget.textColor,
                      ),
                      TagsButton(
                        tagBoxColor: Colors.white30,
                        tags: widget.region,
                        textColor: Colors.white,
                      ),
                      TagsButton(
                        tagBoxColor: Colors.white30,
                        tags: widget.country,
                        textColor: Colors.white,
                      ),
                      TagsButton(
                        tagBoxColor: Colors.white30,
                        tags: widget.prodFamily,
                        textColor: Colors.white,
                      ),
                    TagsButton(
                      tagBoxColor: Colors.white30,
                      tags: widget.customer,
                      textColor: Colors.white,
                    ),
                    TagsButton(
                      tagBoxColor: Colors.white30,
                      tags: ' SF Case No. : ' + widget.ticketNumber,
                      textColor: Colors.white,
                    ),
                    ],
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListTile(
                  minTileHeight: screenHeight*0.06,
                  horizontalTitleGap: screenWidth*0.005,
                  leading: Icon(
                    Icons.access_time,
                    color: Colors.white30,
                    size: screenHeight*0.022,
                  ),
                  title: Text('Created on : ${widget.postedTime}',
                    style: GoogleFonts.poppins(
                        color: Colors.white30,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic
                    ),),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 15),
              //   child: ListTile(
              //     horizontalTitleGap: screenWidth*0.005,
              //     minVerticalPadding: 0,
              //     minTileHeight: 1,
              //     leading: Icon(
              //       Icons.access_time,
              //       color: Colors.white30,
              //       size: screenHeight*0.022,
              //     ),
              //     title: Text('Last Updated on : ${widget.lastUpdated}',
              //       style: GoogleFonts.poppins(
              //           color: Colors.white30,
              //           fontSize: 12,
              //           fontWeight: FontWeight.w500,
              //           fontStyle: FontStyle.italic
              //       ),),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15,bottom: 30),
                child: Text(widget.titleText,
                  style:
                //     GoogleFonts.poppins(
                //     color: Colors.white,
                //     fontSize: 20,
                //     fontWeight: FontWeight.w500
                // )
                  TextStyle(
                      fontFamily: 'NokiaPureHeadline_Lt',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Current Status : ',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  ),),
                  Text(widget.status,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  if (widget.wasReopened)
                    Text(
                      '*',
                      style: TextStyle(color: Colors.white),
                    ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
