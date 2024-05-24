// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/common/repository/common_firestore_repo.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/message_model.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  Stream<List<ChatContact>> getContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getMessages(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messagesList = [];
      for (var document in event.docs) {
        messagesList.add(MessageModel.fromMap(document.data()));
      }

      return messagesList;
    });
  }

  void _saveDataToContactSubCollection(
      {required UserModel senderData,
      required UserModel receiverData,
      required DateTime timeSent,
      required String text,
      required String receiverId}) async {
    //users -> reciever id -> chats -> current user id -> set data
    var receiverChatContact = ChatContact(
        name: senderData.name,
        profilePic: senderData.profilePic,
        contactId: senderData.uid,
        timeSent: timeSent,
        lastMessage: text);
    // save from the sender side the text to reciever collection and sender collection
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderData.uid)
        .set(receiverChatContact.toMap());

    //users -> current user id -> chats -> receiver id -> set data
    var senderChatContact = ChatContact(
        name: receiverData.name,
        profilePic: receiverData.profilePic,
        contactId: receiverData.uid,
        timeSent: timeSent,
        lastMessage: text);
    // save from the receiver side the text to reciever collection and sender collection
    await firestore
        .collection('users')
        .doc(senderData.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection({
    required String receiverId,
    required String text,
    required String messageId,
    required DateTime timeSent,
    required String senderName,
    required String receiverName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required String receiverUserName,
  }) async {
    var message = MessageModel(
      senderId: auth.currentUser!.uid,
      isSeen: false,
      messageId: messageId,
      recieverid: receiverId,
      text: text,
      timeSent: timeSent,
      type: messageType,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderName
              : receiverName,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    //users -> reciever id -> chats -> current user id -> set data

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('message')
        .doc(messageId)
        .set(message.toMap());

    //users -> current user id -> chats -> receiver id -> set data
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverId,
      required UserModel senderData,
      required MessageReply? messageReply}) async {
    try {
      final timeSent = DateTime.now();
      UserModel recieverData;
      var messageId = const Uuid().v1();

      var userDataMap =
          await firestore.collection('users').doc(recieverId).get();

      recieverData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
          receiverData: recieverData,
          senderData: senderData,
          timeSent: timeSent,
          text: text,
          receiverId: recieverId);
      _saveMessageToMessageSubCollection(
          receiverId: recieverId,
          text: text,
          messageId: messageId,
          timeSent: timeSent,
          senderName: senderData.name,
          receiverName: recieverData.name,
          messageType: MessageEnum.text,
          messageReply: messageReply,
          receiverUserName: recieverData.name,
          senderUserName: senderData.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFile({
    required BuildContext context,
    required File file,
    required String receiverId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required ProviderRef ref,
    MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      // we store the file in firebase storage
      String imageUrl = await ref
          .read(commonFirebaseStorageRepoProvider)
          .saveFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receiverId/$messageId',
              file);

      // now we get the reciever data
      UserModel recieverUserData;
      var userData = await firestore.collection('users').doc(receiverId).get();
      recieverUserData = UserModel.fromMap(userData.data()!);
      // repolacing latest image on the contact collection to photo, file or video icon
      String fileMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          fileMessage = "📸 Photo";
          break;
        case MessageEnum.video:
          fileMessage = "📽 Video";
          break;
        case MessageEnum.audio:
          fileMessage = " Voice note";
          break;
        case MessageEnum.file:
          fileMessage = "📁 File";
          break;
        case MessageEnum.gif:
          fileMessage = "GIF";
          break;
        default:
          fileMessage = 'Gif';
      }

      _saveDataToContactSubCollection(
          senderData: senderUserData,
          receiverData: recieverUserData,
          timeSent: timeSent,
          text: fileMessage,
          receiverId: receiverId);

      _saveMessageToMessageSubCollection(
        receiverId: receiverId,
        text: imageUrl,
        messageId: messageId,
        timeSent: timeSent,
        senderName: senderUserData.name,
        receiverName: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        receiverUserName: recieverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverId,
    required UserModel senderUserData,
    MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubCollection(
          senderData: senderUserData,
          receiverData: recieverUserData,
          timeSent: timeSent,
          text: 'GIF',
          receiverId: receiverId);

      _saveMessageToMessageSubCollection(
        receiverId: receiverId,
        text: gifUrl,
        messageId: messageId,
        timeSent: timeSent,
        senderName: senderUserData.name,
        receiverName: recieverUserData.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        receiverUserName: recieverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
