// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../domain/models/post_model.dart';
// import '../../../theme/text_styles.dart';
//
// class PostBottomSheet extends StatefulWidget {
//   const PostBottomSheet({super.key});
//
//   @override
//   State<PostBottomSheet> createState() => _PostBottomSheetState();
// }
//
// class _PostBottomSheetState extends State<PostBottomSheet>
//     with SingleTickerProviderStateMixin{
//   late AnimationController _controller;
//   late DraggableScrollableController _scrollController;
//   final TextEditingController _commentController = TextEditingController();
//   final ValueNotifier<bool> _hasText = ValueNotifier(false);
//   List<XFile> selectedAssets = [];
//
//   final newPost = Post(
//     id: '',
//     authorId: 'currentUserId',
//     // You'd get this from auth
//     authorName: 'luong_tran_hieu',
//     // You'd get this from user profile
//     authorRole: 'your_role',
//     authorPhotoUrl: '',
//     content: '',
//     imageUrls: [],
//     createdAt: DateTime.now(),
//     likeCount: 0,
//     likedBy: [],
//     commentCount: 0,
//   );
//
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = DraggableScrollableController();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _commentController.addListener(() {
//       _hasText.value = _commentController.text.isNotEmpty;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     _hasText.dispose();
//     super.dispose();
//   }
//
//
//   Future<void> _takePhotoWithCamera() async {
//     final permission = await Permission.camera.request();
//     if (permission.isGranted) {
//       final picker = ImagePicker();
//       final photo = await picker.pickImage(source: ImageSource.camera);
//       if (photo != null) {
//         setState(() {
//           selectedAssets.add(photo);
//         });
//       }
//     } else {
//       openAppSettings();
//     }
//   }
//
//   Future<void> _pickImagesFromGallery() async {
//     final picker = ImagePicker();
//     final List<XFile> pickedFiles = await picker.pickMultiImage(
//       imageQuality: 50, // nén ảnh nhẹ để tối ưu tốc độ
//     );
//     if (pickedFiles.isEmpty) return;
//     setState(() {
//       selectedAssets = pickedFiles; // lưu lại danh sách ảnh được chọn
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       controller: _scrollController,
//       initialChildSize: 0.9,
//       // ~30px cách top
//       minChildSize: 0.4,
//       maxChildSize: 0.9,
//       snap: true,
//       snapSizes: [0.9],
//       builder: (context, scrollController) {
//         return NotificationListener<DraggableScrollableNotification>(
//           onNotification: (notification) {
//             if (notification.extent < 0.6) {
//               Navigator.of(context).pop(); // hạ xuống nếu dưới 60%
//             }
//             return true;
//           },
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Container(
//                   width: 50,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text(
//                             "Hủy",
//                             style: AppTextStyles(context)
//                                 .bodyText2
//                                 .copyWith(fontSize: 18),
//                           ),
//                         ),
//                         Text(
//                           "Đăng bài viết",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             // Handle post action
//                           },
//                           icon: Icon(Icons.check),
//                         )
//                       ]),
//                 ),
//                 const Divider(
//                   thickness: 1,
//                   color: Colors.grey,
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CircleAvatar(
//                                 radius: 20,
//                                 backgroundImage:
//                                 AssetImage('assets/images/ML1.png'),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(right: 40.0),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         newPost.authorName,
//                                         style: AppTextStyles(context)
//                                             .bodyText1
//                                             .copyWith(fontSize: 16),
//                                       ),
//                                       TextField(
//                                         controller: _commentController,
//                                         maxLines: null,
//                                         decoration: InputDecoration(
//                                           hintText: "Bạn muốn đăng gì ?",
//                                           border: InputBorder.none,
//                                           hintStyle: AppTextStyles(context)
//                                               .bodyText2
//                                               .copyWith(
//                                               fontSize: 16,
//                                               color: Colors.grey[400]),
//                                         ),
//                                         style: AppTextStyles(context).bodyText2,
//                                       ),
//                                       if (selectedAssets.isNotEmpty)
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.only(top: 8.0),
//                                           child: SizedBox(
//                                             height: 100,
//                                             child: ListView.builder(
//                                               scrollDirection: Axis.horizontal,
//                                               itemCount: selectedAssets.length,
//                                               itemBuilder: (context, index) {
//                                                 return Stack(children: [
//                                                   Image.file(
//                                                     File(selectedAssets[index].path),
//                                                     width: 100,
//                                                     height: 100,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                   Positioned(
//                                                     right: 0,
//                                                     child: IconButton(
//                                                       icon: Icon(Icons.close),
//                                                       onPressed: () {
//                                                         setState(() {
//                                                           selectedAssets.removeAt(index);
//                                                         });
//                                                       },
//                                                     ),
//                                                   )
//                                                 ]);
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         children: [
//                                           IconButton(
//                                               icon: const Icon(
//                                                   Icons.photo_camera_outlined),
//                                               onPressed: () {
//                                                 _takePhotoWithCamera();
//                                               }),
//                                           IconButton(
//                                               icon: const Icon(
//                                                   Icons.photo_library_outlined),
//                                               onPressed: () {
//                                                 _pickImagesFromGallery();
//                                               }),
//                                           IconButton(
//                                               icon: const Icon(
//                                                   Icons.location_on_outlined),
//                                               onPressed: () {}),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               ValueListenableBuilder<bool>(
//                                 valueListenable: _hasText,
//                                 builder: (context, hasText, child) {
//                                   return hasText
//                                       ? IconButton(
//                                     onPressed: () {
//                                       _commentController.clear();
//                                       _hasText.value = false;
//                                     },
//                                     icon: Icon(Icons.close),
//                                   )
//                                       : SizedBox.shrink();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
