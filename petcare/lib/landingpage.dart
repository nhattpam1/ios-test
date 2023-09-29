import 'package:flutter/material.dart';

import 'package:petcare/petprofile.dart';

class landingpage extends StatefulWidget {
  const landingpage({super.key});

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isClicked = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F1EF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("assets/Logo.png"),
              ),
              Text(
                'Welcome, Pet Owner',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("assets/image 4.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Fill out a questionnaire\n for your pets',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'This give you a more personalized\n experience, tailored to your pets’ needs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFABABAB),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.1,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isClicked = !isClicked;
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => petprofile(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Adjust horizontal padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: isClicked ? Colors.black : Color(0xFFFFBD58),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: isClicked ? Colors.white : Colors.black,
                      fontSize: 18, // Adjust font size
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
