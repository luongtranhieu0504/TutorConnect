import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/screens/post/post_bloc.dart';

import '../../../common/services/cloudinary_service.dart';
import '../../../data/manager/account.dart';
import '../../../domain/model/post.dart';
import '../../../theme/text_styles.dart';

class PostBottomSheet extends StatefulWidget {
  const PostBottomSheet({super.key});

  @override
  State<PostBottomSheet> createState() => _PostBottomSheetState();
}

class _PostBottomSheetState extends State<PostBottomSheet>
    with SingleTickerProviderStateMixin{
  final _bloc = getIt<PostBloc>();
  late AnimationController _controller;
  late DraggableScrollableController _scrollController;
  final TextEditingController _contentController = TextEditingController();
  final ValueNotifier<bool> _hasText = ValueNotifier(false);
  List<File> selectedAssets = [];
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _scrollController = DraggableScrollableController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _contentController.addListener(() {
      _hasText.value = _contentController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _hasText.dispose();
    super.dispose();
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

  Future<void> _handlePostCreation() async {
    if (_contentController.text.isEmpty && selectedAssets.isEmpty) {
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
      final newPost = Post(
        0,
        _contentController.text,
        imageUrls,
        Account.instance.user,
        [],
         0,
        0,
        DateTime.now(),
        [],
      );

      _bloc.createPost(newPost);

      // Refresh PostScreen
      Navigator.of(context).pop(); // Close the bottom sheet
      getIt<PostBloc>().getPosts(); // Trigger refresh in PostScreen
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


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _scrollController,
      initialChildSize: 0.9,
      // ~30px cách top
      minChildSize: 0.4,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: [0.9],
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent < 0.6) {
              Navigator.of(context).pop(); // hạ xuống nếu dưới 60%
            }
            return true;
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Hủy",
                            style: AppTextStyles(context)
                                .bodyText2
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        Text(
                          "Đăng bài viết",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            // Handle post action
                            _handlePostCreation();
                          },
                          icon: Icon(Icons.check),
                        )
                      ]),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                NetworkImage(
                                  Account.instance.user.photoUrl!
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 40.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Account.instance.user.name!,
                                        style: AppTextStyles(context)
                                            .bodyText1
                                            .copyWith(fontSize: 16),
                                      ),
                                      TextField(
                                        controller: _contentController,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          hintText: "Bạn muốn đăng gì ?",
                                          border: InputBorder.none,
                                          hintStyle: AppTextStyles(context)
                                              .bodyText2
                                              .copyWith(
                                              fontSize: 16,
                                              color: Colors.grey[400]),
                                        ),
                                        style: AppTextStyles(context).bodyText2,
                                      ),
                                      if (selectedAssets.isNotEmpty)
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: 100,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: selectedAssets.length,
                                              itemBuilder: (context, index) {
                                                return Stack(children: [
                                                  Image.file(
                                                    File(selectedAssets[index].path),
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        setState(() {
                                                          selectedAssets.removeAt(index);
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ]);
                                              },
                                            ),
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.photo_camera_outlined),
                                              onPressed: () {
                                                _takePhotoWithCamera();
                                              }),
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.photo_library_outlined),
                                              onPressed: () {
                                                _pickImagesFromGallery();
                                              }),
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.location_on_outlined),
                                              onPressed: () {}),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _hasText,
                                builder: (context, hasText, child) {
                                  return hasText
                                      ? IconButton(
                                    onPressed: () {
                                      _contentController.clear();
                                      _hasText.value = false;
                                    },
                                    icon: Icon(Icons.close),
                                  )
                                      : SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
