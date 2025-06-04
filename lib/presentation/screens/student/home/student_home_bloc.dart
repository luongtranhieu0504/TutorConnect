import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/async_state.dart';
import 'package:tutorconnect/common/stream_wrapper.dart';
import 'package:tutorconnect/domain/repository/student_home_repository.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_state.dart';

@injectable
class StudentHomeBloc extends Cubit<StudentHomeState> {
  final StudentHomeRepository _studentHomeRepository;
  final updateBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  StudentHomeBloc(this._studentHomeRepository) : super(Initial());

  Future<void> getStudentById(int id) async {
    emit(Loading());
    final result = await _studentHomeRepository.getStudentById(id);
    result.when(
      success: (student) {
        emit(Success(student!));
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
        emit(Success(student!));
      },
      failure: (error) {
        updateBroadcast.add(AsyncState.failure(error.toString()));
        emit(Failure(error.toString()));
      },
    );
  }
  Future<void> getCurrentStudent() async {
    emit(Loading());
    final result = await _studentHomeRepository.getCurrentStudent();
    result.when(
      success: (student) {
        emit(Success(student!));
      },
      failure: (error) {
        emit(Failure(error.toString()));
      },
    );
  }

}