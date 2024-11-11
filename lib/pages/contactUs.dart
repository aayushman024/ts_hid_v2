import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';  // Import the package

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final contactNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final subjectController = TextEditingController();
  final issueController = TextEditingController();

  Future<void> validateAndSave() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      final Email email = Email(
        body: issueController.text,
        subject: subjectController.text,
        recipients: ['shiv.sahu@nokia.com'],
        isHTML: false,
      );
      try {
        await FlutterEmailSender.send(email);
        contactNameController.clear();
        contactEmailController.clear();
        subjectController.clear();
        issueController.clear();

        // Show the Awesome Snackbar on success
        final snackBar = SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Your email was sent successfully.',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
        // Show the Awesome Snackbar on failure
        final snackBar = SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Failed to send the email. Please try again.',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF0F8FF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(CupertinoIcons.back, color: Colors.white,),
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
    child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: Text(
                'Contact Us',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              width: screenWidth * 0.9,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thank you for using the TS-HID mobile application. We at Innovation and Performance, Nokia Plot 25, Gurgaon are happy to help with any issues you have. ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Name field
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: contactNameController,
                          validator: (value) => value!.isEmpty
                              ? 'Name cannot be blank'
                              : null,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Email field
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: contactEmailController,
                          validator: (value) => value!.isEmpty
                              ? 'Email cannot be blank'
                              : null,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'E-Mail',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Subject field
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: subjectController,
                          validator: (value) => value!.isEmpty
                              ? 'Subject cannot be blank'
                              : null,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Subject',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Issue field
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: issueController,
                          validator: (value) => value!.isEmpty
                              ? 'Issue cannot be blank'
                              : null,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Issue',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: validateAndSave,
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              EdgeInsets.fromLTRB(50, 15, 50, 15)),
                          backgroundColor:
                          WidgetStateProperty.all(Color(0xff0A0908)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: Text(
                          'Send',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Center(
                      child: Text(
                        'Or, reach out to',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextButton(
                          onPressed: () async {
                            await Clipboard.setData(
                                ClipboardData(text: "shiv.sahu@nokia.com"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email address copied to clipboard'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: Text('shiv.sahu@nokia.com', style: GoogleFonts.poppins(color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}