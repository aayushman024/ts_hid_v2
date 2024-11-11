// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/components/glassCards/addressedIssueCard.dart';
import 'package:ts_hid/globals/global_variables.dart';
import '../Models/get_all_issues.dart';
import '../Models/graph_model.dart';
import '../components/appDrawer.dart';
import 'package:http/http.dart' as http;

import 'issueDetail.dart';

class AddressedIssues extends StatefulWidget {
  const AddressedIssues({super.key});

  @override
  State<AddressedIssues> createState() => _AddressedIssuesState();
}

class _AddressedIssuesState extends State<AddressedIssues> {
  final String issueBaseURL = '$apiURL/api/addressed-issues/';

  late Future<List<GetAllIssues>> futureIssues;

  @override
  void initState() {
    super.initState();
    futureIssues = fetchAllResolvedIssues();
  }

  Future<List<GetAllIssues>> fetchAllResolvedIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse(issueBaseURL),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> issuesList = jsonData['issues'];
      List<GetAllIssues> issues =
      issuesList.map((issueJson) => GetAllIssues.fromJson(issueJson)).toList();
      issues.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return issues;
    } else {
      throw Exception('Failed to load issues');
    }
  }


  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    DateTime utcTime = DateTime.parse(dateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon : Icon(Icons.arrow_back_ios, color: Colors.white,)),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child:
                  Image.asset('assets/logo.png', height: screenHeight * 0.015),
            ),
            IconButton(
              onPressed: () {
                futureIssues = fetchAllResolvedIssues();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.transparent,
                    duration: Duration(seconds: 4),
                    elevation: 0,
                    content: AwesomeSnackbarContent(
                      title: 'Success!',
                      message: 'Page Successfully Refreshed',
                      contentType: ContentType.success,
                      messageTextStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    )));
              },
              icon: Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        //drawer: CustomAppDrawer(),
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
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  Text(
                    'ADDRESSED ISSUES',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('(Resolved + Closed)',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                    ),
                  ),
                  Divider(
                    endIndent: screenWidth * 0.38,
                    indent: screenWidth * 0.38,
                    height: screenHeight * 0.035,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: FutureBuilder<List<GetAllIssues>>(
                      future: futureIssues,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading issues: ${snapshot.error}',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No Addressed Issues Found!',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        List<GetAllIssues> resolvedIssues = snapshot.data!.toList();

                        if (resolvedIssues.isEmpty) {
                          return Center(
                            child: Text(
                              'No Resolved Issues Found!',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: resolvedIssues.length,
                          itemBuilder: (context, index) {
                            final issue = resolvedIssues[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        IssueDetail(issue: resolvedIssues[index]),
                                  ),
                                );
                              },
                              child: AddressedIssueCard(
                                severity: issue.severity,
                                region: issue.region,
                                country: issue.country,
                                customer: issue.customer,
                                prodFamily: issue.productFamily,
                                titleText: issue.title,
                                postedTime: formatDate(issue.createdAt!),
                                ticketNumber: issue.ticket,
                                softwareVersion: issue.technology,
                                status: issue.status,
                                productName: issue.product,
                                description: issue.description,
                                requesterName: 'Requested by : ${issue.name}',
                                textColor: getColor(issue.severity!),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
