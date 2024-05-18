import 'package:flutter/material.dart';
import 'package:my_chat/features/auth/screens/login_screen.dart';
import 'package:my_chat/features/auth/screens/otp_screen.dart';
import 'package:my_chat/features/auth/screens/user_info_screen.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:my_chat/features/chats/screens/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
    final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen()
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen()
      );
    case MobileChatScreen.routeName:
    final arguements = settings.arguments as Map<String, dynamic>;
    final name = arguements['name'];
    final uid = arguements['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(name: name, uid: uid,)
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
