import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petcare/login.dart';
import 'package:petcare/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set system overlay mode
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.white, // Set the system navigation bar color
    statusBarColor: Colors.transparent, // Set the status bar color
  ));

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFFB12A1C), // Set the primary color to white
    ),
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F1EF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/Logo.png")),
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isClicked =
                      !isClicked; // Chuyển đổi trạng thái khi nút được nhấn
                });
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => signup(),
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: isClicked ? Colors.black : Color(0xFFFFBD58),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: isClicked ? Colors.white : Colors.black,
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Existing Member?',
                  style: TextStyle(
                    color: Color(0xFFB12A1C),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý sự kiện khi "Login Here" được nhấn
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => login(),
                    ));
                  },
                  child: Text(
                    'Login Here',
                    style: TextStyle(
                      color: Color(0xFFB12A1C),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
