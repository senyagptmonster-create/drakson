import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'craft_board_manager.dart';
import 'drakson_palette.dart';

class BoardArchiveView extends StatelessWidget {
  const BoardArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<CraftBoardManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board Archive'),
        actions: [
          if (manager.archivedNotes.isNotEmpty)
            TextButton(
              onPressed: () => manager.clearArchive(),
              child: const Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: manager.archivedNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: DraksonPalette.inkMuted.withAlpha(100)),
                  const SizedBox(height: 12),
                  const Text(
                    'No archived notes yet',
                    style: TextStyle(color: DraksonPalette.inkMuted, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: manager.archivedNotes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final note = manager.archivedNotes[idx];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: DraksonPalette.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: DraksonPalette.edge),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(note.colorValue),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            if (note.body.isNotEmpty)
                              Text(
                                note.body,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: DraksonPalette.inkMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.restore_from_trash_outlined, color: DraksonPalette.accent),
                        onPressed: () => manager.restoreNote(note.id),
                        tooltip: 'Restore',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                        onPressed: () => manager.permanentlyDeleteArchive(note.id),
                        tooltip: 'Delete permanently',
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
