// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enum/message_enum.dart';
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
      UserModel senderData,
      UserModel receiverData,
      DateTime timeSent,
      String text,
      String receiverId) async {
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

  void _saveMessageToMessageSubCollection(
      {required String receiverId,
      required String text,
      required String messageId,
      required DateTime timeSent,
      required String senderName,
      required String receiverName,
      required MessageEnum messageType}) async {
    var message = MessageModel(
        senderId: auth.currentUser!.uid,
        isSeen: false,
        messageId: messageId,
        recieverid: receiverId,
        text: text,
        timeSent: timeSent,
        type: messageType);

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
      required UserModel senderData}) async {
    try {
      final timeSent = DateTime.now();
      UserModel recieverData;
      var messageId = const Uuid().v1();

      var userDataMap =
          await firestore.collection('users').doc(recieverId).get();

      recieverData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
          recieverData, senderData, timeSent, text, recieverId);

      _saveMessageToMessageSubCollection(
          receiverId: recieverId,
          text: text,
          messageId: messageId,
          timeSent: timeSent,
          senderName: senderData.name,
          receiverName: recieverData.name,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFile(
      {required BuildContext context,
      required File file,
      required String receiverId,
      required UserModel senderUserData,
      required MessageEnum messageEnum,
      required ProviderRef ref}) async {
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
          fileMessage = "🎙 Voice note";
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
          senderUserData, recieverUserData, timeSent, fileMessage, receiverId);

      _saveMessageToMessageSubCollection(
          receiverId: receiverId,
          text: imageUrl,
          messageId: messageId,
          timeSent: timeSent,
          senderName: senderUserData.name,
          receiverName: recieverUserData.name,
          messageType: messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
