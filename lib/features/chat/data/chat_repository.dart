import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/app_constant.dart';
import '../../auth/domain/profile.dart';
import '../domain/chat.dart';
part 'chat_repository.g.dart';

class ChatRepository {
  ChatRepository();

  Future<void> sent({required String message}) async {
    try {
      final myUserId = supabase.auth.currentUser!.id;
      await supabase.from('messages').insert({
        'user_id': myUserId,
        'message': message,
        'channel_id': 1,
      });
    } on AuthException catch (error) {
      throw (error.message);
    }
  }

  Future<Stream<List<Message>>> syncMessage() async {
    try {
      final myUserId = supabase.auth.currentUser!.id;
      debugPrint('userId => $myUserId');
      final messageStream = supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .order('inserted_at')
          .map((maps) => maps
              .map((map) => Message.fromMap(map: map, myUserId: myUserId))
              .toList());
      return messageStream;
    } on Exception catch (error) {
      throw (error.toString());
    }
  }

  Future<Profile> getProfile(String profileId) async {
    try {
      final data =
          await supabase.from('users').select().eq('id', profileId).single();
      final profile = Profile.fromMap(data);

      return profile;
    } on Exception catch (error) {
      throw (error.toString());
    }
  }

  Future<Stream<List<Profile>>> getTypingProfiles() async {
    try {
      final data = supabase.from('users').stream(primaryKey: [
        'isTyping'
      ]).inFilter('isTyping', [true]).map((maps) => maps
          .map((map) => Profile.fromMap(map))
          .toList()
          .where((profile) => profile.id != supabase.auth.currentUser!.id)
          .toList());

      return data;
    } on Exception catch (error) {
      throw (error.toString());
    }
  }

  Future<void> updateTypingStatus(bool isTyping) async {
    try {
      final myUserId = supabase.auth.currentUser!.id;
      await supabase
          .from('users')
          .update({'isTyping': isTyping}).eq('id', myUserId);
    } on Exception catch (error) {
      throw (error.toString());
    }
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) => ChatRepository();
