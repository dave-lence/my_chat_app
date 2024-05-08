import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/widgets/custom_buton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  @override
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Enter your phone number',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
                child: Text(
              'MyChat would need to verify your phone number.',
              style: TextStyle(color: greyColor),
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: TextButton(
              onPressed: () {},
              child: const Text(
                'Pick country',
                style: TextStyle(color: Colors.blue),
              ),
            )),
          const  SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20, right: MediaQuery.of(context).size.width * 0.25),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  fillColor: backgroundColor,
                  filled: true,
                  hintText: 'Phone number',
                ),
              ),
            ),
            SizedBox(
              height: size.height / 1.8,
            ),
            SizedBox(
              width: 100,
              child: CustomButton(text: 'NEXT', onPressed: () {}),
            ),
          ],
        ),
      )),
    );
  }
}
