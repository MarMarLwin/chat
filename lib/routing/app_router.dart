import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/chat/presentation/chat_page.dart';

import '../features/chat/presentation/profile_page.dart';
import 'not_found_screen.dart';
part 'app_router.g.dart';

enum AppRoute { register, login, chat, profile }

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    // redirect: (context, state) async {
    //   // final accessToken = await LocalStorageManager.getAccessToken();
    //   final currentUser = ref.read(authRepositoryProvider).getCurrentUserId();

    //   if (currentUser.isNotEmpty) {
    //     return '/chat';
    //   } else {
    //     return '/';
    //   }
    // },
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
          routes: const []),
      GoRoute(
          path: '/profile/:profileId',
          name: AppRoute.profile.name,
          builder: (context, state) {
            final id = state.pathParameters['profileId']!;

            return ProfilePage(
              profileId: id,
            );
          })
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
