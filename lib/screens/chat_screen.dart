import 'package:flash_chat/screens/profile.dart';
import 'package:flash_chat/screens/settings_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../components/message_bubble.dart';
import 'chat_bot.dart';
import 'community.dart';
import 'groups.dart';

User loggedIn;

bool darkMode = true;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String messageText;
  AnimationController controller;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {}
  }

  ImageProvider img() {
    if (loggedIn.photoURL == null) {
      return AssetImage('images/profile.png');
    } else {
      return NetworkImage(loggedIn.photoURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerCode(context),
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: darkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (darkMode == true) {
                    darkMode = false;
                    controller.forward();
                  } else {
                    darkMode = true;
                    controller.reverse();
                  }
                });
              },
              child: Lottie.asset('images/darkmode.json',
                  controller: controller, width: 80),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'Messages',
          style: GoogleFonts.barlow(
            color: darkMode ? Colors.white : Colors.black,
            textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: darkMode ? Colors.black : Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BuildStreams(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          color: darkMode ? Colors.white : Colors.black),
                      cursorColor: Colors.white,
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      final time = (DateTime.now()).toString();
                      final timeDetails = time.split(' ');
                      final entryTime = timeDetails[1].split(':');
                      int hours = int.parse(entryTime[0]);
                      int minutes = int.parse(entryTime[1]);
                      String zone = '';
                      if (hours > 12) {
                        hours = hours - 12;
                        zone = 'PM';
                      } else {
                        zone = 'AM';
                      }
                      String timeInfo = hours.toString() +
                          ":" +
                          minutes.toString() +
                          " " +
                          zone;
                      if (messageText != null) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedIn.displayName == null
                              ? loggedIn.email
                              : loggedIn.displayName,
                          'senderMail': loggedIn.email,
                          'Timestamp': FieldValue.serverTimestamp(),
                          'Timeinfo': timeInfo,
                        });
                        messageTextController.clear();
                      }
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      color: Color.fromARGB(255, 39, 38, 43),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawerCode(BuildContext context) {
    return Drawer(
      child: Material(
        color: darkMode ? Color(0xFF18171E) : Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Row(
                children: [
                  Hero(
                    tag: 'hero1',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, UserProfile.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 51, 50, 56),
                          radius: 25,
                          backgroundImage: img(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            loggedIn.displayName ?? "",
                            style: darkMode
                                ? kDrawerTextStyleDark
                                : KDrawerTextStyleLight,
                          ),
                        ),
                        Text(
                          loggedIn.email,
                          style: darkMode
                              ? kDrawerTextStyleDark
                              : KDrawerTextStyleLight,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Divider(
              color: darkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              thickness: 1.5,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ChatScreen.id);
              },
              child: DrawerElement(
                ic: Icons.home,
                field: "Home",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ChatBotScreen.id,
                    arguments: darkMode);
              },
              child: DrawerElement(
                ic: Icons.chat,
                field: "Mr. Chatty",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: darkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              thickness: 1.5,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _auth.signOut();
                googleSignIn.disconnect();
                Navigator.pushNamed(context, WelcomeScreen.id);
              },
              child: DrawerElement(
                ic: Icons.logout,
                field: "Sign Out",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerElement extends StatelessWidget {
  final IconData ic;
  final String field;
  DrawerElement({
    Key key,
    this.ic,
    this.field,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Icon(
              ic,
              color: darkMode ? Colors.white : Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              field,
              style: darkMode ? kDrawerTextStyleDark : KDrawerTextStyleLight,
            ),
          )
        ],
      ),
    );
  }
}

class BuildStreams extends StatelessWidget {
  const BuildStreams({
    Key key,
    @required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection('messages').orderBy('Timestamp').snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasData) {
              final messages = snapshot.data.docs.reversed;
              List<messageBubble> messageWidgets = [];
              for (var message in messages) {
                Map<String, dynamic> myMap =
                    message.data() as Map<String, dynamic>;
                final messageText = myMap['text'];
                final messageSender = myMap['sender'];
                final time = myMap['Timeinfo'];
                final currentUser = loggedIn.email;
                final messagewidget = messageBubble(
                  sender: messageSender,
                  text: messageText,
                  isMe: currentUser == messageSender ||
                      loggedIn.displayName == messageSender,
                  timeStamp: time,
                );
                messageWidgets.add(messagewidget);
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  children: messageWidgets,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              return Text('');
            }
          } catch (e) {
            return Text('error occured');
          }
        });
  }
}
