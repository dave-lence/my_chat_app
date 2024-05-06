import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/widgets/chat_list.dart';
import 'package:my_chat/widgets/contact_list.dart';
import 'package:my_chat/widgets/web_app_bar.dart';
import 'package:my_chat/widgets/web_chat_app_bar.dart';
import 'package:my_chat/widgets/web_search_bar.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  bool fileOptions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WebAppBar(), WebSearchBar(),
                  SingleChildScrollView(
                    child: Column(children: [ContactsList()]),
                  ),
                ],
              ),
            ),
          ),
          //chat side
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
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
                const WebChatAppBar(),
                const SizedBox(height: 20),
                const Expanded(
                  child: ChatList(),
                ),

             fileOptions == true ?  
                 Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width * 0.60,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: webAppBarColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Row(
                              children: [
                                Icon(Icons.folder_outlined, color: Colors.orangeAccent,),
                                SizedBox(width: 10,),
                                Text('documents', style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.camera_alt, color: Colors.red,),
                                 SizedBox(width: 10,),
                                Text('Camera', style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.photo_library_rounded, color: Colors.blue,),
                                 SizedBox(width: 10,),
                                Text('Photos and video', style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.contacts, color: Colors.deepPurple,),
                                 SizedBox(width: 10,),
                                Text('Contacts', style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ]
                        ),
                      ),
                    
                
             ) : const SizedBox(),

                 Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: dividerColor),
                    ),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      fileOptions == true ?
                      IconButton(
                        onPressed: () {
                          setState(() {
                            fileOptions = !fileOptions;
                          });
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.grey,
                        ),
                      ):
                      IconButton(
                        onPressed: () {
                          setState(() {
                            fileOptions = !fileOptions;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 15,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: searchBarColor,
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
