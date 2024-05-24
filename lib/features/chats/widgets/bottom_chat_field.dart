// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_chat/colors.dart';
import 'package:my_chat/common/enum/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/chats/controller/chat_controller.dart';
import 'package:my_chat/features/chats/widgets/messagea_reply_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  FlutterSoundRecorder flutterSoundRecoder = FlutterSoundRecorder();
  bool isRecorderInitialized = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  bool showVideoAndGifButtom = true;
  bool isShowSendButton = false;

  @override
  void initState() {
    super.initState();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await flutterSoundRecoder.openRecorder();
      setState(() {
        isRecorderInitialized = true;
      });
    }
    throw RecordingPermissionException('Mic permission not allowed!');
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

  // void toggleEmojiKeyboardContainer() {
  //   if (!isShowEmojiContainer) {
  //     setState(() {
  //       isShowEmojiContainer = true;
  //     });
  //     focusNode.unfocus();
  //   } else {
  //     setState(() {
  //       isShowEmojiContainer = false;
  //     });
  //     focusNode.requestFocus();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    widget.messageComroller.dispose();
    flutterSoundRecoder.closeRecorder();
    isRecorderInitialized = false;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final messageReply = ref.watch(messageReplyProvider);
    bool isShowReplyContainer = messageReply != null;

    void sendTextMessage() async {
      if (isShowSendButton) {
        ref.read(chatControllerProvider).sendTextMessage(
            context, widget.messageComroller.text.trim(), widget.recieverId);
        setState(() {
          widget.messageComroller.clear();
          isShowReplyContainer = !isShowReplyContainer;
        });
      } else {
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/flutter_sound.aac';
        setState(() {
          isRecording = !isRecording;
          isShowReplyContainer = !isShowReplyContainer;
        });
        if (isRecorderInitialized) {
          if (isRecording) {
            await flutterSoundRecoder.stopRecorder();
            debugPrint('path: storage: $path');
            sendFileMessage(File(path), MessageEnum.audio);
          } else {
            await flutterSoundRecoder.startRecorder(
              toFile: path,
            );
          }
        } else {
          setState(() {
            isRecording = !isRecording;
          });
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowReplyContainer ? const MessageReplyPreview() : const SizedBox(),
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  controller: widget.messageComroller,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
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
                      onPressed: () {},
                      icon: const Icon(Icons.message_rounded),
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
                  isShowSendButton != true
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
              SizedBox(
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
                          icon: Icon(
                            isShowSendButton
                                ? Icons.send
                                : isRecording
                                    ? Icons.close
                                    : Icons.mic,
                            color: Colors.black,
                          ))),
                ),
              )
            ],
          ),
        ),
        // isShowSendButton
        //     ? SizedBox(
        //         height: 270,
        //         width: MediaQuery.of(context).size.width,
        //         child: EmojiPicker(
        //           onBackspacePressed: () {},
        //           config: const Config(
        //             backspaceColor: tabColor,
        //             enableSkinTones: true,
        //             checkPlatformCompatibility: true,
        //             bgColor: Colors.black,
        //             iconColorSelected: tabColor,
        //             indicatorColor: tabColor,
        //           ),
        //           onEmojiSelected: ((category, emoji) {
        //             setState(() {
        //               widget.messageComroller.text =
        //                   widget.messageComroller.text + emoji.emoji;
        //             });
        //           }),
        //         ),
        //       )
        //     : const SizedBox(),
      ],
    );
  }
}
