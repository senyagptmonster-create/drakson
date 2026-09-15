import 'package:flutter/material.dart';
import 'ui/grid_paper_painter.dart';
import 'state/craft_board_notifier.dart';

class DraksonApp extends StatefulWidget {
  const DraksonApp({super.key});

  @override
  State<DraksonApp> createState() => _DraksonAppState();
}

class _DraksonAppState extends State<DraksonApp> {
  final _notifier = CraftBoardNotifier();
  final _inputCtrl = TextEditingController();
  Color _selectedColor = const Color(0xFFFFD166);

  @override
  void dispose() {
    _notifier.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drakson Craft Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'AppFont',
        scaffoldBackgroundColor: const Color(0xFFFAF0CA),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drakson Craft Studio', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D3B66))),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // Architectural grid canvas
            Positioned.fill(
              child: CustomPaint(painter: GridPaperPainter()),
            ),
            // Floating sticky notes on the canvas
            ValueListenableBuilder<List<CraftNote>>(
              valueListenable: _notifier,
              builder: (context, notes, _) {
                return Stack(
                  children: notes.map((note) {
                    return Positioned(
                      left: note.x,
                      top: note.y,
                      child: Container(
                        width: 170,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: note.color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.push_pin, size: 16, color: Colors.black54),
                                GestureDetector(
                                  onTap: () => _notifier.removeNote(note.id),
                                  child: const Icon(Icons.close, size: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(note.text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            // Draggable Bottom Sheet with toolkit & swatches
            DraggableScrollableSheet(
              initialChildSize: 0.28,
              minChildSize: 0.15,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Craft Workbench & Swatches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _inputCtrl,
                        decoration: const InputDecoration(
                          hintText: 'New idea or blueprint note...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Color: '),
                          ...[
                            const Color(0xFFFFD166),
                            const Color(0xFF06D6A0),
                            const Color(0xFF118AB2),
                            const Color(0xFFEF476F),
                          ].map((c) => GestureDetector(
                                onTap: () => setState(() => _selectedColor = c),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _selectedColor == c ? Colors.black : Colors.transparent, width: 2),
                                  ),
                                ),
                              )),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              if (_inputCtrl.text.isNotEmpty) {
                                _notifier.addNote(_inputCtrl.text, _selectedColor);
                                _inputCtrl.clear();
                              }
                            },
                            child: const Text('Pin Note'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
