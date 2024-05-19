import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.read(userAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverId: recieverId,
            senderData: value!));
  }
}
