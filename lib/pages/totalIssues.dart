import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/get_all_issues.dart';
import '../Models/graph_model.dart';
import '../components/glassCards/notesCard.dart';
import '../controllers/controllers.dart';
import '../globals/global_variables.dart';
import 'issueDetail.dart';

class TotalIssues extends StatefulWidget {
  const TotalIssues({super.key});

  @override
  State<TotalIssues> createState() => _TotalIssuesState();
}

class _TotalIssuesState extends State<TotalIssues> {
  final String issueBaseURL = '$apiURL/api/issues/';

  List<GetAllIssues> filteredIssues = [];
  List<GetAllIssues> allIssues = [];
  String? hottestList;
  String? userRole;

  late Future<List<GetAllIssues>> futureIssues;

  @override
  void initState() {
    super.initState();
    futureIssues = fetchAllIssues();
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


  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    DateTime utcTime = DateTime.parse(dateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
  }

  void filterIssues(String query) {
    List<String> searchTerms = query.toLowerCase().split(' ');

    List<GetAllIssues> tempIssues = allIssues.where((issue) {

      return searchTerms.every((term) {
        return (issue.title!.toLowerCase().contains(term) ||
            issue.name!.toLowerCase().contains(term) ||
            issue.severity!.toLowerCase().contains(term) ||
            issue.status!.toLowerCase().contains(term) ||
            issue.country!.toLowerCase().contains(term) ||
            issue.product!.toLowerCase().contains(term) ||
            issue.productFamily!.toLowerCase().contains(term) ||
            issue.ticket!.toLowerCase().contains(term) ||
            issue.customer!.toLowerCase().contains(term) ||
            issue.createdAt!.toLowerCase().contains(term) ||
            issue.region!.toLowerCase().contains(term) ||
            issue.technology!.toLowerCase().contains(term) ||
            issue.softwareVersion!.toLowerCase().contains(term) ||
            issue.problemTicket!.toLowerCase().contains(term) ||
            issue.description!.toLowerCase().contains(term));
      });
    }).toList();

    setState(() {
      filteredIssues = tempIssues;
    });
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
                  child: Text(
                          'All Issues Till Date',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                ),
                Divider(
                  indent: screenWidth*0.4,
                  endIndent: screenWidth*0.4,
                  height: screenHeight*0.03,
                  color: Colors.white,),

                // Padding(
                //   padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                //   child: TextField(
                //       onChanged: (value) {
                //         filterIssues(value);
                //       },
                //       cursorColor: Colors.white30,
                //       controller: searchController,
                //       maxLines: null,
                //       autofocus: false,
                //       keyboardType: TextInputType.name,
                //       style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                //       decoration: InputDecoration(
                //         suffixIcon: Icon(
                //           Icons.search_rounded,
                //           color: Colors.white54,
                //         ),
                //         filled: true,
                //         fillColor: Color(0xff021526),
                //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                //         hintText: '   Search Issues',
                //         hintStyle: GoogleFonts.poppins(color: Colors.white54, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                //       )),
                // ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FutureBuilder<List<GetAllIssues>>(
                    future: fetchAllIssues(), // Using the merged list
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: RefreshProgressIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.white,
                          ),
                        );
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
