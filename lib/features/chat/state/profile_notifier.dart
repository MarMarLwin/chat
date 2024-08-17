import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_supabase/features/chat/data/chat_repository.dart';
import '../../auth/domain/profile.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  ProfileNotifier(
    this.chatRepository,
  ) : super(const AsyncValue<void>.data(null));

  final ChatRepository chatRepository;

  Stream<List<Profile>> profiles = const Stream.empty();
  Profile? profile;

  Future<void> getTypingProfiles() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      profiles = await chatRepository.getTypingProfiles();
    });
  }

  Future<Profile> getProfile(String userId) async {
    profile = await chatRepository.getProfile(userId);

    return profile!;
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);

  return ProfileNotifier(repository);
});
