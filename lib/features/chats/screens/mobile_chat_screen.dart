// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/features/chats/widgets/bottom_chat_field.dart';
import 'package:my_chat/features/chats/widgets/chat_list.dart';
import 'package:my_chat/features/auth/controllers/auth_conroller.dart';
import 'package:my_chat/screens/mobile_screen.dart';

// ignore: must_be_immutable
class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);
  final messageComroller = TextEditingController();
  bool? isEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MobileScreen.routeName);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: appBarColor,
        title: StreamBuilder(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading....');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(
                  snapshot.data!.isOnline ? "Online" : 'Offline',
                  style: const TextStyle(fontSize: 13),
                )
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: dividerColor)),
            image: DecorationImage(
              image: AssetImage(
                'assets/chat-background.jpg',
              ),
              fit: BoxFit.cover,
            )),
        child: Column(
          children: [
            const Expanded(
              child: ChatList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BottomChaTextField(
                      messageComroller: messageComroller,
                      recieverId: uid,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
