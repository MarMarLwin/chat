import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_supabase/features/chat/data/chat_repository.dart';

import '../domain/chat.dart';

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  ChatNotifier(
    this.chatRepository,
  ) : super(const AsyncValue<void>.data(null));

  final ChatRepository chatRepository;
  Stream<List<Message>> messagesStream = const Stream.empty();

  Future<void> sentMessage({required message}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => chatRepository.sent(message: message));
  }

  Future<void> syncMessages() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      messagesStream = await chatRepository.syncMessage();
    });
  }

  Future<void> updateTypingStatus(bool status) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await chatRepository.updateTypingStatus(status);
    });
  }
}

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);

  return ChatNotifier(repository);
});
