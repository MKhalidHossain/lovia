import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/chat/data/models/chat_message_model.dart';
import 'package:lovia/features/chat/data/models/conversation_model.dart';

abstract interface class ChatLocalDataSource {
  ConversationModel getConversation(String characterId, String characterName);
  List<ConversationModel> getConversations();
  ConversationModel append(
    String characterId,
    String characterName,
    ChatMessageModel message,
  );

  ChatMessageModel buildReply(String userText);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl(this._box);
  final GetStorage _box;

  static const List<String> _templates = [
    "That's lovely to hear. Tell me more?",
    'Mmm, I was just thinking about you. What else is on your mind?',
    'You always know how to make me smile. Go on.',
    "I'm right here with you. How are you feeling about it?",
    'Ooh, I like where this is going. And then?',
    'That sounds wonderful. I wish I could see your face right now.',
    "Honestly? You're my favorite part of the day.",
    'I could listen to you all night. What happened next?',
  ];

  @override
  ConversationModel getConversation(String characterId, String characterName) {
    final map = _readMap();
    final existing = map[characterId];
    if (existing != null) return existing;
    return ConversationModel(
      characterId: characterId,
      characterName: characterName,
      messages: const [],
    );
  }

  @override
  List<ConversationModel> getConversations() {
    final list = _readMap().values.toList()
      ..sort((a, b) {
        final am = a.messages.isEmpty ? 0 : a.messages.last.sentAtMs;
        final bm = b.messages.isEmpty ? 0 : b.messages.last.sentAtMs;
        return bm.compareTo(am);
      });
    return list.where((c) => c.messages.isNotEmpty).toList();
  }

  @override
  ConversationModel append(
    String characterId,
    String characterName,
    ChatMessageModel message,
  ) {
    final map = _readMap();
    final current = map[characterId] ??
        ConversationModel(
          characterId: characterId,
          characterName: characterName,
          messages: const [],
        );
    final updated = ConversationModel(
      characterId: characterId,
      characterName: characterName,
      messages: [...current.messages, message],
    );
    map[characterId] = updated;
    _writeMap(map);
    return updated;
  }

  @override
  ChatMessageModel buildReply(String userText) {
    final index = userText.trim().isEmpty
        ? 0
        : userText.hashCode.abs() % _templates.length;
    final now = DateTime.now();
    return ChatMessageModel(
      id: 'r-${now.microsecondsSinceEpoch}',
      text: _templates[index],
      isUser: false,
      sentAtMs: now.millisecondsSinceEpoch,
    );
  }

  Map<String, ConversationModel> _readMap() {
    final raw = _box.read<String>(StorageKeys.conversations);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          ConversationModel.fromJson(value as Map<String, dynamic>),
        ),
      );
    } on Object {
      return {};
    }
  }

  void _writeMap(Map<String, ConversationModel> map) {
    try {
      final encoded =
          jsonEncode(map.map((key, value) => MapEntry(key, value.toJson())));
      _box.write(StorageKeys.conversations, encoded);
    } on Object catch (e) {
      throw CacheException('Failed to persist conversation: $e');
    }
  }
}
