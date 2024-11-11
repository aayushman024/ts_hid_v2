// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ts_hid/Models/get_all_issues.dart';
import 'package:ts_hid/Models/graph_model.dart';
import 'package:ts_hid/components/appDrawer.dart';
import 'package:ts_hid/components/glassCards/glassCard.dart';
import 'package:ts_hid/components/glassCards/notesCard.dart';
import 'package:ts_hid/controllers/controllers.dart';
import 'package:ts_hid/globals/global_variables.dart';
import 'package:ts_hid/pages/addressedIssues.dart';
import 'package:ts_hid/pages/graphDetail.dart';
import 'package:ts_hid/pages/hottestCountry.dart';
import 'package:ts_hid/pages/issueDetail.dart';
import 'package:http/http.dart' as http;
import 'package:ts_hid/pages/majorContributor.dart';
import 'package:ts_hid/pages/majorityStatus.dart';
import 'package:ts_hid/pages/newlyAddedIssues.dart';
import 'package:ts_hid/pages/totalIssues.dart';
import '../components/glassCards/dashboardCards.dart';
import 'addIssue.dart';

class AllIssuesPage extends StatefulWidget {
  const AllIssuesPage({super.key});

  @override
  State<AllIssuesPage> createState() => AllIssuesPageState();
}

class AllIssuesPageState extends State<AllIssuesPage> {
  void resetTextField() {
    requesterNameController.clear();
    productNameController.clear();
    regionController.clear();
    productFamilyController.clear();
    countryController.clear();
    softwareVersionController.clear();
    issueTitleController.clear();
    issueDescriptionController.clear();
    customerNameController.clear();
    productTicketNumberController.clear();
    ticketNumberController.clear();
    ticketNumberController.clear();
    productTicketNumberController.clear();
  }

  late Future<List<GetAllIssues>> futureIssues;
  late Future<GraphModel> futureGraph;

  final String issueBaseURL = '$apiURL/api/issues/';
  final String graphBaseURL = '$apiURL/api/home/';

