import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class botMessageBubble extends StatelessWidget {
  const botMessageBubble(
      {Key key, this.text, this.sender, this.isMe, this.imagePath})
      : super(key: key);
  final String text;
  final String sender;
  final bool isMe;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 51, 50, 56),
            radius: 22,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(
            width: 5,
          ),
          Column(
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
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Material(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
