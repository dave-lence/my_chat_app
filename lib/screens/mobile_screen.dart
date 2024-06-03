// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/auth/controllers/auth_conroller.dart';
import 'package:my_chat/features/chats/widgets/contact_list.dart';
import 'package:my_chat/features/select_contacts/screens/select_contact_screen.dart';
import 'package:my_chat/features/status/screens/confirm_status_screen.dart';
import 'package:my_chat/features/status/screens/status_contact_screen.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-screen';
  const MobileScreen({super.key});

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabBarController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).userState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).userState(false);
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            backgroundColor: appBarColor,
            title: const Text(
              'My Chat',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  )),
            ],
            bottom: TabBar(
                controller: tabBarController,
                indicatorColor: tabColor,
                indicatorWeight: 4,
                labelColor: tabColor,
                onTap: (value) {
                  debugPrint(value.toString());
                  setState(() {
                    tabBarController.index = value;
                  });
                  tabBarController.index = value;
                },
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ]),
          ),
          body: TabBarView(
            controller: tabBarController,
            children: const [
              ContatctsList(),
              StatusContactScreen(),
              Text('Calls')
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (tabBarController.index == 0) {
                Navigator.pushNamed(context, SelectContactScreen.routeName);
              } else {
                File? pickedImage = await pickVideoFromGallery(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                      arguments: pickedImage);
                }
              }
            },
            backgroundColor: tabColor,
            child: Icon(
              tabBarController.index == 1
                  ? Icons.add_a_photo_sharp
                  : tabBarController.index == 2 ? Icons.phone : Icons.comment,
              color: Colors.white,
            ),
          ),
        ));
  }
}
