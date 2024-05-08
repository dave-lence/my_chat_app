import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/widgets/custom_buton.dart';

import '../auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: Text(
              'Welcome to MyChat',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 30),
            ),
          ),
          SizedBox(
            height: size.height / 8,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(170),
              child: Image.asset(
                'assets/bg.jpg',
                width: 340,
                height: 340,
                fit: BoxFit.fitWidth,
              )),
          SizedBox(
            height: size.height / 9,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              style: TextStyle(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.85,
            child: CustomButton(
              text: 'AGREE AND CONTINUE',
              onPressed: () => navigateToLoginScreen(context),
            ),
          ),
        ],
      )),
    );
  }
}
