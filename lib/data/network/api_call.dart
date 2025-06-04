import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../common/task_result.dart';
import 'dto/response_dto.dart';

final _logger = Logger();

Future<TaskResult<T>> callApi<T>(
    Future<T> Function() block,
    ) async {
  try {
    final data = await block();
    return TaskResult.success(data);
  } on DioException catch (e) {
    final String message;
    switch (e.type) {
      case DioExceptionType.badResponse:
        try {
          final data = e.response!.data!;
          final responseDto = ResponseDto.fromJson(data, (_) => null);
          message = responseDto.message ?? e.message ?? e.toString();
        } catch (e) {
          return TaskResult.failure(e.toString());
        }
        break;
      default:
        message = e.message ?? e.toString();
    }
    return TaskResult.failure(message);
  } catch (e) {
    _logger.e(e);
    return TaskResult.failure(e.toString());
  }
}
