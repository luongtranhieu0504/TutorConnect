import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/common/utils/number_formatter.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/data/models/reviews.dart';
import 'package:tutorconnect/data/models/users.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_bloc.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_state.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/tutor.dart';

class TutorProfileScreen extends StatefulWidget {
  final UserModel tutor;
  final bool isCurrentUser;
  const TutorProfileScreen({super.key, required this.tutor, required this.isCurrentUser});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  final _bloc = getIt<TutorProfileBloc>();
  int _currentIndex = 0;
  late int _rating = 5;
  final _comment = TextEditingController();
  final Map<int, Widget> tabs = const <int, Widget>{
    0: Text('Info') ,
    1: Text('Reviews'),
  };
  final user = Account.instance.user;
  late bool? _isFavorite = user.studentProfile?.favorites.contains(widget.tutor.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getTutorProfile(widget.tutor.uid);
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
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder <TutorProfileBloc, TutorProfileState>(
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
  Widget _buildContent(List<ReviewModel> reviews) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ gia sư'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.tutor.photoUrl ?? ''),
                ),
                SizedBox(height: 20),
                Text(
                  widget.tutor.name ?? '',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  widget.tutor.email ?? '',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _isFavorite = !_isFavorite!);
                            _bloc.addFavoriteTutor(studentId: user.uid, tutorId: widget.tutor.uid);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFavorite! ?  AppColors.color500 : AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: _isFavorite! ? Icon(Icons.favorite, color: Colors.white,) : Icon(Icons.favorite_border , color: Colors.white,),
                          label: Text('Yêu thích',
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

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(Icons.chat, color: Colors.white,),
                          label: Text('Nhắn tin',
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
                SizedBox(height: 20),
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
              unselectedColor: isDarkMode ? AppColors.color900 : AppColors.color100,
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
          _buildInfoRow(Icons.school, 'Môn dạy: ${widget.tutor.tutorProfile?.subjects.join(', ')}'),
          _buildInfoRow(Icons.location_on, 'Khu vực: ${widget.tutor.address}'),
          _buildInfoRow(Icons.attach_money, 'Giá dạy: ${NumberFormatter.formatCurrency(widget.tutor.tutorProfile!.pricePerHour)}VND/h'),
          _buildInfoRow(Icons.calendar_today, 'Kinh nghiệm: ${widget.tutor.tutorProfile?.experienceYears} năm'),
          SizedBox(height: 16),
          buildAvailability(widget.tutor.tutorProfile!.availability),
          SizedBox(height: 16),
          Text(
            'Giới thiệu:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            widget.tutor.tutorProfile?.bio ?? '',
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
          buildCertifications(widget.tutor.tutorProfile!.certifications),
          SizedBox(height: 8),
          Text(
            '• Cử nhân Sư phạm Toán',
            style: AppTextStyles(context).bodyText2.copyWith(
                  color: AppColors.color700,
                ),
          ),
          Text(
            '• Chứng chỉ giảng dạy Online',
            style: AppTextStyles(context).bodyText2.copyWith(
                  color: AppColors.color700,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildAvailability(List<Availability> availability) {
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
              Text("• ${a.dayOfWeek}: ${a.timeSlots.join(', ')}"),
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
              Text("• ${c.title} (${c.issuedAt})"),
              ElevatedButton(
                onPressed: () => openPdfUrl(c.fileUrl),
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

  Widget _buildReviewsTab(List<ReviewModel> reviews) {
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

  Widget _buildReview(List<ReviewModel> reviews) {
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
          review.rating,
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
                    '- ${review.studentName} (${FormatUtils.formatDate(review.date)})',
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
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
              TextField(
                decoration: InputDecoration(labelText: 'Nhận xét'),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 32,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
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
      tutorId: widget.tutor.uid,
      studentId: user.uid,
      studentName: user.name ?? '',
      rating: _rating.toDouble(),
      comment: _comment.text,
    );
    Future.delayed(Duration(milliseconds: 500), () {
      _bloc.getTutorProfile(widget.tutor.uid);
    });

  }



}
