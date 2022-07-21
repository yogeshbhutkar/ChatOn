import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/chat_bot.dart';
import 'package:flash_chat/screens/community.dart';
import 'package:flash_chat/screens/groups.dart';
import 'package:flash_chat/screens/profile.dart';
import 'package:flash_chat/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

bool isSignedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user != null) {
      isSignedIn = true;
    }
  });
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat_on",
      debugShowCheckedModeBanner: false,
      initialRoute: isSignedIn ? ChatScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        UserProfile.id: (context) => UserProfile(),
        ChatBotScreen.id: (context) => ChatBotScreen(),
        CommunityScreen.id: (context) => CommunityScreen(),
        GroupsScreen.id: (context) => GroupsScreen(),
        SettingsScreen.id: (context) => SettingsScreen()
      },
    );
  }
}
