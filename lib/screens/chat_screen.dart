import 'package:flash_chat/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

User loggedIn;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String messageText;

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: null,
        actions: <Widget>[
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
          )
        ],
        title: Text(
          'Messages',
          style: GoogleFonts.barlow(
            textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.black,
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
                      style: TextStyle(color: Colors.white),
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
                      if (messageText != null) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedIn.displayName == null
                              ? loggedIn.email
                              : loggedIn.displayName,
                          'senderMail': loggedIn.email,
                          'Timestamp': FieldValue.serverTimestamp(),
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
                final currentUser = loggedIn.email;
                final messagewidget = messageBubble(
                  sender: messageSender,
                  text: messageText,
                  isMe: currentUser == messageSender ||
                      loggedIn.displayName == messageSender,
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

class messageBubble extends StatelessWidget {
  const messageBubble({Key key, this.text, this.sender, this.isMe})
      : super(key: key);
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              sender == null ? "" : sender,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
            color: isMe
                ? Color.fromARGB(255, 32, 31, 31)
                : Color.fromARGB(255, 58, 56, 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
