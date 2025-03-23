import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/theme/color_platte.dart';

import '../../../main.dart';
import '../../../theme/text_styles.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String subject;
  final bool isOnline;
  final String avatarUrl;

  const ChatScreen(
      {super.key,
      required this.name,
      required this.subject,
      required this.isOnline,
      required this.avatarUrl});

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
      "text":
          "I'm confused about the second question. It's asking for a root cause analysis, but I'm not sure how to start.",
      "isMine": true,
      "time": "Saturday, 08:05 am"
    },
    {
      "text":
          "Okay, let’s break it down. First, identify the main problem, then list potential causes. After that, we’ll analyze and find the root cause.",
      "isMine": false,
      "time": "Saturday, 08:10 am"
    },
    {
      "text":
          "Got it, thanks! That makes more sense. I’ll give it a try and let you know if I have more questions.",
      "isMine": true,
      "time": "Saturday, 08:15 am"
    }
  ];
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showEmoji = false;

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
        messages.add(
            {"text": messageController.text, "isMine": true, "time": "Now"});
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus;
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: SafeArea(
              child: Column(children: [
            Expanded(
              child: ListView.builder(
                  itemCount: messages.length,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Column(
                      crossAxisAlignment: message["isMine"]
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: message["isMine"]
                                    ? Color(0xFF8932EB)
                                    : Color(0xFF3E4042),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: message["isMine"]
                                      ? Radius.circular(12)
                                      : Radius.zero,
                                  bottomRight: message["isMine"]
                                      ? Radius.zero
                                      : Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  )
                                ]),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            child: Text(message["text"],
                                style: AppTextStyles(context).bodyText2.copyWith(
                                  color: message["isMine"]
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 16,
                                ))),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          child: Text(
                            message["time"],
                            style: TextStyle(
                                fontSize: 13, color: AppColors.color600),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            _buildMessageInput(),
            if (_showEmoji)
              SizedBox(
                  child: EmojiPicker(
                textEditingController: messageController,
                config: const Config(),
              ))
          ])),
        ),
      ),
    );
  }

  Widget _appBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: InkWell(
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
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
          Text(widget.name,
              style: AppTextStyles(context).bodyText1.copyWith(
                fontSize: 20,
              )),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFE2E8F0),
            ),
            child: Text(widget.subject,
                style: AppTextStyles(context).bodyText1.copyWith(
                  color: AppColors.color600,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                )),
          ),
          Spacer(),
          IconButton(
            onPressed: () => {},
            icon: SvgPicture.asset(
              'assets/icons/phone.svg',
              color: isDarkMode ? Colors.blueAccent : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: SvgPicture.asset(
              'assets/icons/video.svg',
              color: isDarkMode ? Colors.blueAccent : Colors.white,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildMessageInput() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.surface.withOpacity(0.85)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.08) // tạo border nhẹ cho dark mode
                            : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3) // bóng nhẹ dark mode
                              : Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ]
                  ),
                  child: Row(children: [
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Nhập tin nhắn...",
                        hintStyle: AppTextStyles(context).bodyText2.copyWith(
                          color: AppColors.color600,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        setState(() {});
                      },
                      textInputAction: TextInputAction.send,
                    )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.attach_file_outlined,
                            color: isDarkMode ? Colors.blueAccent : AppColors.color600
                        )),
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(Icons.keyboard_voice_outlined,
                            color: isDarkMode ? Colors.blueAccent : AppColors.color600
                        )
                    ),
                  ]
                  )
              )
          ),
          MaterialButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                if (messages.isEmpty) {
                  sendMessage();
                }
                messageController.text = '';
              }
            },
            minWidth: 0,
            padding:
            const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.blueAccent,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
