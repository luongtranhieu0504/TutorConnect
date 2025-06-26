import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/screens/comment/comment_bloc.dart';
import 'package:tutorconnect/presentation/widgets/expandable_text.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../common/services/cloudinary_service.dart';
import '../../../common/utils/load_image_category.dart';
import '../../../data/manager/account.dart';
import '../../../domain/model/comment.dart';
import '../../../domain/model/post.dart';
import '../../../theme/theme_ultils.dart';
import 'comment_state.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  const CommentScreen({super.key, required this.post});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _bloc = getIt<CommentBloc>();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late bool _favorite = false;
  bool isMediaPickerVisible = false;
  List<File> selectedAssets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Filter comments to only show those related to this post
    _bloc.loadComments(widget.post.id);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isMediaPickerVisible = false; // Ẩn media picker khi focus vào text
        });
      }
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleComment() async {
    if (_commentController.text.isEmpty && selectedAssets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập nội dung hoặc chọn ảnh")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload images to Cloudinary
      List<String> imageUrls = [];
      for (var file in selectedAssets) {
        final result = await uploadToCloudinary(file, 'image');
        if (result != null) {
          imageUrls.add(result['url']!);
        }
      }

      // Create post
      final newComment = Comment(
        0,
        _commentController.text,
        imageUrls,
        Account.instance.user,
        widget.post,
        DateTime.now(),
      );

      _bloc.addComment(newComment);

      // Refresh PostScreen
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _toggleMediaPicker() async {
    FocusScope.of(context).unfocus(); // Ẩn bàn phím
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isMediaPickerVisible = !isMediaPickerVisible;
    });
  }

  Future<void> _takePhotoWithCamera() async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final file = File(photo.path); // Convert XFile to File
        setState(() {
          selectedAssets.add(file); // Add File to the list
        });
      }
    } else {
      openAppSettings();
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(
      imageQuality: 50, // Compress images for optimization
    );
    if (pickedFiles.isEmpty) return;

    setState(() {
      selectedAssets = pickedFiles.map((xFile) => File(xFile.path)).toList(); // Convert XFile to File
    });
  }




  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is CommentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CommentLoaded) {
          final comments = state.comments;
          return _buildContent(comments,context);
        } else if (state is CommentError) {
          return Center(child: Text('Error loading comments'));
        }
        return Container();
      },
    );
  }

  Widget _buildContent(List<Comment> comments,BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: _appBar(context),
      ),
      body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible && isMediaPickerVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isMediaPickerVisible = false;
            });
          });
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    bottom: isKeyboardVisible
                        ? MediaQuery.of(context).viewInsets.bottom + 70
                        : (isMediaPickerVisible ? 300 : 70),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.post.content!,
                            style: AppTextStyles(context).bodyText2.copyWith(
                              fontSize: 16,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onBackground,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                _favorite ? Icons.favorite : Icons
                                    .favorite_border,
                                color: _favorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _favorite = !_favorite;
                                });
                              },
                            ),
                            Text(
                              "${widget.post.likeCount} Likes",
                              style: AppTextStyles(context).bodyText2.copyWith(
                                fontSize: 14,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onBackground,
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return _buildCommentItem(comment);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              _commentInputBar(context),
              _buildMediaPickerWrapper(),
            ]);
          });
      }),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final bool isCurrentUserAuthor = comment.author?.id == Account.instance.user.id;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment.author!.photoUrl!), // Replace with comment.authorPhotoUrl
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(comment.author!.name!,
                              style: AppTextStyles(context)
                                  .bodyText1
                                  .copyWith(fontSize: 14)),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: comment.author?.typeRole == 'Tutor'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                comment.author!.typeRole!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: comment.author?.typeRole == 'Tutor'
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(FormatUtils.formatTimeAgo(comment.createdAt!),
                              style: AppTextStyles(context)
                                  .bodyText2
                                  .copyWith(fontSize: 12)),
                          // if (isCurrentUserAuthor)
                          //   IconButton(
                          //     icon: Icon(Icons.edit, size: 14),
                          //     constraints: BoxConstraints(),
                          //     onPressed: () => {},
                          //   ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  ExpandableText(comment.content!,
                      style: AppTextStyles(context).bodyText2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ??
              Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Đổ bóng nhẹ để tách biệt
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.post.author!.photoUrl!),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.post.author!.name!,
                      style: AppTextStyles(context).bodyText1.copyWith(
                            fontSize: 16,
                          )),
                  Text(FormatUtils.formatTimeAgo(widget.post.createdAt),
                      style: AppTextStyles(context).bodyText2.copyWith(
                            fontSize: 13,
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentInputBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  _toggleMediaPicker();
                },
                icon: themedIcon(Icons.add_a_photo, context, size: 28) // Thay đổi icon
            ),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Viết bình luận...',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () {
                  _scrollToBottom();
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  _handleComment();
                });
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
      ),
    );
  }

  Widget _mediaPicker() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: isMediaPickerVisible ? 400 : 0,
      padding: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              IconButton(
                onPressed: () {
                  _takePhotoWithCamera();
                },
                icon: Icon(Icons.camera_alt),
              ),
              ElevatedButton.icon(
                onPressed: _pickImagesFromGallery,
                icon: Icon(Icons.photo_library),
                label: Text('Chọn ảnh'),
              ),
            ],
          ),
          if (selectedAssets.isNotEmpty)
            Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: selectedAssets.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (_, index) {
                final file = selectedAssets[index];
                return Stack(
                  children: [
                    Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPickerWrapper() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: isMediaPickerVisible
          ? Container(
        key: ValueKey("mediaPickerVisible"),
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: _mediaPicker(),
      )
          : SizedBox.shrink(key: ValueKey("mediaPickerHidden")),
    );
  }


}
