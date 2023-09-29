import 'package:flutter/material.dart';
import 'package:petcare/landingpage.dart';
import 'package:petcare/main.dart';
import 'package:petcare/signup.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/session-petcare/session.dart';

class otp extends StatefulWidget {
  // get otp from signup.dart
  static String authCode = ""; // Declare a static class-level variable
  final String email; // Declare an instance variable to hold the email

  const otp({Key? key, required this.email}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;

  // Controllers and FocusNodes for the OTP text fields
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // try to get authCode from signup.dart
    print('auth: ' + otp.authCode);
    print('auth: ' + widget.email);

    //try to get userId in session
    int? userId = SessionManager().userId;

    if (userId != null) {
      // You have the userId, you can use it here
      print('User ID trong session: $userId');
    } else {
      // User is not logged in or userId is not set
    }


    // Add listeners to automatically move focus to the next field
    otpController1.addListener(moveToNextField);
    otpController2.addListener(moveToNextField);
    otpController3.addListener(moveToNextField);
    otpController4.addListener(moveToNextField);
  }

  @override
  void dispose() {
    _controller.dispose();
    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  // Validation function to check if the OTP fields match the authCode
  bool validateOTP() {
    final enteredOTP =
        otpController1.text + otpController2.text + otpController3.text + otpController4.text;
    callVerifyUser();
    return enteredOTP == otp.authCode;
  }

  // Function to move focus to the next field when a digit is entered
  void moveToNextField() {
    if (otpController1.text.isNotEmpty) {
      focusNode1.unfocus();
      FocusScope.of(context).requestFocus(focusNode2);
    }
    if (otpController2.text.isNotEmpty) {
      focusNode2.unfocus();
      FocusScope.of(context).requestFocus(focusNode3);
    }
    if (otpController3.text.isNotEmpty) {
      focusNode3.unfocus();
      FocusScope.of(context).requestFocus(focusNode4);
    }
  }

  //verify user -> change status = true
  // Function to call verifyUser with OTP and email
  void callVerifyUser() async {
      final otp = otpController1.text + otpController2.text + otpController3.text + otpController4.text;
      final email = widget.email;

      await API.verifyUser(otp, email);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F1EF),
        title: Text(
          'Enter Verification Code',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              isClicked = !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => signup(),
            ));
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      controller: otpController1,
                      focusNode: focusNode1,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFDC3545)),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      controller: otpController2,
                      focusNode: focusNode2,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFDC3545)),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      controller: otpController3,
                      focusNode: focusNode3,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFDC3545)),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      controller: otpController4,
                      focusNode: focusNode4,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xFFDC3545)),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
          Positioned(
            top: 300,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // ... (rest of your code)
                if (validateOTP()) {
                  // OTP is correct, navigate to the next page
                  setState(() {
                    isClicked = !isClicked;
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => landingpage(),
                  ));
                } else {
                  // OTP is incorrect, show an error message or handle it as needed
                  // For example, show a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect OTP. Please try again.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Adjust the horizontal padding as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: isClicked ? Colors.black : Color(0xFFFFBD58),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: isClicked ? Colors.white : Colors.black,
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
