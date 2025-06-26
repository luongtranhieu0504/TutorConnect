import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/data/manager/status.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/message/message_bloc.dart';
import 'package:tutorconnect/presentation/screens/message/message_state.dart';
import 'package:tutorconnect/presentation/widgets/search_text_field.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../domain/model/conversation.dart';
import '../../../domain/model/user.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _bloc = getIt<MessageBloc>();
  final _searchController = TextEditingController();
  final user = Account.instance.user;
  final student = Account.instance.student;
  final tutor = Account.instance.tutor;
  final Map<int, dynamic> _userStatuses = {};

  bool isUnread = true;

  @override
  void initState() {
    super.initState();
    if (user.typeRole == "Student") {
      _bloc.getConversations(studentId: student!.id);
    } else {
      _bloc.getConversations(tutorId: tutor!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is MessageLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MessageSuccessState) {
          final conversations = state.conversations;
          return _uiContent(conversations);
        } else if (state is MessageFailureState) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return Container();
      },
    );
  }

  Widget _uiContent(List<Conversation> conversations) {
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
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      return _messageCard(conversations[index], context);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _messageCard(Conversation conversation, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final otherUserId = conversation.otherUser?.id;

    if (!_userStatuses.containsKey(otherUserId)) {
      StatusManager.instance.fetchUserStatus(otherUserId!);
    }
    final userData = _userStatuses[otherUserId];
    final bool isOnline = userData != null && userData['state'] == "online";
    return GestureDetector(
      onTap: () {
        // In MessageScreen._messageCard:
        // Create a User object from OtherUser
        final user = User(
          conversation.otherUser!.id,
          null,
          conversation.otherUser!.email,
          null,
          null,
          conversation.otherUser!.name,
          null,
          null,
          null,
          conversation.otherUser!.photoUrl,
          null,
          null,
          null,
          null,
          null,
          [],
          [],
          [],
          [],
        );
        context.push(
          Routes.chatPage,
          extra: {
            'user': user,
            'conversation': conversation,
          },
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
                      backgroundImage:
                          NetworkImage(conversation.otherUser!.photoUrl!),
                    ),
                    if (isOnline)
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
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(conversation.otherUser!.name!,
                        style: AppTextStyles(context).bodyText2.copyWith(
                              fontSize: 15,
                            )),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black : Color(0xFFE2E8F0),
                      ),
                    )
                  ]),
                  Text(conversation.lastMessage!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isUnread
                          ? AppTextStyles(context).bodyText2.copyWith(
                                fontSize: 12,
                              )
                          : AppTextStyles(context).bodyText2.copyWith(
                                fontSize: 12,
                              ))
                ]),
                Spacer(),
                Text(FormatUtils.formatTimeAgo(conversation.lastTimestamp!),
                    style:
                        AppTextStyles(context).bodyText2.copyWith(fontSize: 11))
              ],
            ),
          ),
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
