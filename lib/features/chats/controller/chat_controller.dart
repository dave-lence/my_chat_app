import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/features/auth/controllers/auth_conroller.dart';
import 'package:my_chat/features/chats/repository/chat_repository.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepo, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getContacts();
  }

  Stream<List<MessageModel>> getUserMessages(String receiverId) {
    return chatRepository.getMessages(receiverId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverId,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverId: recieverId,
            senderData: value!,
            messageReply: messageReply));
  }

  void sendFileMessage(BuildContext context, File file, String receiverId,
      MessageEnum messageEnum) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userAuthProvider).whenData((value) {
      chatRepository.sendFile(
          context: context,
          file: file,
          receiverId: receiverId,
          senderUserData: value!,
          messageEnum: messageEnum,
          ref: ref,
          messageReply: messageReply);
    });
  }

  void sendGifMessage(
    BuildContext context,
    String gifUrl,
    String receiverId,
  ) {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userAuthProvider).whenData((value) {
      int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
      String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
      String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
      chatRepository.sendGIFMessage(
          context: context,
          gifUrl: newgifUrl,
          receiverId: receiverId,
          senderUserData: value!,
          messageReply: messageReply);
    });
  }

  void setChatMessageSeen(
      {required BuildContext context,
      required String receiverId,
      required String messageId}) {
    chatRepository.setChatMessageSeen(
        context: context, receiverId: receiverId, messageId: messageId);
  }
}
