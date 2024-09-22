// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/Models/get_all_issues.dart';

import '../components/Alerts/addIssueCredAlert.dart';
import '../components/textFields.dart';
import '../controllers/controllers.dart';
import '../globals/global_variables.dart';
import 'allIssuesPage.dart';

class EditIssue extends StatefulWidget {
  final GetAllIssues issue;
  const EditIssue({super.key, required this.issue});

  @override
  State<EditIssue> createState() => _EditIssueState();
}

class _EditIssueState extends State<EditIssue> {

  @override
  void initState() {
    super.initState();
    requesterNameController.text = widget.issue.name ?? 'Name';
    productNameController.text = widget.issue.product ?? 'Product Name';
    regionController.text = widget.issue.region ?? 'Region';
    productFamilyController.text = widget.issue.productFamily ?? 'Product Family';
    countryController.text = widget.issue.country ?? 'Country';
    softwareVersionController.text = widget.issue.technology ?? 'Software Version';
    issueTitleController.text = widget.issue.title ?? 'Issue Title';
    issueDescriptionController.text = widget.issue.description ?? 'Issue Description';
    customerNameController.text = widget.issue.customer ?? 'Customer';
    productTicketNumberController.text = widget.issue.problemTicket ?? 'Product Ticket';
    ticketNumberController.text = widget.issue.ticket ?? 'Ticket Number';
    summaryController.text = widget.issue.summary ?? 'Current Summary';
    selectedSeverityIndex = severities.indexOf(widget.issue.severity ?? 'Critical');
  }



  void resetTextField() {
    requesterNameController.clear();
    productNameController.clear();
    regionController.clear();
    productFamilyController.clear();
    countryController.clear();
    softwareVersionController.clear();
    issueTitleController.clear();
    issueDescriptionController.clear();
    customerNameController.clear();
    productTicketNumberController.clear();
    ticketNumberController.clear();
    summaryController.clear();
  }

  Future<void> _editIssue(int issueID) async {
    if (requesterNameController.text.isEmpty ||
        productFamilyController.text.isEmpty ||
        productNameController.text.isEmpty ||
        countryController.text.isEmpty ||
        softwareVersionController.text.isEmpty ||
        issueTitleController.text.isEmpty ||
        regionController.text.isEmpty||
        customerNameController.text.isEmpty||
        productTicketNumberController.text.isEmpty||
        ticketNumberController.text.isEmpty||
        summaryController.text.isEmpty||
        issueDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Error!',
                message: 'One or more field is empty',
                contentType: ContentType.failure,
                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              )
          )
      );
      return;
    }

    final Map<String, dynamic> issueData = {
      "region": regionController.text,
      "country": countryController.text,
      "customer": customerNameController.text,
      "technology": softwareVersionController.text,
      "product": productNameController.text,
      "description": issueDescriptionController.text,
      "summary": summaryController.text,
      "status": allStatus[selectedStatusIndex],
      "title": issueTitleController.text,
      "severity": severities[selectedSeverityIndex],
      "name": requesterNameController.text,
      "product_family": productFamilyController.text,
      "ticket": ticketNumberController.text,
      "problem_ticket": productTicketNumberController.text,
      "was_reopened": (allStatus[selectedStatusIndex] == 'Re-Opened')? true : false,
    };

    String issueID = widget.issue.id!.toString();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.put(
      Uri.parse('http://15.207.244.117/api/issues/${widget.issue.id}/'),
      headers: {'Content-Type': 'application/json',
          'Authorization' : 'Token $token'},
      body: jsonEncode(issueData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: 'Issue Successfully Edited',
                contentType: ContentType.success,
                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              )
          )
      );
      resetTextField();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllIssuesPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              content: AwesomeSnackbarContent(
                title: 'Error!',
                message: 'Failed to edit issue',
                contentType: ContentType.failure,
                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xff000000), Color(0xff11307A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllIssuesPage(),
                              ),
                            );
                            resetTextField();
                          },
                          icon: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: screenHeight * 0.04,
                          ),
                        ),
                        Text(
                          'Update Issue',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, right: 40),
                              child: Text(
                                'Update Status:',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.4,
                              child: CupertinoPicker(
                                looping: false,
                                diameterRatio: 1,
                                magnification: 1.2,
                                itemExtent: 45,
                                scrollController: FixedExtentScrollController(
                                  initialItem: allStatus.indexOf(widget.issue.status!),
                                ),
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    selectedStatusIndex = index;
                                  });
                                },
                                backgroundColor: Colors.transparent,
                                children: (widget.issue.status == 'Resolved' || widget.issue.status == 'Closed') ?
                                List<Widget>.generate(
                                  addressedStatus.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        addressedStatus[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ) : (widget.issue.status == 'Pending')?
                                List<Widget>.generate(
                                  ifPendingStatus.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        ifPendingStatus[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ) : (widget.issue.status == 'In-Progress')?
                                List<Widget>.generate(
                                    ifInProgressStatus.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        ifInProgressStatus[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ) : (widget.issue.status == 'Re-Opened')?
                                List<Widget>.generate(
                                  reopenedStatus.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        reopenedStatus[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ) :
                                List<Widget>.generate(
                                  status.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        status[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Requester\'s Name:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: requesterNameController,
                          hintText: '  e.g., John Doe',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Region:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: regionController,
                          hintText: '  e.g., APAC',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Product Family:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: productFamilyController,
                          hintText: '  e.g., 1830PSS',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Product Type:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: productNameController,
                          hintText: '  e.g., PSS4',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'SF Case Number:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: ticketNumberController,
                          hintText: '  e.g., 123456',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Problem Ticket Number:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: productTicketNumberController,
                          hintText: '  e.g., 123456',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Country:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: countryController,
                          hintText: '  e.g., India',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Customer Name:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: customerNameController,
                          hintText: '  e.g., Railtel',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Software Version:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: softwareVersionController,
                          hintText: '  e.g., 23.2.15',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Issue Title:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: issueTitleController,
                          hintText: '  e.g., Heating Issue in 1830PSS',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Issue Summary:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: summaryController,
                          hintText: '  Current Summary',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Explain Issue in detail:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: issueDescriptionController,
                          hintText: '  Issue Description',
                          maxLines: 15,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ElevatedButton(
                              onPressed: (){
                                _editIssue(widget.issue.id!);
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Color(0xffB1DEFF)),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.fromLTRB(100, 14, 100, 14)),
                              ),
                              child: Text(
                                'Edit Issue',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

