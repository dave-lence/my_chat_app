// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/repository/common_firestore_repo.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/models/status_model.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    auth: FirebaseAuth.instance,
    fireStore: FirebaseFirestore.instance,
    ref: ref));

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  final ProviderRef ref;
  StatusRepository(
      {required this.auth, required this.fireStore, required this.ref});

  void uploadStatus(
      {required String username,
      required String profilePic,
      required String phoneNumber,
      required File statusImage,
      required BuildContext context}) async {
    try {
      String statusId = const Uuid().v1();
      String currentUserId = auth.currentUser!.uid;

      // saving status image to firebase passing in status id and user id
      String statusImageUrl = await ref
          .read(commonFirebaseStorageRepoProvider)
          .saveFileToFirebase('/status/$statusId$currentUserId', statusImage);

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      // getting users are regisered to tha app and interacted with the
      // current user so they can see the current user status

      List<String> whoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var contactInFirebaseDB = await fireStore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (contactInFirebaseDB.docs.isNotEmpty) {
          var userContactData =
              UserModel.fromMap(contactInFirebaseDB.docs[0].data());
          whoCanSee.add(userContactData.uid);
        }
      }

      // getting and saving the satus image urls of the user to the status urls list
      List<String> statusImageUrls = [];
      var statusSnapShot = await fireStore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .where('createdAt',
              isEqualTo: DateTime.now().subtract(const Duration(hours: 24)))
          .get();

      if (statusSnapShot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapShot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(statusImageUrl);

        //updating the posted status in firebase
        await fireStore
            .collection('status')
            .doc(statusSnapShot.docs[0].id)
            .update({'photoUrl': statusImageUrls});

        return;
      } else {
        statusImageUrls = [statusImageUrl];
      }

      Status status = Status(
          uid: currentUserId,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: whoCanSee);

      // sending status to firebase
      await fireStore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
