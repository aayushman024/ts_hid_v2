// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_hid/Models/commentsModel.dart';
import 'package:ts_hid/components/comments.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/components/glassCards/notesCard.dart';
import 'package:ts_hid/controllers/controllers.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'package:ts_hid/pages/allIssuesPage.dart';
import 'package:ts_hid/pages/editIssue.dart';

import '../Models/get_all_issues.dart';
import '../components/Alerts/addIssueCredAlert.dart';
import '../components/dropDown.dart';
import '../components/tagsButton.dart';
import '../globals/global_variables.dart';
import 'package:http/http.dart' as http;

class IssueDetail extends StatefulWidget {
  final GetAllIssues issue;

  const IssueDetail({super.key, required this.issue});

  @override
  State<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetail> {
  late Future<List<CommentsModel>> futureComments;
  
  String? userRole;

  @override
  void initState() {
    super.initState();
    futureComments = fetchComments(widget.issue.id!);
    getUserRole();
  }

  late int issueID;

  Future<List<CommentsModel>> fetchComments(issueID) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final String commentBaseURL = 'http://15.207.244.117/issues/$issueID/comments/';
    final response = await http.get(Uri.parse(commentBaseURL),
    headers: {
      'Authorization' : 'Token $token'
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<CommentsModel> comments = jsonData.map((json) => CommentsModel.fromJson(json)).toList();
      comments.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return comments;
    } else {
      throw Exception('Failed to load updates');
    }
  }

  Future<void> submitComment() async {
    if (commentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Error!',
                message: 'Textfield is empty',
                contentType: ContentType.failure,
                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              )
          )
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final username = prefs.getString('username');

    final Map<String, dynamic> commentData = {
        "content": commentsController.text,
        "user": username,
    };

    final commentResponse = await http.post(
      Uri.parse('http://15.207.244.117/issues/${widget.issue.id}/comments/'),
      headers: {'Content-Type': 'application/json',
        'Authorization' : 'Token $token'},
      body: jsonEncode(commentData),
    );

    if (commentResponse.statusCode == 201) {
      commentsController.clear();
      Navigator.of(context).pop();
      setState(() {
        futureComments = fetchComments(widget.issue.id);
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.transparent,
              duration: Duration(seconds: 4),
              elevation: 0,
              content: AwesomeSnackbarContent(
                title: 'Error!',
                message: 'Failed to post update',
                contentType: ContentType.failure,
                messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              )
          )
      );
    }
  }

  String formatDate2(String dateString) {
    DateTime utcTime = DateTime.parse(dateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    DateFormat formattedDate = DateFormat('dd MMM yyyy, hh:mm a');
    return formattedDate.format(istTime);
  }

  String formatCommentDate(String commentDateString) {
    DateTime utcTime = DateTime.parse(commentDateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    DateFormat formattedCommentDate = DateFormat('dd MMM yyyy, hh:mm a');
    return formattedCommentDate.format(istTime);
  }

  Future <void> getUserRole() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
        ),
        actions: [
          (userRole == 'Global Manager' || userRole == 'Managers' || userRole == 'Regional Manager') ? IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditIssue(issue: widget.issue)));
              },
              icon: Icon(
                Icons.edit_note,
                color: Colors.white,
              )
          ) : Text('Permission Required', style: GoogleFonts.poppins(color: Colors.white30, fontSize: 12),),
        ],
      ),
      body: Container(
        height: double.infinity,
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TagsButton(
                            tagBoxColor: Color(0xff021526),
                            textColor: getColor(widget.issue.severity!),
                            tags: widget.issue.severity,
                          ),
                          TagsButton(
                            tagBoxColor: Color(0xff021526),
                            textColor: Colors.white,
                            tags: widget.issue.status,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            tags: '🌐 ${widget.issue.region!}',
                            textColor: Colors.white,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: widget.issue.country,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: widget.issue.productFamily,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: widget.issue.product,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: widget.issue.customer,
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: 'SF Case No. : ${widget.issue.ticket!}',
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: 'PRB. : ${widget.issue.problemTicket!}',
                          ),
                          TagsButton(
                            tagBoxColor: Colors.white30,
                            textColor: Colors.white,
                            tags: 'S/w Ver : ${widget.issue.technology!}',
                          ),
                          // TagsButton(
                          //   tagBoxColor: Colors.white30,
                          //   textColor: Colors.white,
                          //   tags: widget.issue.name!,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      ListTile(
                        horizontalTitleGap: screenWidth * 0.02,
                        leading: Icon(
                          Icons.access_time,
                          color: Colors.white30,
                          size: screenHeight * 0.025,
                        ),
                        title: Text('Created on : ${formatDate2(widget.issue.createdAt!)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: screenWidth * 0.02,
                        leading: Icon(
                          Icons.access_time,
                          color: Colors.white30,
                          size: screenHeight * 0.025,
                        ),
                        title: Text('Last Updated on : ${formatDate2(widget.issue.lastUpdated!)}',
                          style: GoogleFonts.poppins(
                            color: Colors.white38,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        widget.issue.title!,
                        style: TextStyle(
                            fontFamily: 'NokiaPureHeadline_Bd',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: Text('Requested by : ${widget.issue.name!}', style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        ),),
                      ),

                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text('Current Summary :', style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                      Text(
                        widget.issue.summary!,
                        style:TextStyle(
                            fontFamily: 'NokiaPureHeadline_ULt',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w200
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.07,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text('Issue Description :', style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                      Text(
                        widget.issue.description!,
                        style:TextStyle(
                            fontFamily: 'NokiaPureHeadline_ULt',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w200
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.075,
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                   'Status Update :',
                    style:TextStyle(
                        fontFamily: 'NokiaPureText_Rg',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                margin: EdgeInsets.only(bottom: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  color: Colors.black54,
                ),
                child: Column(
                  children: [
                    FutureBuilder<List<CommentsModel>>(
                      future: futureComments,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: RefreshProgressIndicator(color: Colors.white,));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Check your internet!', style: TextStyle(color: Colors.white),));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No updates yet.',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),
                          ));
                        } else {
                          final comments = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Comment(
                                text: comment.content!,
                                user: comment.user!,
                                time: formatCommentDate(comment.createdAt!),
                              );
                            },
                          );
                        }
                      },
                    ),
                    (userRole == 'Global Manager' || userRole == 'Managers' || userRole == 'Regional Manager') ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Color(0xff021526),
                              content: TextField(
                                  controller: commentsController,
                                  minLines: 1,
                                  maxLength: 150,
                                  autofocus: true,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xff021526),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    hintText: 'Post your Update',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic),
                                  )),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.of(context).pop();
                                        commentsController.clear();
                                      });
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    )),

                                TextButton(
                                    onPressed: (){
                                      submitComment();
                                    },
                                    child: Text(
                                      'Post',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.black.withOpacity(0.5)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                          padding: WidgetStateProperty.all(EdgeInsets.all(15)),
                        ),
                        child: Text(
                          'Post an Update',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

