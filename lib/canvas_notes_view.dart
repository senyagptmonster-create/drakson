import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'craft_board_manager.dart';
import 'drakson_palette.dart';

class CanvasNotesView extends StatelessWidget {
  const CanvasNotesView({super.key});

  static const List<int> _presetColors = [
    0xFFFFEDD5,
    0xFFFEF3C7,
    0xFFDCFCE7,
    0xFFE0E7FF,
    0xFFFCE7F3,
    0xFFF3F4F6,
  ];

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    int selectedColor = _presetColors.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DraksonPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Draft Canvas Note',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DraksonPalette.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Note Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Idea, sketch details, or visual notes...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Card Tint',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _presetColors.map((col) {
                      final isSel = col == selectedColor;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColor = col),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Color(col),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? DraksonPalette.accent : Colors.black12,
                              width: isSel ? 2.5 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DraksonPalette.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isNotEmpty) {
                          context.read<CraftBoardManager>().addNote(
                            titleController.text.trim(),
                            bodyController.text.trim(),
                            selectedColor,
                          );
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text('Add to Canvas'),
                    ),
                  ),
                ],
              ),
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
        title: const Text('Canvas Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: DraksonPalette.accent),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: manager.notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.draw_outlined, size: 64, color: DraksonPalette.inkMuted.withAlpha(100)),
                  const SizedBox(height: 12),
                  const Text(
                    'No notes drafted yet',
                    style: TextStyle(fontSize: 16, color: DraksonPalette.inkMuted),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: manager.notes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final note = manager.notes[idx];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(note.colorValue),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: DraksonPalette.edge),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: DraksonPalette.ink,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.archive_outlined, size: 20, color: DraksonPalette.inkMuted),
                            onPressed: () => manager.archiveNote(note.id),
                            tooltip: 'Archive Note',
                          ),
                        ],
                      ),
                      if (note.body.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          note.body,
                          style: const TextStyle(fontSize: 14, color: DraksonPalette.ink),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: DraksonPalette.accent,
        foregroundColor: Colors.white,
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.edit_note),
        label: const Text('New Note'),
      ),
    );
  }
}
