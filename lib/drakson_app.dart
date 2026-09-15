import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drakson_palette.dart';
import 'craft_board_manager.dart';
import 'canvas_notes_view.dart';
import 'mood_swatches_view.dart';
import 'idea_incubator_view.dart';
import 'board_archive_view.dart';

class DraksonApp extends StatelessWidget {
  const DraksonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CraftBoardManager(),
      child: MaterialApp(
        title: 'Drakson Craft Board',
        debugShowCheckedModeBanner: false,
        theme: DraksonPalette.theme,
        home: const _DraksonShell(),
      ),
    );
  }
}

class _DraksonShell extends StatefulWidget {
  const _DraksonShell();

  @override
  State<_DraksonShell> createState() => _DraksonShellState();
}

class _DraksonShellState extends State<_DraksonShell> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    CanvasNotesView(),
    MoodSwatchesView(),
    IdeaIncubatorView(),
    BoardArchiveView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Canvas',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'Swatches',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Incubator',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(Icons.archive),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}
