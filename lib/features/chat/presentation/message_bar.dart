import 'package:chat_supabase/features/chat/state/chat_notifier.dart';
import 'package:chat_supabase/features/chat/state/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_supabase/common_widget/primary_button.dart';
import 'package:chat_supabase/features/chat/presentation/typing_indicator.dart';
import '../../auth/domain/profile.dart';

class MessageBar extends ConsumerStatefulWidget {
  const MessageBar({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageBarState();
}

class _MessageBarState extends ConsumerState<MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider.notifier);
    final chatState = ref.read(chatNotifierProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<List<Profile>>(
            stream: profileState.profiles,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final data = snapshot.data;

                final users = data!
                    .map(
                      (e) => e.username.substring(0, 2),
                    )
                    .join(',');
                return TypingIndicator(
                  name: users,
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        Material(
          color: Colors.grey[200],
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      autofocus: true,
                      controller: _textController,
                      onChanged: (value) => chatState.updateTypingStatus(true),
                      onTapOutside: (event) =>
                          chatState.updateTypingStatus(false),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    onPressed: () => _submitMessage(),
                    text: 'Send',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;

    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      final chatController = ref.read(chatNotifierProvider.notifier);
      chatController.sentMessage(message: text);
      chatController.updateTypingStatus(false);
    } on PostgrestException catch (error) {
      debugPrint('error =>$error');
      // context.showErrorSnackBar(message: error.message);
    } catch (_) {
      debugPrint('error =>$_');
      // context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}
