import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/select_contacts/repository/contact_repository.dart';

final getContactProvider = FutureProvider((ref) {
  final selectedContactsRepo = ref.watch(selectContactRepoProvider);
  return selectedContactsRepo.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
   final selectContactRepository = ref.watch(selectContactRepoProvider);
   return SelectContactController(ref: ref, selectedContactRepository: selectContactRepository);
});


class SelectContactController{
 
 final ProviderRef ref;
 final SelectContactsRepository selectedContactRepository;

  SelectContactController({required this.ref, required this.selectedContactRepository});

  void selectContact(BuildContext context, Contact selected){
    selectedContactRepository.selectContact(context, selected);
  }

}
