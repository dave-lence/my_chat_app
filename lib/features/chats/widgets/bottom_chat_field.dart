// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/features/chats/controller/chat_controller.dart';

class BottomChaTextField extends ConsumerStatefulWidget {
  const BottomChaTextField({
    super.key,
    required this.recieverId,
    required this.messageComroller,
  });
  final String recieverId;
  final TextEditingController messageComroller;

  @override
  ConsumerState<BottomChaTextField> createState() => _BottomChaTextFieldState();
}

class _BottomChaTextFieldState extends ConsumerState<BottomChaTextField>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void sendTextMessage() {
    if (widget.messageComroller.text.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, widget.messageComroller.text.trim(), widget.recieverId);
    }
    setState(() {
      widget.messageComroller.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.messageComroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: null,
            controller: widget.messageComroller,
            onChanged: (value) {
              setState(() {
                widget.messageComroller.text = value;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.attach_file,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        widget.messageComroller.text.isNotEmpty
            ? SizedBox(
                width: 50,
                height: 40,
                child: Card(
                  color: tabColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  margin: const EdgeInsets.only(right: 10),
                  child: Center(
                      child: IconButton(
                          onPressed: sendTextMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                          ))),
                ),
              )
            : SizedBox(
                width: 50,
                height: 40,
                child: Card(
                  color: tabColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  margin: const EdgeInsets.only(right: 10),
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )),
      ],
    );
  }
}
