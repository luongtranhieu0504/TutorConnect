import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/theme/color_platte.dart';

import '../../../theme/text_styles.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String subject;
  final bool isOnline;
  final String avatarUrl;

  const ChatScreen({super.key, required this.name, required this.subject, required this.isOnline, required this.avatarUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Sure, Shahin. Which part are you finding difficult?",
      "isMine": false,
      "time": "Saturday, 08:00 am"
    },
    {
      "text": "I'm confused about the second question. It's asking for a root cause analysis, but I'm not sure how to start.",
      "isMine": true,
      "time": "Saturday, 08:05 am"
    },
    {
      "text": "Okay, let’s break it down. First, identify the main problem, then list potential causes. After that, we’ll analyze and find the root cause.",
      "isMine": false,
      "time": "Saturday, 08:10 am"
    },
    {
      "text": "Got it, thanks! That makes more sense. I’ll give it a try and let you know if I have more questions.",
      "isMine": true,
      "time": "Saturday, 08:15 am"
    }
  ];
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messageFocusNode.addListener(_onFocusChange);
  }
  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": messageController.text,
          "isMine": true,
          "time": "Now"
        });
      });
      messageController.clear();
    }
  }

  // Hàm theo dõi focus vào ô nhập tin nhắn
  void _onFocusChange() {
    if (messageFocusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 300), _scrollToLastMessage);
    }
  }

  // Hàm cuộn đến tin nhắn cuối cùng
  void _scrollToLastMessage() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, // Cuộn xuống dòng cuối
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return _uiContent();
  }

  Widget _uiContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop;
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        )
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Ẩn bàn phím khi chạm ra ngoài
        },
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(widget.avatarUrl),
                      ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.isOnline ? Colors.green : Colors.grey,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.name,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                    )
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                    ),
                    child: Text(
                        widget.subject,
                        style: AppTextStyles.bodyText1.copyWith(
                          color: AppColors.color600,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => {},
                    icon: SvgPicture.asset('assets/icons/phone.svg')
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: SvgPicture.asset('assets/icons/video.svg')
                  ),
                ]
              ),
              SizedBox(height: 18),
              Divider(
                color: AppColors.color200,
                thickness: 2,
              ),
              SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return Column(
                        crossAxisAlignment:
                          message["isMine"] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: message["isMine"] ? Color(0xFF8932EB) : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: message["isMine"] ? Radius.circular(12) : Radius.zero,
                                bottomRight: message["isMine"] ? Radius.zero : Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                )
                              ]
                            ),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            child: Text(
                              message["text"],
                              style: AppTextStyles.bodyText2.copyWith(
                                color: message["isMine"] ? Colors.white : AppColors.color600,
                                fontSize: 16,
                              )
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                            child: Text(
                              message["time"],
                              style: TextStyle(fontSize: 13, color: AppColors.color600),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
              _buildMessageInput(),
            ]
          )
        ),
      )
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.color200,width: 2)),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () => {}, icon: Icon(Icons.emoji_emotions_outlined, color: AppColors.color600)
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Nhập tin nhắn...",
                hintStyle: AppTextStyles.bodyText2.copyWith(
                  color: AppColors.color600,
                  fontSize: 16,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.color200, width: 1),
                    borderRadius: BorderRadius.circular(50)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.colorButton, width: 1),
                    borderRadius: BorderRadius.circular(50)),
                border: InputBorder.none,
              ),
              onTap: () {
                setState(() {});
              },
              textInputAction: TextInputAction.send,
            )
          ),
          IconButton(
              onPressed: () => {}, icon: Icon(Icons.attach_file_outlined, color: AppColors.color600)
          ),
          IconButton(
              onPressed: () => {}, icon: Icon(Icons.keyboard_voice_outlined, color: AppColors.color600)
          ),

        ],
      ),
    );
  }
}
