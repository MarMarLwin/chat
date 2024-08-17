import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/user_manager.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository();

  Future<void> signUp({required String email, required String password}) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      LocalStorageManager.savePreferenceData(
          AppConstant.accessToken, response.session!.accessToken);
    } on AuthException catch (error) {
      throw (error.message);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    LocalStorageManager.clearTokens();
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      // update online status
      await updateStatus('ONLINE', response.user!.id);

      LocalStorageManager.savePreferenceData(
          AppConstant.accessToken, response.session!.accessToken);
    } on AuthException catch (error) {
      throw (error.message);
    }
  }

  Future<void> updateStatus(String status, String userId) async {
    try {
      await supabase.from('users').update({'status': status}).eq('id', userId);
    } on Exception catch (error) {
      throw (error.toString());
    }
  }

  Future<void> logout() async {
    LocalStorageManager.clearTokens();
    try {
      // update offline status
      await updateStatus('OFFLINE', supabase.auth.currentUser!.id);
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      throw (error.message);
    } catch (unexpectedErrorMessage) {
      rethrow;
    }
  }

  bool isAuthentificated() => supabase.auth.currentUser != null;

  String getCurrentUserId() =>
      isAuthentificated() ? supabase.auth.currentUser!.id : '';
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository();
