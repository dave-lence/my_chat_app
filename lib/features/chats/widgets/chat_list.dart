import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/common/widgets/loader.dart';
import 'package:my_chat/features/chats/controller/chat_controller.dart';
import 'package:my_chat/features/chats/widgets/my_message_card.dart';
import 'package:my_chat/features/chats/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatList({Key? key, required this.receiverId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final messageScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  void onSwipeReplyMessage(
      {required String message,
      required bool isMe,
      required MessageEnum messageEnum}) {
    ref
        .watch(messageReplyProvider.notifier)
        .update((state) => MessageReply(message, isMe, messageEnum));
  }

  void onSwipeRightReplyMessage(
      {required String message,
      required bool isMe,
      required MessageEnum messageEnum}) {
    ref
        .watch(messageReplyProvider.notifier)
        .update((state) => MessageReply(message, isMe, messageEnum));
  }

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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              messageScrollController
                  .jumpTo(messageScrollController.position.maxScrollExtent);
            });
            return ListView.builder(
              controller: messageScrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var message = snapshot.data![index];

                if (!message.isSeen &&
                    message.recieverid ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setChatMessageSeen(
                      context: context,
                      receiverId: widget.receiverId,
                      messageId: message.messageId);
                }

                if (message.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: message.text,
                    date: DateFormat.Hm().format(message.timeSent),
                    type: message.type,
                    repliedMessageType: message.repliedMessageType,
                    repliedText: message.repliedMessage,
                    username: message.repliedTo,
                    onLeftSwipe: (_) => onSwipeReplyMessage(
                        message: message.text,
                        isMe: true,
                        messageEnum: message.type),
                        isSeen: message.isSeen
                  );
                }
                return SenderMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(message.timeSent),
                  type: message.type,
                  onRightSwipe: (_) => onSwipeRightReplyMessage(
                      message: message.text,
                      isMe: false,
                      messageEnum: message.type),
                  repliedMessageType: message.repliedMessageType,
                  repliedText: message.repliedMessage,
                  username: message.repliedTo,
                );
              },
            );
          }
        });
  }
}
