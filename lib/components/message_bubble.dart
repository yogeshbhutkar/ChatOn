import 'package:flutter/material.dart';

class messageBubble extends StatelessWidget {
  const messageBubble(
      {Key key, this.text, this.sender, this.isMe, this.timeStamp})
      : super(key: key);
  final String text;
  final String sender;
  final bool isMe;
  final String timeStamp;

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
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Material(
              elevation: 5.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
              color: isMe
                  ? Color.fromARGB(255, 32, 31, 31)
                  : Color.fromARGB(255, 39, 38, 38),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        bottom: 7,
                        left: isMe ? 20 : 15,
                        right: isMe ? 15 : 20),
                    child: Text(
                      text,
                      maxLines: 15,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 10, bottom: 5),
                    child: Text(
                      timeStamp ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
