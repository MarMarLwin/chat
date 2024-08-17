import 'package:chat_supabase/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/chat/presentation/chat_page.dart';

import 'not_found_screen.dart';
part 'app_router.g.dart';

enum AppRoute { register, splash, login, chat }

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      // final accessToken = await LocalStorageManager.getAccessToken();
      final currentUser = ref.read(authRepositoryProvider).getCurrentUserId();

      if (currentUser.isNotEmpty) {
        return '/chat';
      } else {
        return '/';
      }
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/chat',
        name: AppRoute.chat.name,
        builder: (context, state) => const ChatPage(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
