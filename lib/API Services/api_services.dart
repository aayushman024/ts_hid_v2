import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import '../Models/get_all_issues.dart';

class APIservices {

  String baseURL = 'http://10.131.213.206:8000/api/issues/';

  //get all issues

Future<List<GetAllIssues>> fetchAllIssues() async{
  final response = await http.get(Uri.parse(baseURL));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    List<GetAllIssues> issues = jsonData.map((json) => GetAllIssues.fromJson(json)).toList();
    return issues;
  } else {
    throw Exception('Failed to load issues');
  }
}

//add an issue


//update an issue


}