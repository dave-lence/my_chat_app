
import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/features/chats/widgets/text_or_file.dart';
import 'package:swipe_to/swipe_to.dart';
class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedMessageType,
    required this.repliedText,
    required this.username
  }) : super(key: key);
  final String message;
  final String date;
    final MessageEnum type;
    final Function(void) onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;


  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                 padding:type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                            bottom: 25,
                          ),
                  child:TextFileWidget(message: message, type: type)
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}