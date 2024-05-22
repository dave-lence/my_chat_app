// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/common/utils/utils.dart';
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
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  bool showVideoAndGifButtom = true;

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

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.recieverId, messageEnum);
  }

  void sendImageFile() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectGifFile() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGifMessage(context, gif.url, widget.recieverId);
    }
  }

  void sendVideoMessage() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmojiKeyboardContainer() {
    if (!isShowEmojiContainer) {
      setState(() {
        isShowEmojiContainer = true;
      });
      focusNode.unfocus();
    } else {
      setState(() {
        isShowEmojiContainer = false;
      });
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.messageComroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
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
                  onTapOutside: (event) {
                    setState(() {
                      showVideoAndGifButtom = true;
                    });
                  },
                  onTap: () {
                    setState(() {
                      showVideoAndGifButtom = false;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: senderMessageColor,
                    prefixIcon: IconButton(
                      onPressed: toggleEmojiKeyboardContainer,
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
                  showVideoAndGifButtom == true
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: sendVideoMessage,
                            icon: const Icon(
                              Icons.video_library_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGifFile,
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                      : const SizedBox(),
                  IconButton(
                    onPressed: sendImageFile,
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
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 270,
                width: MediaQuery.of(context).size.width,
                child: EmojiPicker(
                  
                  onBackspacePressed: () {
                  },
                  config: const Config(
                    backspaceColor: tabColor,
                    enableSkinTones: true,
                    checkPlatformCompatibility: true,
                    bgColor: Colors.black,
                    iconColorSelected: tabColor,
                    indicatorColor: tabColor,
                  ),
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      widget.messageComroller.text =
                          widget.messageComroller.text + emoji.emoji;
                    });
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
