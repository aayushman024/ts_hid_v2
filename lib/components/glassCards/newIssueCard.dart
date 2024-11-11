// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/components/tagsButton.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'issueCards.dart';

class NewIssueCard extends StatefulWidget {

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
  final markAsRead;
  final bool wasReopened;


  NewIssueCard({
    required this.severity,
    required this.region,
    required this.country,
    required this.customer,
    required this.prodFamily,
    required this.titleText,
    required this.postedTime,
    required this.ticketNumber,
    required this.wasReopened,
    this.markAsRead,
    this.status,
    this.description,
    this.productName,
    this.softwareVersion,
    this.requesterName,
    this.textColor,
    this.lastUpdated,
  });

  @override
  State<NewIssueCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NewIssueCard> {
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
              //   child: ActionSlider.standard(
              //     sliderBehavior: SliderBehavior.stretch,
              //     child: Text('Mark as Read',
              //     style: GoogleFonts.poppins(
              //       color: Colors.white,
              //       fontSize: 13,
              //       fontWeight: FontWeight.w500
              //     ),),
              //     toggleColor: Color(0xff021526),
              //     loadingIcon: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: CircularProgressIndicator(
              //         color: Colors.green,
              //         strokeWidth: 2,
              //       ),
              //     ),
              //     icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.green,),
              //     height: screenHeight*0.06,
              //     width: screenWidth*0.6,
              //     successIcon:  Icon(Icons.check, color: Colors.green,),
              //     backgroundColor: Colors.white.withOpacity(0.4),
              //     action: (controller) {
              //       controller.loading();
              //       setState(() {
              //         widget.markAsRead();
              //       });
              //       controller.success();
              //   },
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, right: 15),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                            BorderSide(color: Colors.green, width: 0.5)),
                        backgroundColor: WidgetStatePropertyAll(Color(0xff021526)),
                      ),
                        onPressed: widget.markAsRead,
                        child: Text('Mark as Read',
                          style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
