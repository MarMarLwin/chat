import 'package:chat_supabase/common_widget/empty_placeholder_widget.dart';
import 'package:chat_supabase/features/chat/state/profile_notifier.dart';
import 'package:chat_supabase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/profile.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    required this.profileId,
  });
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: FutureBuilder(
            future: profileNotifier.getProfile(profileId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final profile = snapshot.data as Profile;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(profile.username.substring(0, 2),
                                style:
                                    Theme.of(context).textTheme.headlineLarge)),
                      ),
                      10.height,
                      Text(
                        profile.username,
                      ).bold()
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              }
              return const EmptyPlaceholderWidget(message: 'No Data');
            }),
      ),
    );
  }
}
