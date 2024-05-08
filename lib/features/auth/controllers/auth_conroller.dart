import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepo);
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }
}
