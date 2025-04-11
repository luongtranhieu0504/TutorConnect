import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Khởi tạo Firebase
  await Firebase.initializeApp();

  // Đọc file JSON từ assets (đặt file vào thư mục assets/)
  final jsonString = await rootBundle.loadString('assets/data/firestore_tutor_seed.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final List<dynamic> tutors = jsonData['tutors'];

  final firestore = FirebaseFirestore.instance;

  for (var tutor in tutors) {
    final docId = tutor['document_id'];
    final data = tutor['data'];

    try {
      await firestore.collection('users').doc(docId).set(data);
      print('✅ Imported: $docId');
    } catch (e) {
      print('❌ Failed to import $docId: $e');
    }
  }

  print('🎉 Import hoàn tất!');
}
