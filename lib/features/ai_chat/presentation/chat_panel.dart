import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import 'chat_provider.dart';

/// C.10 AI Chat Panel — bottom sheet overlay for package refinement.
class ChatPanel extends ConsumerStatefulWidget {
  final String packageId;
  const ChatPanel({super.key, required this.packageId});

  @override
  ConsumerState<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends ConsumerState<ChatPanel> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider(widget.packageId).notifier).sendMessage(text);
    _inputCtrl.clear();
    // scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider(widget.packageId));
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: colors.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('Refine your package',
                style: theme.textTheme.headlineLarge),
          ),
          const Divider(height: 1),
          // messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? colors.brandPrimary : colors.bgSurface,
                      borderRadius: BorderRadius.circular(12).copyWith(
                        bottomRight: msg.isUser ? Radius.zero : const Radius.circular(12),
                        bottomLeft: msg.isUser ? const Radius.circular(12) : Radius.zero,
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Text(msg.text,
                        style: TextStyle(
                          color: msg.isUser ? Colors.white : colors.textPrimary,
                        )),
                  ),
                );
              },
            ),
          ),
          // suggestions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _chip('Make it cheaper', colors),
                _chip('Earlier departure', colors),
                _chip('Better hotel', colors),
              ]),
            ),
          ),
          // input
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _inputCtrl,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.send, size: 20),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, TripSyncColors colors) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ActionChip(
      label: Text(label),
      onPressed: () {
        ref.read(chatProvider(widget.packageId).notifier).sendMessage(label);
      },
    ),
  );
}
