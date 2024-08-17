import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/user_manager.dart';
import '../data/auth_repository.dart';

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier({required this.authRepository})
      : super(const AsyncValue<void>.data(null));

  final AuthRepository authRepository;

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncValue<void>.loading();
    LocalStorageManager.clearTokens();
    try {
      state = await AsyncValue.guard(
          () => authRepository.signIn(email: email, password: password));
    } catch (error, st) {
      state = AsyncValue<void>.error(error, st);
    }
    return state.hasError == false;
  }

  Future<bool> signUp({required String email, required String password}) async {
    state = const AsyncValue<void>.loading();
    LocalStorageManager.clearTokens();
    try {
      state = await AsyncValue.guard(
          () => authRepository.signUp(email: email, password: password));
    } catch (error, st) {
      state = AsyncValue<void>.error(error, st);
    }

    return state.hasError == false;
  }

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    try {
      state = await AsyncValue.guard(() => authRepository.logout());
    } catch (e, st) {
      state = state = AsyncValue<void>.error(e, st);
    }
    return state.hasError == false;
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthNotifier(authRepository: authRepository);
});
