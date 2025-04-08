import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  int _currentIndex = 0;
  final Map<int, Widget> tabs = const <int, Widget>{
    0: Text('Info') ,
    1: Text('Reviews'),
  };
  bool _isUserStudent = true; // Change this to false if the user is a tutor


  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
  Widget _buildContent() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
                  backgroundImage: AssetImage('assets/images/ML1.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'Tutor Name',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  'albertflores@mail.com',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                _segmentedTabInfo(),
                SizedBox(height: 20),
                IndexedStack(
                  index: _currentIndex,
                  children: [
                    // Info Tab
                    _buildInfoTab(),
                    _buildReviewsTab(),
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
          _buildInfoRow(Icons.school, 'Môn dạy: Toán, Vật lý'),
          _buildInfoRow(Icons.location_on, 'Khu vực: Q.10, Hồ Chí Minh'),
          _buildInfoRow(Icons.attach_money, 'Giá dạy: 150K - 250K/h'),
          _buildInfoRow(Icons.calendar_today, 'Kinh nghiệm: 3 năm'),
          SizedBox(height: 16),
          Text(
            'Lịch dạy cố định:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'T2: 15h-17h | T4: 18h-20h | T6: 9h-11h',
            style: AppTextStyles(context).bodyText2.copyWith(
                  color: AppColors.color700,
                ),
          ),
          SizedBox(height: 16),
          Text(
            'Giới thiệu:',
            style: AppTextStyles(context).bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Tôi là một gia sư chuyên Toán cấp 2, cấp 3...',
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

  Widget _buildReviewsTab() {
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
          _buildReview(
            rating: 4,
            name: 'Minh Trí',
            date: '12/03/2025',
            comment: 'Thầy dạy rất kỹ, dễ hiểu và đúng giờ.',
          ),
          Divider(),
          _buildReview(
            rating: 5,
            name: 'Lan Anh',
            date: '05/03/2025',
            comment: 'Phong cách giảng rõ ràng, bài tập đầy đủ.',
          ),
          Divider(),
          if (_isUserStudent)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle write review action
                },
                icon: Icon(Icons.edit),
                label: Text('VIẾT ĐÁNH GIÁ'),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildReview({required int rating, required String name, required String date, required String comment}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '⭐' * rating,
              style: TextStyle(color: Colors.amber),
            ),
            SizedBox(width: 8),
            Text(
              '- $name ($date)',
              style: AppTextStyles(context).bodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          comment,
          style: AppTextStyles(context).bodyText2,
        ),
      ],
    );
  }


}
