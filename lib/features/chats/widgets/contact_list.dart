
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/widgets/loader.dart';
import 'package:my_chat/features/chats/controller/chat_controller.dart';
import 'package:my_chat/features/chats/repository/mobile_chat_screen.dart';
import 'package:my_chat/models/chat_contact.dart';

class ContatctsList extends ConsumerStatefulWidget {
  const ContatctsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContatctListState();
}

class _ContatctListState extends ConsumerState<ContatctsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).getChatContacts(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else if (snapShot.hasError || snapShot.data == null) {
              return Text(
                'Error: ${snapShot.error}',
                style: const TextStyle(color: Colors.white),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapShot.data!.length,
                itemBuilder: (context, index) {
                  var chatContact = snapShot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MobileChatScreen(
                                name: chatContact.name,
                                uid: chatContact.contactId,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            title: Text(
                              chatContact.name,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatContact.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chatContact.profilePic,
                              ),
                              radius: 30,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContact.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: dividerColor, indent: 85),
                    ],
                  );
                },
              );
            }
          }),
    );
  }
}
