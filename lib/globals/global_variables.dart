import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_hid/components/comments.dart';
import 'package:ts_hid/controllers/controllers.dart';

import '../Models/get_all_issues.dart';

//team selection variables
int selectedItemsIndex = 1;
List<String>teams = ['IMEA', 'APAC', 'NAR'];

//credential check messages
String? errorUsernameMessage;
String? errorPasswordMessage;

//PieChart count variables
double burningCount = 2;
double hotCount = 3;
double trackingCount = 5;
double totalCount = burningCount + hotCount + trackingCount;

//Severities variables
int selectedSeverityIndex = 1;
final List<String> severities = ['Critical', 'Amber', 'Tracking'];

//Timestamp variables
DateTime unformattedPostedTime = DateTime.now();
String postedTime = unformattedPostedTime.toString();
String formattedPostedTime = DateFormat('dd/mm/yyyy, HH:MM', ).format(unformattedPostedTime);
void getCurrentTime(){
   formattedPostedTime;
}
DateTime currentTime = DateTime.now();

//Status Variables
List <String> status = ['Newly Registered', 'In-Progress', 'Pending', 'Resolved', 'Closed'];
List <String> allStatus = ['Newly Registered', 'In-Progress', 'Pending', 'Resolved', 'Closed', 'Re-Opened'];
List <String> addressedStatus = ['Re-Opened', 'Resolved', 'Closed'];
List <String> ifPendingStatus = ['In-Progress', 'Resolved', 'Closed'];
List <String> ifInProgressStatus = ['Pending', 'Resolved', 'Closed'];
List <String> reopenedStatus = ['In-Progress', 'Pending', 'Resolved', 'Closed'];
String? selectedStatus;
int selectedStatusIndex = 0;

//severity color decider
Color getColor(String text) {
  if (text.startsWith('C')) {
    return Colors.red;
  } else if (text.startsWith('c')) {
    return Colors.red;
  } else if (text.startsWith('A')) {
    return Colors.orange;
  } else if (text.startsWith('a')) {
    return Colors.orange;
  }
  else {
    return Colors.green; // Default color
  }
}

List <String> commentContent = [commentsController.text];
List <String> commentor = ['admin'];
List <String> commentTime = [DateTime.now().toString()];

//replace pushReplacement after the presentation