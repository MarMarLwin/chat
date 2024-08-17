import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';

import 'package:chat_supabase/features/chat/state/profile_notifier.dart';

import '../../auth/domain/profile.dart';
import '../domain/chat.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: FutureBuilder(
              initialData: profileNotifier.profile,
              future: profileNotifier.getProfile(message.userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final profile = snapshot.data as Profile;
                  return Text(profile.username.substring(0, 2));
                }
                return const CircularProgressIndicator.adaptive();
              }),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.message,
            style:
                TextStyle(color: message.isMine ? Colors.white : Colors.black),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.insertedAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
