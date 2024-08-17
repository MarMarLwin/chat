import 'package:chat_supabase/common_widget/empty_placeholder_widget.dart';
import 'package:chat_supabase/features/auth/state/auth_notifier.dart';
import 'package:chat_supabase/features/chat/state/chat_notifier.dart';
import 'package:chat_supabase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widget/alert_dialogs.dart';
import '../../../routing/app_router.dart';
import '../../../utils/app_constant.dart';
import '../domain/chat.dart';
import 'chat_bubble.dart';
import 'message_bar.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChartPageState();
}

class _ChartPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.read(chatNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          actions: [
            GestureDetector(
                onTap: () {
                  ConfirmDialog.show(
                      context: context,
                      title: 'Confirmation',
                      content: 'Are you sure want to logout?',
                      leftTitleButton: 'Ok',
                      onPressedOk: () async {
                        final authNotifier =
                            ref.read(authNotifierProvider.notifier);
                        final success = await authNotifier.logout();
                        if (success && mounted) {
                          context.replaceNamed(AppRoute.login.name);
                        }
                      });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.power_settings_new_rounded),
                ))
          ],
        ),
        body: StreamBuilder<List<Message>>(
          stream: state.messagesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasData) {
              final messages = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: const Text(AppLabels.startConversation)
                                .titleMedium(context),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];

                              return ChatBubble(
                                message: message,
                              );
                            },
                          ),
                  ),
                  const MessageBar()
                ],
              );
            } else {
              return const Center(
                  child: EmptyPlaceholderWidget(message: 'No Data'));
            }
          },
        ));
  }
}
