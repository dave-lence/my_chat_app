import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/features/auth/controllers/auth_conroller.dart';
import 'package:my_chat/utils/utils.dart';
import 'package:my_chat/widgets/custom_buton.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login-screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country selectedCountry) {
          setState(() {
            country = selectedCountry;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }else{
      showSnackBar(context: context, content: 'Make sure you select your country and inpu your phone number');
    }
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
              onPressed: pickCountry,
              child: const Text(
                'Pick country',
                style: TextStyle(color: Colors.blue),
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20, right: MediaQuery.of(context).size.width * 0.25),
              child: Row(
                children: [
                  if (country != null) Text('+${country!.phoneCode}'),
                  const SizedBox(width: 10),
                  Expanded(
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
                ],
              ),
            ),
            SizedBox(
              height: size.height / 1.8,
            ),
            SizedBox(
              width: 100,
              child: CustomButton(text: 'NEXT', onPressed: sendPhoneNumber),
            ),
          ],
        ),
      )),
    );
  }
}
