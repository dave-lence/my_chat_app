
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/common/widgets/loader.dart';
import 'package:my_chat/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const routeName = '/select_contact_screen';
  const SelectContactScreen({super.key});


  void selectContact(BuildContext context, WidgetRef ref, Contact contact){
    ref.read(selectContactControllerProvider).selectContact(context, contact);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Contact list'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: ref.watch(getContactProvider).when(
          data: (conactList) => Scrollbar(
                thickness: 2,
                child: ListView.builder(
                  itemCount: conactList.length,
                  itemBuilder: (context, index) {
                    final contact = conactList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: InkWell(
                        onTap: () => selectContact(context, ref, contact),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text(
                              contact.displayName.substring(0, 1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(contact.displayName, style: const TextStyle(fontSize: 18),),
                          subtitle: Row(
                              children: contact.phones
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(e.number),
                                      ))
                                  .toList()),
                        ),
                      ),
                    );
                  },
                ),
              ),
          error: (error, stackTrace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
