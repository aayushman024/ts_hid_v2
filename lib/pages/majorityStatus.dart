import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/get_all_issues.dart';
import '../Models/graph_model.dart';
import '../components/glassCards/notesCard.dart';
import '../globals/global_variables.dart';
import 'issueDetail.dart';

class MajorityStatus extends StatefulWidget {
  const MajorityStatus({super.key});

  @override
  State<MajorityStatus> createState() => _MajorityStatusState();
}

class _MajorityStatusState extends State<MajorityStatus> {
  final String issueBaseURL = '$apiURL/api/issues/';
  final String graphBaseURL = '$apiURL/api/home/';


  List<GetAllIssues> filteredIssues = [];
  String? hottestList;
  String? userRole;

  late Future<List<GetAllIssues>> futureIssues;
  late Future<GraphModel> futureGraph;

  @override
  void initState() {
    super.initState();
    futureIssues = fetchAllIssues();
    futureGraph = fetchGraph();
    getUserRole();
  }

  Future<void> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole');
    });
  }

  Future<List<GetAllIssues>> fetchAllIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final response = await http.get(Uri.parse(issueBaseURL),
        headers: {'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<GetAllIssues> issues =
      jsonData.map((json) => GetAllIssues.fromJson(json)).toList();
      issues.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return issues;
    } else {
      throw Exception('Failed to load issues');
    }
  }

  Future<GraphModel> fetchGraph() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final responseGraph = await http.get(Uri.parse(graphBaseURL),
          headers: {'Authorization': 'Token $token'});

      if (responseGraph.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(responseGraph.body);
        GraphModel graphModel = GraphModel.fromJson(jsonData);
        return graphModel;
      } else {
        throw Exception('Failed to load graph');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetAllIssues>> fetchMajorityStatusIssues() async {
    try {
      final issues = await fetchAllIssues();
      final graphData = await fetchGraph();

      String majorityStatus = graphData.counts.maxStatus;
      List<GetAllIssues> majorityStatusIssues = issues.where((issue) {
        return issue.status == majorityStatus;
      }).toList();

      return majorityStatusIssues;
    } catch (e) {
      throw Exception('Failed to load issues for major contributor');
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child:
              Image.asset('assets/logo.png', height: screenHeight * 0.015),
            ),
          ],
          backgroundColor: Colors.black,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: FutureBuilder(
                      future: fetchGraph(),
                      builder: (context, snapshot) {
                        final graphData = snapshot.data;
                        return Text(
                          'Issues marked as ${graphData?.counts.maxStatus}',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        );
                      }),
                ),
                Divider(
                  indent: screenWidth*0.4,
                  endIndent: screenWidth*0.4,
                  height: screenHeight*0.03,
                  color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FutureBuilder<List<GetAllIssues>>(
                    future: fetchMajorityStatusIssues(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: RefreshProgressIndicator(
                          color: Colors.blue, backgroundColor: Colors.white,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error Loading Issues. Check your Internet Connection!',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
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
                              child: NotesCard(
                                severity: issue.severity,
                                textColor: getColor(issue.severity.toString()),
                                postedTime: formatDate(issue.createdAt ?? 'Unknown'),
                                prodFamily: issue.productFamily,
                                customer: issue.customer,
                                country: issue.country,
                                region: '🌐 ${issue.region}',
                                titleText: issue.title,
                                ticketNumber: issue.ticket,
                                status: issue.status,
                                softwareVersion: issue.technology,
                                wasReopened: issue.wasReopened = false,
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No issues found for majority status',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
