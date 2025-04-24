import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/data/models/users.dart';
import 'package:tutorconnect/theme/color_platte.dart';

import '../../../common/services/cloudinary_service.dart';
import '../../../data/manager/status.dart';
import '../../../data/models/chat.dart';
import '../../../di/di.dart';
import '../../../theme/text_styles.dart';
import 'chat_bloc.dart';
import 'chat_state.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final UserModel user;

  const ChatScreen(this.conversationId,{super.key,required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _bloc = getIt<ChatBloc>();
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showEmoji = false;
  final user = Account.instance.user;
  String _otherUserStatus = 'offline';
  StreamSubscription? _statusSubscription;


  @override
  void initState() {
    super.initState();
    messageFocusNode.addListener(_onFocusChange);
    messageFocusNode.requestFocus();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        setState(() {
          _showEmoji = false;
        });
      }
    });
    if (widget.conversationId.isNotEmpty) {
      _bloc.listenChat(widget.conversationId);
    } else {
      _bloc.createOrGetConversation(user.uid, widget.user.uid);
    }
    // Get initial status
    StatusManager.instance.getUserStatus(widget.user.uid).then((status) {
      if (mounted) {
        setState(() => _otherUserStatus = status);
      }
    });

    // Listen for status changes
    StatusManager.instance.listenToUserStatus(widget.user.uid);
    _statusSubscription = StatusManager.instance.userStatusStream.listen((statuses) {
      if (mounted && statuses.containsKey(widget.user.uid)) {
        setState(() => _otherUserStatus = statuses[widget.user.uid]!);
      }
    });


  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    _scrollController.dispose();
    if (messageController.toString().isEmpty) {
      _bloc.deleteConversation(widget.conversationId);
      // Return true to indicate the conversation was deleted
      context.pop(true);
    } else {
      // Return false to indicate the conversation was not deleted
      context.pop(false);
    }
    super.dispose();
  }

  void sendMessage() {
    if (messageController.text.isEmpty) return;

    final message = ChatModel(
      id: '',
      senderId: user.uid,
      receiverId: widget.user.uid,
      content: messageController.text,
      timestamp: DateTime.now(),
      isRead: false,
      type: 'text',
    );
    _bloc.sendChat(_getCurrentConversationId(), message);
    _onFocusChange();
  }

  Future<void> sendMediaMessage(File file, String mediaType) async {
    // Show loading indicator
    final loadingContext = context; // Capture context
    showDialog(
      context: loadingContext,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Upload media to Cloudinary
      final mediaData = await uploadToCloudinary(file, mediaType);

      // Close loading dialog
      Navigator.of(loadingContext).pop();

      if (mediaData != null) {
        // Create chat message based on media type
        final message = ChatModel(
          id: '',
          senderId: user.uid,
          receiverId: widget.user.uid,
          content: 'Sent ${mediaType}', // Default content
          timestamp: DateTime.now(),
          isRead: false,
          type: mediaType,
          imageUrl: mediaType == 'image' ? mediaData['url'] : null,
          videoUrl: mediaType == 'video' ? mediaData['url'] : null,
          fileUrl: mediaType == 'file' ? mediaData['url'] : null,
        );

        _bloc.sendChat(_getCurrentConversationId(), message);
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(loadingContext).pop();
      print("Error sending media: $e");

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send media. Please try again.'))
      );
    }
  }

  String _getCurrentConversationId() {
    // If we're looking at a chat state success, we can get the message ID from there
    if (_bloc.state is ChatSuccess) {
      return (_bloc.state as ChatSuccess).conversationId;
    }
    // Otherwise use the one passed to the widget
    return widget.conversationId;
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

  Future<void> _pickImage({bool camera = false}) async {
    // Implement your image picking logic here
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        sendMediaMessage(File(image.path), 'image');
      }
    } catch (e) {
      // Handle any errors that occur during image picking
      print("Error picking image: $e");
    }
  }

  Future<void> pickVideo()  async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      if (video != null) {
        sendMediaMessage(File(video.path), 'video');
      }
    } catch (e) {
      // Handle any errors that occur during video picking
      print("Error picking video: $e");
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        sendMediaMessage(file, 'file');
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is ChatLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ChatSuccess) {
          final chats = state.chats;
          if (chats.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToLastMessage();
            });
          }

          return _uiContent(chats);
        } else if (state is ChatFailure) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return Container();
      },
    );
  }

  Widget _uiContent(List<ChatModel> chats) {
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
                  itemCount: chats.length,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final message = chats[index];
                    final isMine = message.senderId == user.uid;
                    return _buildMessageBubble(message, isMine);
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
    final isOnline = _otherUserStatus == 'online';
    return SafeArea(
      child: InkWell(
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.user.photoUrl ?? ''),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 10),
          Text(widget.user.name ?? '',
              style: AppTextStyles(context).bodyText1.copyWith(
                    fontSize: 20,
                  )),
          SizedBox(width: 8),
          Spacer(),
          IconButton(
            onPressed: () => {},
            icon: SvgPicture.asset(
              'assets/icons/phone.svg',
              color: isDarkMode ? Colors.blueAccent : Colors.black,
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
                          ? Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.85)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withOpacity(
                                0.08) // tạo border nhẹ cho dark mode
                            : Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black
                                  .withOpacity(0.3) // bóng nhẹ dark mode
                              : Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ]),
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
                        onPressed: () => pickFile(),
                        icon: Icon(Icons.attach_file_outlined,
                            color: isDarkMode
                                ? Colors.blueAccent
                                : AppColors.color600)),
                    IconButton(
                        onPressed: () => _showMediaOptions(),
                        icon: SvgPicture.asset("assets/icons/picture.svg")
                    ),
                  ]))),
          MaterialButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                sendMessage();
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

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 180,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Chọn phương thức gửi",
              style: AppTextStyles(context).bodyText1.copyWith(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mediaOptionButton(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(camera: true);
                  },
                ),
                _mediaOptionButton(
                  icon: Icons.photo,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _mediaOptionButton(
                  icon: Icons.videocam,
                  label: "Video",
                  onTap: () {
                    Navigator.pop(context);
                    pickVideo();
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _mediaOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.blueAccent),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatModel message, bool isMine) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    Widget contentWidget;

    switch (message.type) {
      case 'image':
        if (message.imageUrl != null) {
          contentWidget = _buildImageMessage(message.imageUrl!, maxWidth);
        } else {
          // Fallback for missing image URL
          contentWidget = Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.broken_image, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  "Image unavailable",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }
        break;
      case 'video':
        if (message.videoUrl != null) {
          contentWidget = _buildVideoMessage(message.videoUrl!, maxWidth);
        } else {
          contentWidget = Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.videocam_off, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  "Video unavailable",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }
        break;
      case 'file':
        if (message.fileUrl != null) {
          contentWidget = _buildFileMessage(message.fileUrl!, maxWidth);
        } else {
          contentWidget = Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.file_present_outlined, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  "File unavailable",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }
        break;
      default:
        contentWidget = Text(
          message.content,
          style: AppTextStyles(context).bodyText2.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        );
    }

    return Column(
      crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMine ? Color(0xFF8932EB) : Color(0xFF3E4042),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMine ? Radius.circular(12) : Radius.zero,
              bottomRight: isMine ? Radius.zero : Radius.circular(12),
            ),
          ),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: contentWidget,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Text(
            FormatUtils.formatTimeAgo(message.timestamp),
            style: TextStyle(fontSize: 13, color: AppColors.color600),
          ),
        ),
      ],
    );
  }
  
  Widget _buildImageMessage(String imageUrl, double maxWidth) {
    return GestureDetector(
      onTap: () => _viewImage(imageUrl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: maxWidth - 16, // Account for padding
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: maxWidth - 16,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / 
                        loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => 
              Icon(Icons.broken_image, size: 50, color: Colors.white70),
        ),
      ),
    );
  }
  
  Widget _buildVideoMessage(String videoUrl, double maxWidth) {
    return Container(
      width: maxWidth - 16,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              IconButton(
                icon: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                onPressed: () => _playVideo(videoUrl),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "Video",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFileMessage(String fileUrl, double maxWidth) {
    // Extract filename from URL or use generic name
    final fileName = fileUrl.split('/').last.split('?').first;
    
    return GestureDetector(
      onTap: () => _downloadFile(fileUrl, fileName),
      child: Container(
        width: maxWidth - 16,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName.length > 20 ? fileName.substring(0, 20) + "..." : fileName,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tap to download",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.download, color: Colors.white70),
          ],
        ),
      ),
    );
  }
  
  void _viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(imageUrl),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
  
  void _playVideo(String videoUrl) {
    // Implement video player functionality or open the URL in browser
    // This would typically use a video player package like video_player
    // For now, we'll just show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Video Player"),
        content: Text("Video would play here.\nURL: $videoUrl"),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  void _downloadFile(String fileUrl, String fileName) async {
    final result = await downloadFileFromCloudinary(fileUrl, fileName);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded successfully'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file'))
      );
    }
  }
}
