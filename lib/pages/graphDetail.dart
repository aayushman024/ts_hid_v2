import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/get_all_issues.dart';
import '../components/glassCards/notesCard.dart';
import '../globals/global_variables.dart';
import 'issueDetail.dart';

class GraphDetail extends StatefulWidget {
  const GraphDetail({super.key});

  @override
  State<GraphDetail> createState() => _GraphDetailState();
}

class _GraphDetailState extends State<GraphDetail> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Future<List<GetAllIssues>> futureIssues;
  List<GetAllIssues> allIssues = [];
  List<GetAllIssues> filteredIssues = [];
  List<GetAllIssues> criticalIssues = [];
  List<GetAllIssues> amberIssues = [];
  List<GetAllIssues> trackingIssues = [];
  int criticalIssuesCount = 0;
  int amberIssuesCount = 0;
  int trackingIssuesCount = 0;
  final String issueBaseURL = '$apiURL/api/issues/';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    futureIssues = fetchAllIssues();
  }
  Future<List<GetAllIssues>> fetchAllIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.get(Uri.parse(issueBaseURL), headers: {'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<GetAllIssues> issues = jsonData.map((json) => GetAllIssues.fromJson(json)).toList();
      issues.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      allIssues = issues;
      filteredIssues = allIssues.where((issue) =>
      issue.status?.trim() != "Closed" &&
          issue.status?.trim() != "Resolved").toList();

      // Classify issues based on severity
      criticalIssues = filteredIssues.where((issue) => issue.severity == 'Critical').toList();
      amberIssues = filteredIssues.where((issue) => issue.severity == 'Amber').toList();
      trackingIssues = filteredIssues.where((issue) => issue.severity == 'Tracking').toList();

      setState(() {
        criticalIssuesCount = criticalIssues.length;
        amberIssuesCount = amberIssues.length;
        trackingIssuesCount = trackingIssues.length;
      });


      return filteredIssues; // Return filtered issues
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        bottom: TabBar(
          indicatorColor: Colors.blue,
          dividerColor: Colors.transparent,
          labelStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 15
          ),
          controller: tabController,
          tabs: [
            Tab(child: Text('Critical (${criticalIssuesCount})', style: TextStyle(color: Colors.red),),),
            Tab(child: Text('Amber (${amberIssuesCount})', style: TextStyle(color: Colors.orange),),),
            Tab(child: Text('Tracking (${trackingIssuesCount})', style: TextStyle(color: Colors.green),),),
          ],
        ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
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
              } else if (snapshot.hasData) {
                return TabBarView(
                  controller: tabController,
                  children: [
                    buildIssueList(criticalIssues),
                    buildIssueList(amberIssues),
                    buildIssueList(trackingIssues),
                  ],
                );
              } else {
                return Center(child: Text('No issues found', style: TextStyle(color: Colors.white)));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildIssueList(List<GetAllIssues> issueList) {
    if (issueList.isEmpty) {
      return Center(child: Text('No issues found', style: TextStyle(color: Colors.white)));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: issueList.length,
      itemBuilder: (context, index) {
        final issue = issueList[index]; // Use issueList instead of filteredIssues
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => IssueDetail(issue: issue),
              ),
            );
          },
          child: NotesCard(
            severity: issue.severity,
            textColor: getColor(issue.severity.toString()),
            postedTime: formatDate(issue.createdAt ?? ''), // Ensure createdAt is not null
            prodFamily: issue.productFamily,
            customer: issue.customer,
            country: issue.country,
            region: '🌐 ${issue.region ?? "Unknown"}', // Handle null region
            titleText: issue.title,
            ticketNumber: issue.ticket,
            status: issue.status,
            softwareVersion: issue.technology,
            wasReopened: issue.wasReopened ?? false,
          ),
        );
      },
    );
  }
}
