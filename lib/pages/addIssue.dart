import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/components/textFields.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import '../controllers/controllers.dart';
import '../components/glassCards/addIssueCard.dart';

class AddIssue extends StatefulWidget {
  @override
  State<AddIssue> createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  @override
  void initState() {
    super.initState();
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
  }

  Future<void> _submitIssue() async {
    if (requesterNameController.text.isEmpty ||
        regionController.text.isEmpty||
        productFamilyController.text.isEmpty ||
        productNameController.text.isEmpty ||
        countryController.text.isEmpty ||
        summaryController.text.isEmpty ||
        productTicketNumberController.text.isEmpty ||
        ticketNumberController.text.isEmpty ||
        softwareVersionController.text.isEmpty ||
        issueTitleController.text.isEmpty ||
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
      "status": "Newly Registered",
      "title": issueTitleController.text,
      "severity": severities[selectedSeverityIndex],
      "name": requesterNameController.text,
      "product_family": productFamilyController.text,
      "ticket": ticketNumberController.text,
      "problem_ticket": productTicketNumberController.text
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.post(
      Uri.parse('http://15.207.244.117/api/issues/'),
      headers: {'Content-Type': 'application/json',
        'Authorization' : 'Token $token'},
      body: jsonEncode(issueData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: 'Issue Successfully Posted',
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
                message: 'Failed to Post Issue',
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
            colors: [Color(0xff000000), Color(0xff11307A)],
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
                          'Add an Issue',
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
                              padding: const EdgeInsets.only(top: 10, left: 10, right: 30),
                              child: Text(
                                'Select your\nseverity:',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.45,
                              child: CupertinoPicker(
                                looping: false,
                                diameterRatio: 1,
                                magnification: 1.3,
                                itemExtent: 40,
                                scrollController: FixedExtentScrollController(
                                  initialItem: 1,
                                ),
                                onSelectedItemChanged: (int index) {
                                  setState(() {
                                    selectedSeverityIndex = index;
                                  });
                                },
                                backgroundColor: Colors.transparent,
                                children: List<Widget>.generate(
                                  severities.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        severities[index],
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
                          textInputType: TextInputType.name,
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
                          textInputType: TextInputType.name,
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
                          textInputType: TextInputType.name,
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
                          textInputType: TextInputType.name,
                          hintText: '  e.g., PSS4',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'SF Case Number. :',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        CustomTextField(
                          controller: ticketNumberController,
                          textInputType: TextInputType.number,
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
                          textInputType: TextInputType.number,
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
                          textInputType: TextInputType.name,
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
                          textInputType: TextInputType.name,
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
                          textInputType: TextInputType.number,
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
                          textInputType: TextInputType.name,
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
                          hintText: '  Enter your Issue Description',
                          maxLines: 15,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                              onPressed: _submitIssue,
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
                                'Post Issue',
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
