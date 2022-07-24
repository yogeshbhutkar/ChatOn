import 'dart:convert';

import 'package:http/http.dart' as http;

class BotBrain {
  final String query;

  BotBrain(this.query);

  Future getAnswer(String text) async {
    if (text.toLowerCase() == 'hi') {
      return 'Hello There! How may I help you!';
    } else if (text.toLowerCase().contains('greet')) {
      return 'Namaste random person';
    } else if (text.toLowerCase().contains('bye') ||
        (text.toLowerCase().contains('gotta go'))) {
      return 'come back soon!';
    } else if (text.toLowerCase().contains('cute')) {
      return 'From my birth!';
    }
    String updatedText = text.replaceAll(' ', '+');
    http.Response s = await http.get(
      Uri.parse(
          'http://api.wolframalpha.com/v1/result?appid=W4A796-7L43G5G3LW&i=$updatedText%3f'),
    );
    return jsonDecode(jsonEncode(s.body)) ==
                'Wolfram|Alpha did not understand your input' ||
            jsonDecode(jsonEncode(s.body)) == 'an empty list'
        ? 'I didn\'t quite get you.'
        : jsonDecode(jsonEncode(s.body));
  }
}
