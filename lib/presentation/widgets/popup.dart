import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/theme/color_platte.dart';

class ThemePopupExample extends StatefulWidget {
  const ThemePopupExample({super.key});

  @override
  _ThemePopupExampleState createState() => _ThemePopupExampleState();
}

class _ThemePopupExampleState extends State<ThemePopupExample> {
  bool isDarkMode = false; // Mặc định là chế độ sáng
  Color selectedColor = AppColors.primary; // Màu chủ đề mặc định

  // Hàm mở popup
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chế độ sáng
              ListTile(
                leading: Text("🌞"),
                title: Text("Chế độ sáng"),
                trailing: Radio(
                  value: false,
                  groupValue: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = false;
                    });
                    Navigator.pop(context);
                    _showThemeDialog();
                  },
                ),
              ),

              // Chế độ tối
              ListTile(
                leading: Text("🌙"),
                title: Text("Chế độ tối"),
                trailing: Radio(
                  value: true,
                  groupValue: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = true;
                    });
                    Navigator.pop(context);
                    _showThemeDialog();
                  },
                ),
              ),
              Divider(),
              // Màu chủ đề
              ListTile(
                leading: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.rectangle,
                  ),
                ),
                title: Text("Màu chủ đề:"),
              ),

              // Chọn màu chủ đề
              Wrap(
                spacing: 10,
                children: [
                  _colorButton(Colors.blue, "Xanh dương"),
                  _colorButton(Colors.green, "Xanh lá"),
                  _colorButton(Colors.purple.shade200, "Tím nhạt"),
                ],
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                ),
                child: Text("Đóng"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget nút chọn màu
  Widget _colorButton(Color color, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
        context.pop();
        _showThemeDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(title: Text("Chọn chủ đề")),
      body: Center(
        child: GestureDetector(
          onTap: _showThemeDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.color_lens, color: Colors.black),
                SizedBox(width: 10),
                Text("Chọn chủ đề", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
