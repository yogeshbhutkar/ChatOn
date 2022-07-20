import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _auth = FirebaseAuth.instance;
ImageProvider img() {
  if (loggedIn.photoURL == null) {
    return AssetImage('images/profile.png');
  } else {
    return NetworkImage(loggedIn.photoURL);
  }
}

final googleSignIn = GoogleSignIn();
User loggedIn;
String _userName = loggedIn.displayName;

class UserProfile extends StatefulWidget {
  static String id = 'user_profile';
  const UserProfile({Key key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                child: Stack(children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(
                              _userName ?? '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'e-mail',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Text(
                                    loggedIn.email,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25, top: 35),
                            child: Center(
                              child: MaterialButton(
                                color: Colors.white,
                                onPressed: () {
                                  _auth.signOut();
                                  googleSignIn.disconnect();
                                  Navigator.pushNamed(
                                      context, WelcomeScreen.id);
                                },
                                child: Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(top: 60),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 51, 50, 56),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  Hero(
                    tag: 'hero1',
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 51, 50, 56),
                            radius: 70.0,
                            backgroundImage: img(),
                          ),
                        )),
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}
