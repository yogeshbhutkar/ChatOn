import 'package:flash_chat/components/bot_brain.dart';
import 'package:flash_chat/components/bot_message_bubble.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/components/theme.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ChatBotScreen extends StatefulWidget {
  static String id = "chat_bot_screen";
  const ChatBotScreen({Key key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  void pushMessage() async {
    String t = await BotBrain(messageText).getAnswer(messageText);
    setState(() {
      bubbleWidgets.add(botMessageBubble(
        isMe: false,
        sender: 'Mr. Chatty',
        text: t,
        imagePath: 'images/robot.png',
      ));
    });
  }

  final messageTextController = TextEditingController();
  List<dynamic> bubbleWidgets = [];
  String messageText;
  @override
  Widget build(BuildContext context) {
    final darkmode = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: darkmode ? Colors.black : Colors.white,
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: bubbleWidgets.length,
            itemBuilder: (context, index) {
              return bubbleWidgets.reversed.elementAt(index);
            },
          ),
        ),
        Container(
          decoration: kMessageContainerDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  style:
                      TextStyle(color: darkmode ? Colors.white : Colors.black),
                  cursorColor: Colors.white,
                  controller: messageTextController,
                  onChanged: (value) {
                    messageText = value;
                  },
                  decoration: kMessageTextFieldDecoration,
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if (messageText != null) {
                    setState(() {
                      bubbleWidgets.add(messageBubble(
                        isMe: true,
                        sender: loggedIn.displayName ?? loggedIn.email,
                        text: messageText,
                      ));
                      pushMessage();
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
      ]),
    );
  }
}
