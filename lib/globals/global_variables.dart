import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_hid/controllers/controllers.dart';

//api url
String apiURL = apiAWS;
String apiAWS = 'http://15.207.244.117';
String apiNokia = 'http://tshid.int.net.nokia.com/';


//team selection variables
int selectedItemsIndex = 1;
List<String>teams = ['EMEA', 'APAC', 'NAR', 'CALA'];

int selectedTechnologyIndex = 1;
List <String> technology = ['Optics', 'IP', 'FN'];
List<String> countries = ["Afghanistan",
  "Åland Islands",
  "Albania",
  "Algeria",
  "American Samoa",
  "Andorra",
  "Angola",
  "Anguilla",
  "Antarctica",
  "Antigua and Barbuda",
  "Argentina",
  "Armenia",
  "Aruba",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bermuda",
  "Bhutan",
  "Bolivia",
  "Bonaire, Sint Eustatius and Saba",
  "Bosnia and Herzegovina",
  "Botswana",
  "Bouvet Island",
  "Brazil",
  "British Indian Ocean Territory",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cabo Verde",
  "Cambodia",
  "Cameroon",
  "Canada",
  "Cayman Islands",
  "Central African Republic",
  "Chad",
  "Chile",
  "China",
  "Christmas Island",
  "Cocos (Keeling) Islands",
  "Colombia",
  "Comoros",
  "Congo",
  "Congo (the Democratic Republic of the)",
  "Cook Islands",
  "Costa Rica",
  "Côte d'Ivoire",
  "Croatia",
  "Cuba",
  "Curaçao",
  "Cyprus",
  "Czechia",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Eritrea",
  "Estonia",
  "Eswatini",
  "Ethiopia",
  "Falkland Islands (Malvinas)",
  "Faroe Islands",
  "Fiji",
  "Finland",
  "France",
  "French Guiana",
  "French Polynesia",
  "French Southern Territories",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Gibraltar",
  "Greece",
  "Greenland",
  "Grenada",
  "Guadeloupe",
  "Guam",
  "Guatemala",
  "Guernsey",
  "Guinea",
  "Guinea-Bissau",
  "Guyana",
  "Haiti",
  "Heard Island and McDonald Islands",
  "Holy See",
  "Honduras",
  "Hong Kong",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Isle of Man",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jersey",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kiribati",
  "Kuwait",
  "Kyrgyzstan",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Macao",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Marshall Islands",
  "Martinique",
  "Mauritania",
  "Mauritius",
  "Mayotte",
  "Mexico",
  "Micronesia",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Montserrat",
  "Morocco",
  "Mozambique",
  "Myanmar",
  "Namibia",
  "Nauru",
  "Nepal",
  "Netherlands",
  "New Caledonia",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Niue",
  "Norfolk Island",
  "North Korea",
  "North Macedonia",
  "Northern Mariana Islands",
  "Norway",
  "Oman",
  "Pakistan",
  "Palau",
  "Palestine, State of",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Pitcairn",
  "Poland",
  "Portugal",
  "Puerto Rico",
  "Qatar",
  "Réunion",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Barthélemy",
  "Saint Helena, Ascension and Tristan da Cunha",
  "Saint Kitts and Nevis",
  "Saint Lucia",
  "Saint Martin (French part)",
  "Saint Pierre and Miquelon",
  "Saint Vincent and the Grenadines",
  "Samoa",
  "San Marino",
  "Sao Tome and Principe",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Sint Maarten (Dutch part)",
  "Slovakia",
  "Slovenia",
  "Solomon Islands",
  "Somalia",
  "South Africa",
  "South Georgia and the South Sandwich Islands",
  "South Korea",
  "South Sudan",
  "Spain",
  "Sri Lanka",
  "Sudan",
  "Suriname",
  "Svalbard and Jan Mayen",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor-Leste",
  "Togo",
  "Tokelau",
  "Tonga",
  "Trinidad and Tobago",
  "Tunisia",
  "Türkiye",
  "Turkmenistan",
  "Turks and Caicos Islands",
  "Tuvalu",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "United States Minor Outlying Islands",
  "United States of America",
  "Uruguay",
  "Uzbekistan",
  "Vanuatu",
  "Venezuela",
  "Vietnam",
  "Virgin Islands (British)",
  "Virgin Islands (U.S.)",
  "Wallis and Futuna",
  "Western Sahara",
  "Yemen",
  "Zambia",
  "Zimbabwe"
];


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

//chart data
class ChartData {
  ChartData(this.category, this.count, this.color);
  final String category;
  final int count;
  final Color color;
}

//Timestamp variables
DateTime unformattedPostedTime = DateTime.now();
String postedTime = unformattedPostedTime.toString();
String formattedPostedTime = DateFormat('dd/mm/yyyy, HH:MM', ).format(unformattedPostedTime);
void getCurrentTime(){
   formattedPostedTime;
}
DateTime currentTime = DateTime.now();

//Status Variables
List <String> status = ['Newly Registered', 'In Progress', 'Pending', 'Resolved', 'Closed'];
List <String> allStatus = ['Newly Registered', 'In-Progress', 'Pending', 'Resolved', 'Closed', 'Re-Opened'];
List <String> addressedStatus = ['Re-Opened', 'Resolved', 'Closed'];
List <String> ifPendingStatus = ['In Progress', 'Resolved', 'Closed'];
List <String> ifInProgressStatus = ['Pending', 'Resolved', 'Closed'];
List <String> reopenedStatus = ['In Progress', 'Pending', 'Resolved', 'Closed'];
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

//filters
bool isAPACchecked = false;
bool isEMEAchecked = false;
bool isNARchecked = false;
bool isCALAchecked = false;
bool isOPTICSchecked = false;
bool isFNchecked = false;
bool isIPchecked = false;
bool isExpanded = false;

//button disable
bool  isButtonDisabled = false;

List <String> commentContent = [commentsController.text];
List <String> commentor = ['admin'];
List <String> commentTime = [DateTime.now().toString()];

int unreadCount = 0;


