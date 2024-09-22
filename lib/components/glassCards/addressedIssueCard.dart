import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tagsButton.dart';
import 'issueCards.dart';

class AddressedIssueCard extends StatefulWidget {

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

AddressedIssueCard({
  required this.severity,
  required this.region,
  required this.country,
  required this.customer,
  required this.prodFamily,
  required this.titleText,
  required this.postedTime,
  required this.ticketNumber,
  //to be updated from database
  this.status,
  this.description,
  this.productName,
  this.softwareVersion,
  this.requesterName,
  this.textColor,
});

  @override
  State<AddressedIssueCard> createState() => _AddressedIssueCardState();
}

class _AddressedIssueCardState extends State<AddressedIssueCard> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15, left: 15, right: 15),
      child: IssueCard(
        width: screenWidth * 0.95,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
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
                      tags: 'Ticket No. : ' + widget.ticketNumber,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  horizontalTitleGap: screenWidth*0.005,
                  leading: Icon(
                    Icons.access_time,
                    color: Colors.white30,
                    size: screenHeight*0.022,
                  ),
                  title: Text(widget.postedTime,
                    style: GoogleFonts.poppins(
                        color: Colors.white30,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic
                    ),),
                ),
              ),
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
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
