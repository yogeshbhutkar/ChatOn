class Messages {
  static List messages = [
    [false, 'Hey there!']
  ];
  final bool isMe;
  final String message;
  Messages(this.isMe, this.message) {
    messages.add([this.isMe, this.message]);
  }
}
