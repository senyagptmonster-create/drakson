import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'craft_board_manager.dart';
import 'drakson_palette.dart';

class IdeaIncubatorView extends StatelessWidget {
  const IdeaIncubatorView({super.key});

  void _showAddIdea(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DraksonPalette.surface,
        title: const Text('Capture Flash Idea'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter concept, texture, reference...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: DraksonPalette.accent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                context.read<CraftBoardManager>().addIdea(ctrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<CraftBoardManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Incubator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Creative Seeds & Prompts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DraksonPalette.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap any bubble to dismiss or harvest the idea.',
              style: TextStyle(fontSize: 13, color: DraksonPalette.inkMuted),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(manager.ideas.length, (idx) {
                    final item = manager.ideas[idx];
                    return InputChip(
                      label: Text(item),
                      backgroundColor: DraksonPalette.surface,
                      elevation: 1,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => manager.removeIdea(idx),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: DraksonPalette.edge),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: DraksonPalette.accent,
        foregroundColor: Colors.white,
        onPressed: () => _showAddIdea(context),
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('New Idea'),
      ),
    );
  }
}
