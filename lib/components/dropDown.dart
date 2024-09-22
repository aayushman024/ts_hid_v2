import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/get_all_issues.dart';
import '../globals/global_variables.dart';

class CustomDropDown extends StatefulWidget {
  final GetAllIssues issue;
  const CustomDropDown({super.key, required this.issue});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff021526),
          borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white38, width: 0.5)
        ),
        child: DropdownButtonHideUnderline(
          child:  DropdownButton<String>(
            borderRadius: BorderRadius.circular(25),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.expand_circle_down, color: Colors.white70,),
              ),
              padding: EdgeInsets.only(left: 10,right: 10),
              iconSize: 22,
              alignment: Alignment.center,
              dropdownColor: Color(0xff021526),
              // value: selectedSeverityIndex,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              hint: Text(widget.issue.status ?? status[0],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),),
              items: status.map((String status) {
                return DropdownMenuItem <String> (
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Status changed successfully',
                          style: GoogleFonts.poppins(color: Colors.white),),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ));
                  },
                  alignment: Alignment.centerLeft,
                  value: status,
                  child: Text(status),);
              }).toList(),
              onChanged: (String? newValue){
                setState(() {
                  selectedStatus = newValue;
                });
              }
          ),
        ),
      ),
    );
  }
}
