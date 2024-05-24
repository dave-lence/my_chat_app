// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/chats/screens/mobile_chat_screen.dart';
import 'package:my_chat/models/user_model.dart';

final selectContactRepoProvider = Provider(
    (ref) => SelectContactsRepository(fireStore: FirebaseFirestore.instance));

class SelectContactsRepository {
  final FirebaseFirestore fireStore;
  List<Contact> contacts = [];

  SelectContactsRepository({required this.fireStore});

  Future<List<Contact>> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  selectContact(BuildContext context, Contact selected) async {
    try {
      var userCollection = await fireStore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhone = selected.phones[0].number.replaceAll(' ', '');
        if (selectedPhone == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userData.name, 'uid': userData.uid});
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: 'This phone was not found in this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
