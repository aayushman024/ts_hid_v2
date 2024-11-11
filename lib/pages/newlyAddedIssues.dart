// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import '../Models/get_all_issues.dart';
import '../components/glassCards/newIssueCard.dart';
import '../components/glassCards/notesCard.dart';
import '../globals/global_variables.dart';
import 'issueDetail.dart';
import 'package:http/http.dart' as http;

class NewlyAddedIssues extends StatefulWidget {
  const NewlyAddedIssues({super.key});

  @override
  State<NewlyAddedIssues> createState() => _NewlyAddedIssuesState();
}

class _NewlyAddedIssuesState extends State<NewlyAddedIssues> {
  DateTime? notificationClickTime;
  late Future<List<GetAllIssues>> futureIssues;

  final String issueBaseURL = '$apiURL/api/issues/';
  List<GetAllIssues> allIssues = [];

  @override
  void initState() {
    super.initState();
    futureIssues = fetchNewIssues();
  }

  void saveClickTime() async {
    DateTime clickTime = DateTime.now().toUtc();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationClickTime', clickTime.toIso8601String());;
    print('Saved notificationClickTime: $clickTime');
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.transparent,
            duration: Duration(seconds: 4),
            elevation: 0,
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: '$unreadCount Issues marked as read',
              contentType: ContentType.success,
              messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            )
        )
    );
    setState(() {
      allIssues.clear();
      unreadCount = 0;
    });
  }

  Future<List<GetAllIssues>> fetchNewIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final savedTimeString = prefs.getString('notificationClickTime');

    DateTime? savedTime;
    if (savedTimeString != null) {
      savedTime = DateTime.parse(savedTimeString);
    }

    final response = await http.get(
      Uri.parse(issueBaseURL),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<GetAllIssues> issues = jsonData.map((json) => GetAllIssues.fromJson(json)).toList();

      List<String> readIssueIds = await getReadIssueIds();

      issues.removeWhere((issue) => readIssueIds.contains(issue.id.toString()));

      issues.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      allIssues = issues;

      if (savedTime != null) {
        allIssues = allIssues.where((issue) {
          DateTime issueCreatedAt = DateTime.parse(issue.lastUpdated!);
          return issueCreatedAt.isAfter(savedTime!);
        }).toList();
      }

      setState(() {
        unreadCount = allIssues.length;
      });
      return allIssues;
    } else {
      throw Exception('Failed to load issues');
    }
  }

  void markAsRead(int index) {
    final issue = allIssues[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Mark Issue as Read?',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                saveReadIssueId(issue.id!);
                setState(() {
                  allIssues.removeAt(index);
                  unreadCount--;
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Issue marked as read'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                    showCloseIcon: true,
                  ),
                );
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveReadIssueId(int issueId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? readIssues = prefs.getStringList('readIssues') ?? [];

    String issueIdStr = issueId.toString();

    if (!readIssues.contains(issueIdStr)) {
      readIssues.add(issueIdStr);
      await prefs.setStringList('readIssues', readIssues);
    }
  }

  Future<List<String>> getReadIssueIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('readIssues') ?? [];
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    DateTime utcTime = DateTime.parse(dateString).toUtc();
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recently Added',
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AllIssuesPage()));
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder<List<GetAllIssues>>(
            future: futureIssues,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error Loading Issues. Check your Internet Connection!',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 20, top: 10),
                      child: ListTile(
                        onTap: saveClickTime,
                        title: Text('Mark all as read ($unreadCount)',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14
                          ),),
                        leading: Icon(Icons.clear_all_outlined, color: Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final issue = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => IssueDetail(issue: issue),
                                ),
                              );
                            },
                            child: NewIssueCard(
                              severity: issue.severity,
                              textColor: getColor(issue.severity.toString()),
                              postedTime: formatDate(issue.createdAt!),
                              prodFamily: issue.productFamily,
                              customer: issue.customer,
                              country: issue.country,
                              region: '🌐 ${issue.region}',
                              titleText: issue.title,
                              ticketNumber: issue.ticket,
                              status: issue.status,
                              softwareVersion: issue.technology,
                              wasReopened: issue.wasReopened ?? false,
                              markAsRead: (){
                                markAsRead(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Text(
                  'No recently added issues found',
                  style: GoogleFonts.poppins(color: Colors.white30, fontSize: 20, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
