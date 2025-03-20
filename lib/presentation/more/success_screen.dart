import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SuccessScreen({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Hiệu ứng confetti đơn giản (có thể thay bằng animation)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/confetti.png', // Thay bằng hình ảnh hiệu ứng phù hợp
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Icon thành công
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, size: 50, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Congrats!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You have signed up successfully. Go to home & start exploring courses",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
