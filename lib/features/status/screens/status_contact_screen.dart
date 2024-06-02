// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/status/screens/confirm_status_screen.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          File? pickedImage = await pickVideoFromGallery(context);
          if (pickedImage != null) {
            Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                arguments: pickedImage);
          }
        },
        backgroundColor: tabColor,
        child: const Icon(
          Icons.add_a_photo_sharp,
          color: Colors.white,
        ),
      ),
    );
  }
}
