

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/conversation_mapper.dart';

import '../../common/task_result.dart';
import '../../domain/model/conversation.dart';
import '../../domain/repository/conversation_repository.dart';
import '../network/api_call.dart';
import '../source/conversation_network_data_source.dart';

@Singleton(as: ConversationRepository)
class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationNetworkDataSource _dataSource;

  ConversationRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<Conversation>> findOrCreateConversation(int studentId, int tutorId) async {
    return callApi(() async {
      final response = await _dataSource.findOrCreateConversation(studentId, tutorId);
      return response.data!.toModel();
    });
  }

  @override
  Future<TaskResult<List<Conversation>>> getConversations({int? studentId, int? tutorId}) async {
    return callApi(() async {
      final response = await _dataSource.getConversations(studentId: studentId, tutorId: tutorId);
      return response.data!.map((dto) => dto.toModel()).toList();
    });
  }

  @override
  Future<TaskResult<Conversation>> updateLastMessage(int conversationId, String message) async {
    return callApi(() async {
      final response = await _dataSource.updateLastMessage(conversationId, message);
      return response.data!.toModel();
    });
  }



}