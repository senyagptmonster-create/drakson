import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'craft_board_manager.dart';
import 'drakson_palette.dart';

class MoodSwatchesView extends StatelessWidget {
  const MoodSwatchesView({super.key});

  void _showAddSwatch(BuildContext context) {
    final nameCtrl = TextEditingController();
    int chosenColor = 0xFF3B82F6;

    final presets = [
      0xFFEF4444, 0xFFF97316, 0xFFF59E0B, 0xFF10B981,
      0xFF06B6D4, 0xFF3B82F6, 0xFF8B5CF6, 0xFFEC4899,
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: DraksonPalette.surface,
              title: const Text('Add Color Swatch'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Swatch Name (e.g. Cobalt Sky)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: presets.map((c) {
                      final isSel = c == chosenColor;
                      return GestureDetector(
                        onTap: () => setDialogState(() => chosenColor = c),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(c),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? Colors.black : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
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
                    if (nameCtrl.text.trim().isNotEmpty) {
                      context.read<CraftBoardManager>().addSwatch(
                        nameCtrl.text.trim(),
                        chosenColor,
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save Swatch'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<CraftBoardManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Swatches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSwatch(context),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: manager.swatches.length,
        itemBuilder: (context, idx) {
          final sw = manager.swatches[idx];
          final hex = '#${sw.colorValue.toRadixString(16).substring(2).toUpperCase()}';
          return Container(
            decoration: BoxDecoration(
              color: DraksonPalette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DraksonPalette.edge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(sw.colorValue),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sw.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              hex,
                              style: const TextStyle(fontSize: 11, color: DraksonPalette.inkMuted),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: DraksonPalette.inkMuted),
                        onPressed: () => manager.deleteSwatch(sw.id),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
