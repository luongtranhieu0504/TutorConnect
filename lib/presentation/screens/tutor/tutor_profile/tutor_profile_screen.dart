import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/domain/model/schedule_slot.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_bloc.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/format_utils.dart';
import '../../../../common/utils/number_formatter.dart';
import '../../../../di/di.dart';
import '../../../../domain/model/certification.dart';
import '../../../../domain/model/review.dart';
import '../../../../domain/model/tutor.dart';
import '../../../../theme/color_platte.dart';
import '../../../../theme/text_styles.dart';
import '../../../navigation/route_model.dart';

class TutorProfileScreen extends StatefulWidget {
  final Tutor tutor;
  final bool isCurrentUser;

  const TutorProfileScreen(
      {super.key, required this.tutor, required this.isCurrentUser});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  final _bloc = getIt<TutorProfileBloc>();
  int _currentIndex = 0;
  late int _rating = 5;
  final _comment = TextEditingController();
  final Map<int, Widget> tabs = const <int, Widget>{
    0: Text('Info'),
    1: Text('Reviews'),
  };
  final student = Account.instance.student;
  final user = Account.instance.user;

  late bool _isFavorite =
      student?.favorites.any((tutor) => tutor == widget.tutor.id) ?? false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getReviews(widget.tutor.id);
    _bloc.addBroadcast.listen((state) {
      state.when(
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        },
        success: (data) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đánh giá thành công!")),
          );
        },
        failure: (message) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đánh giá thất bại!")),
          );
        },
      );
    });
    _bloc.openChatBroadcast.listen((state) {
      state.when(
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        },
        success: (data) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Mở cuộc trò chuyện thành công!")),
          );
          context.push(Routes.chatPage, extra: {
            'conversation': data,
            'user': widget.tutor.user,
          });
        },
        failure: (message) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Mở cuộc trò chuyện thất bại!")),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorProfileBloc, TutorProfileState>(
      builder: (context, state) {
        if (state is TutorProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TutorProfileSuccess) {
          final reviews = state.reviews;
          return _buildContent(reviews);
        } else if (state is TutorProfileFailure) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text("Unknown state"));
      },
      bloc: _bloc,
    );
  }

  Widget _buildContent(List<Review> reviews) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ gia sư'),
        actions: [
          if (widget.isCurrentUser)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _openEditTutorDialog(widget.tutor);
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (widget.isCurrentUser) {
                    context.push(Routes.personalInfoPage);
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.tutor.user.photoUrl!),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.tutor.user.name!,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                widget.tutor.user.email!,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              if (widget.isCurrentUser == false)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _isFavorite = !_isFavorite);
                            final currentFavorites =
                                student!.favorites.map((t) => t).toList();
                            if (!currentFavorites.contains(widget.tutor.id)) {
                              currentFavorites.add(widget.tutor.id);
                              _bloc.addFavoriteTutor(
                                studentId: student!.id,
                                tutorId: currentFavorites,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Gia sư này đã có trong danh sách yêu thích")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFavorite
                                ? AppColors.color500
                                : AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: _isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                          label: Text(
                            'Yêu thích',
                            style: AppTextStyles(context).bodyText2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _bloc.findOrCreateConversation(
                                student!.id, widget.tutor.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Nhắn tin',
                            style: AppTextStyles(context).bodyText2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              _segmentedTabInfo(),
              SizedBox(height: 10),
              // Button favorite, chat
              IndexedStack(
                index: _currentIndex,
                children: [
                  // Info Tab
                  _buildInfoTab(),
                  _buildReviewsTab(reviews),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmentedTabInfo() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: MaterialSegmentedControl(
              children: tabs,
              selectionIndex: _currentIndex,
              selectedColor: AppColors.colorButton,
              unselectedColor:
                  isDarkMode ? AppColors.color900 : AppColors.color100,
              onSegmentTapped: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              Icons.school, 'Môn dạy: ${widget.tutor.subjects?.join(', ')}'),
          _buildInfoRow(
              Icons.location_on, 'Khu vực: ${widget.tutor.user.address}'),
          _buildInfoRow(Icons.attach_money,
              'Giá dạy: ${NumberFormatter.formatCurrency(widget.tutor.pricePerHour!)}VND/h'),
          _buildInfoRow(Icons.calendar_today,
              'Kinh nghiệm: ${widget.tutor.experienceYears} năm'),
          SizedBox(height: 16),
          buildAvailability(widget.tutor.availability!),
          SizedBox(height: 16),
          Text(
            'Giới thiệu:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            widget.tutor.bio ?? '',
            style: AppTextStyles(context).bodyText2.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.color700,
                ),
          ),
          SizedBox(height: 16),
          Text(
            'Bằng cấp & chứng chỉ:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          buildCertifications(widget.tutor.certifications!),
        ],
      ),
    );
  }

  Widget buildAvailability(List<ScheduleSlot> availability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🕒 Lịch dạy cố định:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        ...availability.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Thứ ${a.weekday}: ${a.startTime!.format(context)} - ${a.endTime!.format(context)}",
                      style: AppTextStyles(context).bodyText2),
                ],
              ),
            )),
      ],
    );
  }

  Widget buildCertifications(List<Certification> certifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "📜 Chứng chỉ:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        ...certifications.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ${c.title} (${c.issuedAt})",
                      style: AppTextStyles(context).bodyText2),
                  ElevatedButton(
                    onPressed: () => openPdfUrl(c.file!),
                    child: Text("Xem chứng chỉ"),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles(context).bodyText2)),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(List<Review> reviews) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá từ học viên:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          _buildReview(reviews),
          SizedBox(height: 8),
          if (!widget.isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _popupReview();
                },
                icon: Icon(Icons.edit),
                label: Text('VIẾT ĐÁNH GIÁ'),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildReview(List<Review> reviews) {
    if (reviews.isEmpty) {
      return Text("Chưa có đánh giá nào.",
          style: AppTextStyles(context).bodyText2.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews.map((review) {
        final stars = List.generate(
          review.rating!,
          (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(children: stars),
                  const SizedBox(width: 8),
                  Text(
                    '- ${review.studentName} (${FormatUtils.formatDate(review.date!)})',
                    style: AppTextStyles(context).bodyText2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.comment!,
                style: AppTextStyles(context).bodyText2,
              ),
              Divider()
            ],
          ),
        );
      }).toList(),
    );
  }

  void _popupReview() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Viết đánh giá'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Đánh giá về gia sư ${widget.tutor.user.name}',
                style: AppTextStyles(context).bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 32,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => _rating = rating.toInt(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _comment,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Nhập nhận xét của bạn...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _submitReview();
                });
              },
              child: Text('Gửi'),
            ),
          ],
        );
      },
    );
  }

  void openPdfUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _submitReview() {
    if (_comment.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập nhận xét")),
      );
      return;
    }
    _bloc.addReview(
      widget.tutor.id,
      student!.id,
      user.name!,
      _rating,
      _comment.text,
    );
    Future.delayed(Duration(milliseconds: 500), () {
      _bloc.getReviews(widget.tutor.id);
    });
  }

  void _openEditTutorDialog(Tutor tutor) {
    final _bioController = TextEditingController(text: tutor.bio ?? '');
    final _priceController = TextEditingController(text: tutor.pricePerHour?.toString() ?? '');
    final _experienceController = TextEditingController(text: tutor.experienceYears?.toString() ?? '');
    final _subjectsController = TextEditingController(text: tutor.subjects?.join(', '));
    List<ScheduleSlot> updatedAvailability = [...?tutor.availability];
    List<Certification> updatedCerts = [...?tutor.certifications];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Chỉnh sửa hồ sơ'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _bioController, decoration: InputDecoration(labelText: 'Giới thiệu')),
                TextField(controller: _subjectsController, decoration: InputDecoration(labelText: 'Môn dạy (phân cách bằng ,)')),
                TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Giá mỗi giờ')),
                TextField(controller: _experienceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Số năm kinh nghiệm')),

                const SizedBox(height: 16),
                Text('🕒 Lịch dạy:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...updatedAvailability.map((slot) => ListTile(
                  title: Text("Thứ ${slot.weekday}: ${slot.startTime!.format(context)} - ${slot.endTime!.format(context)}"),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                    setState(() => updatedAvailability.remove(slot));
                  }),
                )),
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Thêm lịch dạy'),
                  onPressed: () async {
                    // Gợi ý: bạn có thể tạo popup chọn weekday + time
                    // Ví dụ đơn giản:
                    setState(() {
                      updatedAvailability.add(ScheduleSlot(2, TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 10, minute: 0)));
                    });
                  },
                ),

                const SizedBox(height: 16),
                Text('📜 Chứng chỉ:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...updatedCerts.map((cert) => ListTile(
                  title: Text("${cert.title} (${FormatUtils.formatDate(cert.issuedAt.toLocal())})"),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                    setState(() => updatedCerts.remove(cert));
                  }),
                )),
                TextButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Thêm chứng chỉ'),
                  onPressed: () {
                    setState(() {
                      updatedCerts.add(Certification("Chứng chỉ mới", "https://link", DateTime.now()));
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                // Gọi bloc/callback cập nhật
                final updatedTutor = tutor.copyWith(
                  bio: _bioController.text,
                  subjects: _subjectsController.text.split(',').map((s) => s.trim()).toList(),
                  experienceYears: int.tryParse(_experienceController.text),
                  pricePerHour: int.tryParse(_priceController.text),
                  availability: updatedAvailability,
                  certifications: updatedCerts,
                );
                // TODO: Gọi bloc để cập nhật tutor
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thành công')));
              },
              child: Text('Lưu'),
            )
          ],
        ),
      ),
    );
  }


}
