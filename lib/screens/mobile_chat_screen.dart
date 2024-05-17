import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/widgets/chat_list.dart';

class MobileChatScreen extends StatefulWidget {
  const MobileChatScreen({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  TextEditingController messageComroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          widget.name,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: dividerColor)),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/chat-background.jpg',
                  ),
                  fit: BoxFit.cover,
                )),
        child: Column(
          children: [
            const Expanded(
              child: ChatList(),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: messageComroller,
                      onChanged: (value) {
                        setState(() {
                          messageComroller.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: senderMessageColor,
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions),
                          color: Colors.grey,
                        ),
                        suffixIcon: Container(
                          width: 70,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                    Icons.attach_file,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10,),
                         Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  ),
                            ],
                          ),
                        ),
                        hintText: 'Type a message!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: tabColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  margin:const EdgeInsets.only(right: 10),
                  child: Center(
                    child: messageComroller.text.isNotEmpty ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        )): IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.black,
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
