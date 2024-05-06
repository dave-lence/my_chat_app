import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/screens/mobile_screen.dart';
import 'package:my_chat/screens/web_screen.dart';
import 'package:my_chat/utils/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, 
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Chat',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        ),
      home: const ResponsiveLayout(
          mobileScreenLayout: MobileScreen(), webScreenLayout: WebScreen()),
    );
  }
}
