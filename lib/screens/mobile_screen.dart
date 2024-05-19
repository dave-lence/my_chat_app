import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/features/auth/controllers/auth_conroller.dart';
import 'package:my_chat/features/chats/widgets/contact_list.dart';
import 'package:my_chat/features/select_contacts/screens/select_contact_screen.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-screen';
  const MobileScreen({super.key});

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
            bottom: const TabBar(
                indicatorColor: tabColor,
                indicatorWeight: 4,
                labelColor: tabColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ]),
          ),
          body: const ContactsList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            },
            backgroundColor: tabColor,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ));
  }
}
