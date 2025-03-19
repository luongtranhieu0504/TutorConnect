import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/data/models/message.dart';
import 'package:tutorconnect/presentation/widgets/search_text_field.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _searchController = TextEditingController();
  final List<MessageModel> chatUsers = [
    MessageModel(
      name: "Robert Fox",
      subject: "ARCH116",
      message: "Hello, I need help with the recent...",
      time: "3h ago",
      avatarUrl: "assets/images/ML1.png",
      isUnread: true,
      isOnline: true, // Online
    ),
    MessageModel(
      name: "Jane Cooper",
      subject: "MAT116",
      message: "Hello, I need to fix that as...",
      time: "19h ago",
      avatarUrl: "assets/images/ML1.png",
      isUnread: false,
      isOnline: false, // Offline
    ),
    MessageModel(
      name: "Esther Howard",
      subject: "MAT116",
      message: "Hello, I'm struggling with a conce...",
      time: "1d ago",
      avatarUrl: "assets/images/ML1.png",
      isUnread: true,
      isOnline: true, // Online
    ),
    MessageModel(
      name: "Jacob Jones",
      subject: "ARCH116",
      message: "Hi, I have some questions about t...",
      time: "2d ago",
      avatarUrl: "assets/images/ML1.png",
      isUnread: false,
      isOnline: false, // Offline
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _uiContent();
  }

  Widget _uiContent() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin nhắn"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTextField(
              controller: _searchController,
              labelText: "Tìm kiếm",
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: chatUsers.length,
                itemBuilder: (context, index) {
                  return _messageCard(chatUsers[index], index == chatUsers.length - 1,context);
                })
            )
          ],
        ),
      ),
    );
  }

  Widget _messageCard(MessageModel message, bool isLastItem, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/chat',
            extra: {
              "name": message.name,
              "subject": message.subject,
              "isOnline": message.isOnline,
              "avatarUrl": message.avatarUrl
            }
        );
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(message.avatarUrl),
                    ),
                    if (message.isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          message.name,
                          style: AppTextStyles.bodyText1.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                          )
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFE2E8F0),
                          ),
                          child: Text(
                            message.subject,
                            style: AppTextStyles.bodyText1.copyWith(
                              color: AppColors.color600,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            )
                          ),
                        )
                      ]
                    ),
                    Text(
                      message.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: message.isUnread ? AppTextStyles.bodyText1.copyWith(
                        color: AppColors.color500,
                        fontSize: 15,
                      ) : AppTextStyles.bodyText1.copyWith(
                        color: AppColors.color800,
                        fontSize: 15,
                      )
                    )
                  ]
                ),
                Spacer(),
                Text(
                  message.time,
                  style: AppTextStyles.bodyText1.copyWith(
                    color: AppColors.color600,
                    fontSize: 14
                  )
                )
              ],
            ),
          ),
          if (!isLastItem)
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
