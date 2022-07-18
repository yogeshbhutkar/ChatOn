import 'package:auth_buttons/auth_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String password;
  String displayName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: AutoSizeText(
                      'Register',
                      maxLines: 1,
                      style: GoogleFonts.barlow(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    child: AutoSizeText(
                      'Unlock awesomeness with chat-o.',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        textStyle: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                    ),
                    child: AutoSizeText(
                      email,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.barlow(
                        textStyle: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Email'),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        password = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Username'),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) {
                        displayName = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Password')),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GoogleAuthButton(
                      themeMode: ThemeMode.dark,
                      onPressed: () async {
                        final googleUser = await googleSignIn.signIn();
                        if (googleUser == null) return;
                        _user = googleUser;

                        final googleAuth = await googleUser.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        final exUser = await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        if (exUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      },
                      style: AuthButtonStyle(iconType: AuthIconType.secondary),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoundButton(
                    color: Colors.white,
                    text: 'Register',
                    onpress: () async {
                      try {
                        setState(() {
                          showSpinner = true;
                        });

                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
