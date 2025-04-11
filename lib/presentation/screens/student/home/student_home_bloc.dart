import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_state.dart';
import '../../../../domain/repository/student_home_repository.dart';

@injectable
class StudentHomeBloc extends Cubit<StudentHomeState> {
  final StudentHomeRepository _studentHomeRepository;

  StudentHomeBloc(this._studentHomeRepository) : super(UserInitial());

  void getData(String studentId) async {
    emit(UserLoading());
    final result = await _studentHomeRepository.getStudentById(studentId);
    result.when(
      success: (user) => emit(UserSuccess(user!)),
      failure: (message) => emit(UserFailure(message)),
    );
  }

}