import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class InitialScreen extends StatelessWidget {
  static String id = 'initial_screen';
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(
            'images/animatedSmile.json',
            repeat: false,
          ),
          SizedBox(
            child: DefaultTextStyle(
              style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Chat-on',
                    textStyle: TextStyle(color: Colors.white),
                    speed: const Duration(milliseconds: 250),
                  ),
                ],
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(18),
            color: Color(0xFF18171E),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: Text(
                'Let the journey begin ->',
                style: GoogleFonts.barlow(
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
