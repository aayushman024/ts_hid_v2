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
import '../Models/profileModel.dart';
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
    fetchProfile();
  }

  void resetTextField() {
    requesterNameController.clear();
    productNameController.clear();
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

  Future<void> _submitIssue() async {
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
      "was_reopened": false,
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.post(
      Uri.parse('$apiURL/api/issues/'),
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
     setState(() {
       isButtonDisabled = false;
     });
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

  late Future<ProfileModel> futureProfile;
  final String profileBaseURL = 'http://15.207.244.117/api/profile/';

  Future<ProfileModel> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final responseProfile = await http.get(Uri.parse(profileBaseURL), headers: {'Authorization': 'Token $token'});

      if (responseProfile.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(responseProfile.body);
        ProfileModel profileModel = ProfileModel.fromJson(jsonData);
        return profileModel;
      } else {
        throw Exception('Failed to load details');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> importProfile() async {
    try {
      ProfileModel profile = await fetchProfile();
      requesterNameController.text = profile.username ?? 'N/A';
      setState(() {
        selectedRegion = profile.region;
        selectedTechnology = profile.technology;
      });
      countryController.text = profile.country ?? 'N/A';
    } catch (e) {
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
                            setState(() {
                              isButtonDisabled = false;
                            });
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
                        TextButton(
                            onPressed: importProfile,
                            child: Text('Import from profile', style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 12
                            ),),
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
                                            filteredCountries = [];
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
                          textInputType: TextInputType.text,
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
                          textInputType: TextInputType.name,
                          hintText: '  e.g., 123456',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            'Customer:',
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
                              onPressed: isButtonDisabled ? null : () {
                                _submitIssue();
                                setState(() {
                                  isButtonDisabled = true;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    isButtonDisabled ? Colors.black54 : Color(0xffB1DEFF)),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.fromLTRB(80, 14, 80, 14)),
                              ),
                              child: Text(
                                'Post Issue',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
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
