import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A single chat message.
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime createdAt;
  ChatMessage({required this.text, required this.isUser, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}

/// Provider-scoped chat state for a given package.
class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final String _packageId;

  ChatNotifier(this._packageId) : super([]);

  Future<void> sendMessage(String text) async {
    state = [...state, ChatMessage(text: text, isUser: true)];

    try {
      final supabase = Supabase.instance.client;
      final res = await supabase.functions.invoke('refine-package',
        body: {'package_id': _packageId, 'message': text});

      final reply = (res.data as Map)['reply'] as String? ?? 'Got it! I\'ll update the package.';
      state = [...state, ChatMessage(text: reply, isUser: false)];
    } catch (e) {
      state = [...state, ChatMessage(text: 'Sorry, I couldn\'t process that. Please try again.', isUser: false)];
    }
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, List<ChatMessage>, String>(
    (ref, packageId) => ChatNotifier(packageId));
