import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat/utils/utils.dart';

class UserInformationScreen extends StatefulWidget {
  static const routeName = '/user-info-screen';
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                // image == null
                //     ?
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                  ),
                  radius: 64,
                ),
                // :
                //  CircleAvatar(
                //     backgroundImage: FileImage(
                //       image!,
                //     ),
                //     radius: 64,
                //   ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
