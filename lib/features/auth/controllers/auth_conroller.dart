import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/repository/auth_repository.dart';
import 'package:my_chat/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  return AuthController(authRepository: authRepo, ref: ref);
});

final userAuthProvider = FutureProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider);
    return authController.getUserData();
  },
);

class AuthController {
  AuthController({
    required this.ref,
    required this.authRepository,
  });

  final ProviderRef ref;
  final AuthRepository authRepository;

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebae(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void userState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
