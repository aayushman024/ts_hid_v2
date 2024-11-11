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
    selectedRegion = widget.issue.region ?? 'Region';
    productFamilyController.text = widget.issue.productFamily ?? 'Product Family';
    countryController.text = widget.issue.country ?? 'Country';
    selectedTechnology = widget.issue.technology ?? 'Technology';
    softwareVersionController.text = widget.issue.softwareVersion ?? 'Software Version';
    issueTitleController.text = widget.issue.title ?? 'Issue Title';
    issueDescriptionController.text = widget.issue.description ?? 'Issue Description';
    customerNameController.text = widget.issue.customer ?? 'Customer';
    productTicketNumberController.text = widget.issue.problemTicket ?? 'Product Ticket';
    ticketNumberController.text = widget.issue.ticket ?? 'Ticket Number';
    summaryController.text = widget.issue.summary ?? 'Current Summary';
    selectedSeverityIndex = severities.indexOf(widget.issue.severity ?? 'Tracking');
    selectedStatusIndex = allStatus.indexOf(widget.issue.status ?? 'Newly Registered');
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
    technologyController.clear();
  }

  Future<void> _editIssue(int issueID) async {
    if (requesterNameController.text.isEmpty ||
        productFamilyController.text.isEmpty ||
        productNameController.text.isEmpty ||
        countryController.text.isEmpty ||
        summaryController.text.isEmpty ||
        productTicketNumberController.text.isEmpty ||
        ticketNumberController.text.isEmpty ||
        softwareVersionController.text.isEmpty ||
        issueTitleController.text.isEmpty ||
        selectedTechnology == null ||
        selectedRegion == null ||
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
      "region": selectedRegion,
      "country": countryController.text,
      "customer": customerNameController.text,
      "technology": selectedTechnology,
      "software_version": softwareVersionController.text,
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

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.put(
      Uri.parse('$apiURL/api/issues/${widget.issue.id}/'),
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
              elevation: 0,
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

  List<String> filteredCountries = [];
  String? selectedCountry;
  String? selectedTechnology;
  String? selectedRegion;

  void _filterCountries(String query) {
    final filtered = countries.where((country) => country.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      filteredCountries = filtered;
    });
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, right: 40),
                              child: Text(
                                'Update Severity:',
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
                                    initialItem: severities.indexOf(widget.issue.severity!),
                                  ),
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedSeverityIndex = index;
                                    });
                                  },
                                  backgroundColor: Colors.transparent,
                                  children:
                                  List<Widget>.generate(
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
                          hintText: '  e.g., John Doe',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 10),
                              child: Text(
                                'Region:',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 20, right: 50),
                              child: Text(
                                'Technology:',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  hint: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          ' e.g., APAC   ',
                                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  dropdownColor: Colors.black,
                                  value: selectedRegion,
                                  items: teams
                                      .map((customer) => DropdownMenuItem(
                                    value: customer,
                                    child: Text(
                                      customer,
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedRegion = newValue;
                                    });
                                  }),
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  hint: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        ' e.g., Optics   ',
                                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  dropdownColor: Colors.black,
                                  value: selectedTechnology,
                                  items: technology
                                      .map((customer) => DropdownMenuItem(
                                    value: customer,
                                    child: Text(
                                      customer,
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTechnology = newValue;
                                    });
                                  }),
                            ),
                          ],
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
                        Stack(
                          children: [
                            // Custom text field for input
                            CustomTextField(
                              controller: countryController,
                              textInputType: TextInputType.name,
                              hintText: '  e.g., India',
                              onChanged: _filterCountries,
                            ),
                            if (filteredCountries.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 70),
                                child: Container(
                                  color: Colors.black38,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: filteredCountries.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        dense: true,
                                        enableFeedback: true,
                                        title: Text(filteredCountries[index], style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 14
                                        ),),
                                        onTap: () {
                                          setState(() {
                                            selectedCountry = filteredCountries[index];
                                            countryController.text = selectedCountry ?? '';
                                            filteredCountries = []; // Clear suggestions
                                          });
                                        },
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
                          textInputType: TextInputType.text,
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

