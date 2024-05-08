import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/features/landing/landing_screen.dart';
import 'package:my_chat/firebase_options.dart';
import 'package:my_chat/rouer.dart';
import 'package:my_chat/screens/mobile_screen.dart';
import 'package:my_chat/screens/web_screen.dart';
import 'package:my_chat/utils/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            appBarTheme: AppBarTheme(backgroundColor: appBarColor)),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: const LandingScreen());
  }
}