  List<GetAllIssues> allIssues = [];
  List<GetAllIssues> filteredIssues = [];
  List<GetAllIssues> newIssues = [];
  List<GetAllIssues> addedIssues = [];
  List<String?> uniqueCustomers = [];
  List<String?> uniqueCountries = [];
  String? userRole;
  String? selectedCustomer;
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
    futureIssues = fetchAllIssues();
    futureGraph = fetchGraph();
    getUserRole();
    fetchNewIssues();
  }

  Future<List<String>> getReadIssueIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('readIssues') ?? [];
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


  Future<void> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole');
    });
  }

  Future<List<GetAllIssues>> fetchAllIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final savedTimeString = prefs.getString('notificationClickTime');


    DateTime? savedTime;
    if (savedTimeString != null) {
      savedTime = DateTime.parse(savedTimeString);
    }

    final response = await http.get(Uri.parse(issueBaseURL), headers: {'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<GetAllIssues> issues = jsonData.map((json) => GetAllIssues.fromJson(json)).toList();
     // print("Fetched issues: ${issues.length}");
      issues.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      allIssues = issues;
      filteredIssues = allIssues.where((issue) => issue.status?.trim() != "Closed" && issue.status?.trim() != "Resolved").toList();

      //customers list
      uniqueCustomers = allIssues.map((issue) => issue.customer).toSet().where((customer) => customer != null && customer.isNotEmpty).toList();

      //countries list
      uniqueCountries = allIssues.map((issue) => issue.country).toSet().where((country) => country != null && country.isNotEmpty).toList();

      return filteredIssues;
    } else {
      throw Exception('Failed to load issues');
    }
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
                issue.description!.toLowerCase().contains(term)) &&
            (issue.status?.trim() != "Closed" && issue.status?.trim() != "Resolved");
      });
    }).toList();

    setState(() {
      filteredIssues = tempIssues;
    });
  }

  Future<GraphModel> fetchGraph() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    try {
      final responseGraph = await http.get(Uri.parse(graphBaseURL), headers: {'Authorization': 'Token $token'});

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

  String formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    DateTime utcTime = DateTime.parse(dateString);
    DateTime istTime = utcTime.add(Duration(hours: 5, minutes: 30));
    return DateFormat('dd MMM yyyy, hh:mm a').format(istTime);
  }

  void refreshPage() {
    setState(() {
      futureIssues = fetchAllIssues();
      futureGraph = fetchGraph();
    });
  }

  void clearFilters() {
    setState(() {
      isAPACchecked = false;
      isEMEAchecked = false;
      isNARchecked = false;
      isCALAchecked = false;
      isOPTICSchecked = false;
      isFNchecked = false;
      isIPchecked = false;
      selectedCustomer = null;
      selectedCountry = null;
      searchController.clear();
      filteredIssues = List.from(allIssues);
    });
  }

  void applyFilters() {
    List<String> selectedFilters = [];

    if (isAPACchecked) selectedFilters.add('APAC');
    if (isEMEAchecked) selectedFilters.add('EMEA');
    if (isNARchecked) selectedFilters.add('NAR');
    if (isCALAchecked) selectedFilters.add('CALA');
    if (isOPTICSchecked) selectedFilters.add('Optics');
    if (isFNchecked) selectedFilters.add('Fixed Network');
    if (isIPchecked) selectedFilters.add('IP');
    if (selectedCustomer != null) selectedFilters.add(selectedCustomer!);
    if (selectedCountry != null) selectedFilters.add(selectedCountry!);

    searchController.text = selectedFilters.join(' ').trim();
    filterIssues(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Image.asset('assets/logo.png', height: screenHeight * 0.015),
          ),
          Badge.count(
            isLabelVisible: unreadCount>0,
            alignment: Alignment(0.25, -0.4),
            count: unreadCount,
            child: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NewlyAddedIssues()));
              },
              icon: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.transparent,
                  duration: Duration(seconds: 4),
                  elevation: 0,
                  content: AwesomeSnackbarContent(
                    title: 'Success!',
                    message: 'Page Successfully Refreshed',
                    contentType: ContentType.success,
                    messageTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  )));
              refreshPage();
            },
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      drawer: CustomAppDrawer(),
      floatingActionButton: (userRole == 'Global Manager' || userRole == 'Regional Manager' || userRole == 'Managers' || userRole == 'Contributors')
          ? FloatingActionButton(
              tooltip: 'Add Issue',
              enableFeedback: true,
              elevation: 10,
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Color(0xff021526),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddIssue()),
                );
                resetTextField();
              },
              child: Icon(
                Icons.add,
                size: screenHeight * 0.045,
                color: Colors.white,
              ),
            )
          : null,
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.black12,
        onRefresh: () async {
          refreshPage();
        },
        child: Container(
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: GlassCard(
                      height: screenHeight * 1,
                      width: double.infinity,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        FutureBuilder<GraphModel>(
                            future: futureGraph,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: SizedBox(
                                  height: screenHeight * 0.33,
                                  width: screenWidth * 0.5,
                                  child: Lottie.asset('assets/loadingAnimation.json'),
                                ));
                              } else if (snapshot.hasError) {
                                return SizedBox.shrink();
                              } else if (!snapshot.hasData) {
                                return Center(child: Text('No graph data available.'));
                              } else {
                                final graphData = snapshot.data!;

                                final int criticalCount = graphData.counts.criticalCount ?? 0;
                                final int amberCount = graphData.counts.amberCount ?? 0;
                                final int trackingCount = graphData.counts.trackingCount ?? 0;
                                final int totalCount = graphData.counts.totalCount ?? 0;

                                final List<ChartData> chartData = [
                                  ChartData('Critical', criticalCount, Colors.red),
                                  ChartData('Amber', amberCount, Colors.orange),
                                  ChartData('Tracking', trackingCount, Colors.green),
                                ];

                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                      height: screenHeight * 0.25,
                                      width: screenWidth * 0.8,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => GraphDetail()));
                                        },
                                        child: SfCircularChart(
                                          margin: EdgeInsets.only(top: 10),
                                          title: ChartTitle(
                                              text: 'Ongoing Issues',
                                              textStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14)),
                                          annotations: <CircularChartAnnotation>[
                                            CircularChartAnnotation(
                                                widget: Text('$totalCount',
                                                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)))
                                          ],
                                          borderWidth: 10,
                                          legend: Legend(
                                            position: LegendPosition.right,
                                            iconHeight: screenHeight * 0.02,
                                            isVisible: true,
                                            isResponsive: true,
                                            textStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
                                          ),
                                          series: <CircularSeries>[
                                            DoughnutSeries<ChartData, String>(
                                              // explode: true,
                                              // explodeGesture: ActivationMode.singleTap,
                                              enableTooltip: true,
                                              explodeOffset: '15%',
                                              radius: '85%',
                                              dataSource: chartData,
                                              xValueMapper: (ChartData data, _) => data.category,
                                              yValueMapper: (ChartData data, _) => data.count,
                                              pointColorMapper: (ChartData data, _) => data.color,
                                              dataLabelSettings: DataLabelSettings(
                                                  isVisible: true,
                                                  showZeroValue: true,
                                                  textStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                                              animationDuration: 1200,
                                              legendIconType: LegendIconType.seriesType,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                        FutureBuilder<GraphModel>(
                            future: futureGraph,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: SizedBox(
                                  height: screenHeight * 0.33,
                                  width: screenWidth * 0.5,
                                  child: Lottie.asset('assets/loadingAnimation.json'),
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Opacity(
                                          opacity: 0.9,
                                          child: SizedBox(
                                            height: screenHeight * 0.4,
                                            width: screenWidth * 0.6,
                                            child: Lottie.asset('assets/serverAnimation.json'),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Uh Oh!',
                                        style: GoogleFonts.poppins(color: Colors.white30, fontSize: 30, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                      Text(
                                        'Cannot connect to the server',
                                        style: GoogleFonts.poppins(color: Colors.white30, fontSize: 20, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.025,
                                      ),
                                      Text(
                                        '- Check you internet connectivity.\n- Try logging out and logging back in.',
                                        style: GoogleFonts.poppins(color: Colors.white30, fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ));
                              } else if (!snapshot.hasData) {
                                return Center(child: Text('No data available.'));
                              } else {
                                final graphData = snapshot.data!;

                                return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 0, bottom: 10),
                                    child: Center(
                                      child: Wrap(
                                        spacing: screenWidth * 0.008,
                                        runSpacing: screenHeight * 0.003,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HottestPage()));
                                            },
                                            child: DashBoardCard(
                                                width: screenWidth * 0.485,
                                                height: screenHeight * 0.22,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Hottest Country',
                                                              style:
                                                                  GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5, bottom: 10),
                                                              child: SizedBox(
                                                                height: screenHeight * 0.03,
                                                                width: screenWidth * 0.035,
                                                                child: Lottie.asset('assets/burningAnimation.json',
                                                                    fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '${graphData.counts.hottestCountry}',
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                                                        ),
                                                        Text(
                                                          '${graphData.counts.hottestIssueCount} Issues',
                                                          style:
                                                              GoogleFonts.poppins(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MajorContributor()));
                                            },
                                            child: DashBoardCard(
                                                width: screenWidth * 0.485,
                                                height: screenHeight * 0.22,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Major Contributor',
                                                              style:
                                                                  GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 3, bottom: 2),
                                                              child: SizedBox(
                                                                height: screenHeight * 0.033,
                                                                width: screenWidth * 0.035,
                                                                child: Lottie.asset('assets/vulnerableAnimation.json',
                                                                    fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '${graphData.counts.commonProduct}',
                                                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                                                        ),
                                                        Text(
                                                          '${graphData.counts.productIssueCount} Issues',
                                                          style:
                                                              GoogleFonts.poppins(color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MajorityStatus()));
                                            },
                                            child: DashBoardCard(
                                                width: screenWidth * 0.485,
                                                height: screenHeight * 0.22,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Majority Status',
                                                              style:
                                                                  GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5, right: 20, bottom: 10),
                                                              child: SizedBox(
                                                                height: screenHeight * 0.03,
                                                                width: screenWidth * 0.03,
                                                                child: Lottie.asset('assets/graphAnimation.json',
                                                                    fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          graphData.counts.maxStatus,
                                                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                                        ),
                                                        Text(
                                                          '${graphData.counts.statusIssueCount} Issues',
                                                          style:
                                                              GoogleFonts.poppins(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TotalIssues()));
                                            },
                                            child: DashBoardCard(
                                                width: screenWidth * 0.485,
                                                height: screenHeight * 0.22,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Total Issues TD',
                                                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                                        ),
                                                        Text(
                                                          '${graphData.counts.totalIssuesCount} Issues',
                                                          style:
                                                              GoogleFonts.poppins(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 20),
                                                          child: SizedBox(
                                                            height: screenHeight * 0.04,
                                                            width: screenWidth * 0.03,
                                                            child: Lottie.asset('assets/productAnimation.json',
                                                                fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   'Closed Issues TD',
                                                        //   style: GoogleFonts.poppins(
                                                        //       color: Colors.white,
                                                        //       fontSize: 15,
                                                        //       fontWeight: FontWeight.w500),
                                                        // ),
                                                        // Text(
                                                        //   '${graphData.counts.closedIssuesCount} ',
                                                        //   style: GoogleFonts
                                                        //       .poppins(
                                                        //       color: Colors
                                                        //           .white70,
                                                        //       fontSize: 14,
                                                        //       fontWeight:
                                                        //       FontWeight
                                                        //           .w500),
                                                        // ),
                                                        // SizedBox(height: screenHeight*0.01,),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddressedIssues()));
                                            },
                                            child: DashBoardCard(
                                                width: screenWidth * 0.98,
                                                height: screenHeight * 0.2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Text(
                                                              'Closed TD',
                                                              style:
                                                                  GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                                            ),
                                                            Text(
                                                              '${graphData.counts.closedIssuesCount} Issues',
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 20),
                                                              child: SizedBox(
                                                                height: screenHeight * 0.05,
                                                                width: screenWidth * 0.04,
                                                                child: Lottie.asset('assets/closedAnimation.json',
                                                                    fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 18),
                                                          child: VerticalDivider(
                                                            indent: screenHeight * 0.05,
                                                            endIndent: screenHeight * 0.05,
                                                            color: Colors.white54,
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Text(
                                                              'Resolved TD',
                                                              style:
                                                                  GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                                                            ),
                                                            Text(
                                                              '${graphData.counts.resolvedIssuesCount} Issues',
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 20),
                                                              child: SizedBox(
                                                                height: screenHeight * 0.04,
                                                                width: screenWidth * 0.03,
                                                                child: Lottie.asset('assets/completedAnimation.json',
                                                                    fit: BoxFit.cover, backgroundLoading: true, repeat: true),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ));
                              }
                            })
                      ]),
                    ),
                  ),
                  Text(
                    'Open Issues',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Divider(
                      color: Colors.white,
                      endIndent: screenWidth * 0.42,
                      indent: screenWidth * 0.42,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '   Filters    ',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: screenHeight * 0.024,
                          ),
                        ],
                      ),
                      expansionAnimationStyle: AnimationStyle(curve: Curves.easeInOutCubic, duration: Duration(milliseconds: 500)),
                      collapsedIconColor: Colors.white,
                      backgroundColor: Colors.black45,
                      shape: Border.all(color: Colors.transparent),
                      childrenPadding: EdgeInsets.only(top: 15, left: 5, right: 5),
                      expandedAlignment: Alignment.topLeft,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, right: 15),
                                    child: Text(
                                      'Technology :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'Optics',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isOPTICSchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isOPTICSchecked = value ?? false;
                                        });
                                      }),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'IP',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isIPchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isIPchecked = value ?? false;
                                        });
                                      }),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'Fixed Network',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isFNchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isFNchecked = value ?? false;
                                        });
                                      }),
                                  SizedBox(
                                    height: screenHeight * 0.05,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10, right: 15),
                                    child: Text(
                                      'Region :',
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'APAC',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isAPACchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isAPACchecked = value ?? false;
                                        });
                                      }),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'EMEA',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isEMEAchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isEMEAchecked = value ?? false;
                                        });
                                      }),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'NAR',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isNARchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isNARchecked = value ?? false;
                                        });
                                      }),
                                  CheckboxListTile(
                                      dense: true,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      checkboxShape: CircleBorder(),
                                      title: Text(
                                        'CALA',
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                      ),
                                      value: isCALAchecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isCALAchecked = value ?? false;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    hint: Text(
                                      'Select Customer   ',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                    ),
                                    dropdownColor: Colors.black,
                                    value: selectedCustomer,
                                    items: uniqueCustomers
                                        .map((customer) => DropdownMenuItem(
                                              value: customer,
                                              child: Text(
                                                customer!,
                                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCustomer = newValue;
                                      });
                                    }),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    hint: Text(
                                      'Select Country',
                                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                    ),
                                    dropdownColor: Colors.black,
                                    value: selectedCountry,
                                    items: uniqueCountries
                                        .map((country) => DropdownMenuItem(
                                              value: country,
                                              child: Text(
                                                country!,
                                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCountry = newValue;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: applyFilters,
                                child: Text(
                                  'Apply Filters',
                                  style: GoogleFonts.poppins(color: Colors.blue, fontSize: 12),
                                )),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            TextButton(
                                onPressed: clearFilters,
                                child: Text(
                                  'Clear Filters',
                                  style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                    child: TextField(
                        onChanged: (value) {
                          filterIssues(value);
                        },
                        cursorColor: Colors.white30,
                        controller: searchController,
                        maxLines: null,
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: Color(0xff021526),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          hintText: '   Search Issues',
                          hintStyle: GoogleFonts.poppins(color: Colors.white54, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                        )),
                  ),
                  FutureBuilder<List<GetAllIssues>>(
                    future: futureIssues,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return SizedBox.shrink();
                      } else if (snapshot.hasData && filteredIssues.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredIssues.length,
                          itemBuilder: (context, index) {
                            final issue = filteredIssues[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => IssueDetail(issue: filteredIssues[index]),
                                  ),
                                );
                              },
                              child: NotesCard(
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
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          'Error Loading Issues. Check your Internet Connection!',
                          style: TextStyle(color: Colors.white),
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          'No issues found',
                          style: GoogleFonts.poppins(color: Colors.white30, fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Divider(
                      endIndent: screenWidth * 0.1,
                      indent: screenWidth * 0.1,
                      color: Colors.white30,
                      height: screenHeight * 0.1,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      child: Text(
                        'You Have Reached the End of Ongoing Issues.',
                        style: GoogleFonts.poppins(color: Colors.white30, fontSize: 26, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
                    child: Text(
                      'Developed by the Innovation & Performance Team, Nokia Plot 25, Gurgaon, IN.',
                      style: GoogleFonts.poppins(color: Colors.white30, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
