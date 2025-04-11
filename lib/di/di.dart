import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/di/di.config.dart';

final getIt = GetIt.instance;
@injectableInit
void configureDependencies() {
  getIt.init();
  // Register your dependencies here
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
}