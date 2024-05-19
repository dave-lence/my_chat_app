import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/common/widgets/loader.dart';
import 'package:my_chat/features/chats/controller/chat_controller.dart';
import 'package:my_chat/features/chats/widgets/my_message_list.dart';
import 'package:my_chat/features/chats/widgets/sender_message_list.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref
            .watch(chatControllerProvider)
            .getUserMessages(widget.receiverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var message = snapshot.data![index];
                if (message.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: message.text,
                    date: DateFormat.Hm().format(message.timeSent),
                  );
                }
                return SenderMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(message.timeSent),
                );
              },
            );
          }
        });
  }
}
