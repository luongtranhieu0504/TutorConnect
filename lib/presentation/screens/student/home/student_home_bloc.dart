import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/async_state.dart';
import 'package:tutorconnect/common/stream_wrapper.dart';
import 'package:tutorconnect/domain/repository/student_home_repository.dart';
import 'package:tutorconnect/domain/repository/tutor_repository.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_state.dart';

import '../../../../domain/model/tutor.dart';

@injectable
class StudentHomeBloc extends Cubit<StudentHomeState> {
  final StudentHomeRepository _studentHomeRepository;
  final TutorRepository _tutorRepository;
  final updateBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final streamTutorsBySubject = StreamWrapper<AsyncState<List<Tutor>>>(broadcast: true);
  StudentHomeBloc(this._studentHomeRepository, this._tutorRepository) : super(Initial());


  Future<void> loadInitialData() async {
    emit(Loading());
    final studentResult = await _studentHomeRepository.getCurrentStudent();
    final tutorResult = await _tutorRepository.getTutorsList(topRated: true);

    studentResult.when(
      success: (student) {
        tutorResult.when(
          success: (tutors) {
            emit(Success(student!, tutors));
          },
          failure: (error) {
            emit(Failure(error.toString()));
          },
        );
      },
      failure: (error) {
        emit(Failure(error.toString()));
      },
    );
  }


  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    updateBroadcast.add(AsyncState.loading());
    final result = await _studentHomeRepository.updateStudent(id, data);
    result.when(
      success: (student) {
        updateBroadcast.add(AsyncState.success(true));
        loadInitialData();
      },
      failure: (error) {
        updateBroadcast.add(AsyncState.failure(error.toString()));
      },
    );
  }

  Future<void> getTutorsBySubject(String subject) async {
    streamTutorsBySubject.add(AsyncState.loading());
    final tutorResult = await _tutorRepository.getTutorsList(subject: subject);

    tutorResult.when(
      success: (tutors) {
        if (state is Success) {
          streamTutorsBySubject.add(
            AsyncState.success(tutors));
        }
      },
      failure: (error) {
        streamTutorsBySubject.add(AsyncState.failure(error.toString()));
      },
    );
  }




}