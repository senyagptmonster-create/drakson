import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../app/brand.dart';

class DraksonHome extends StatefulWidget {
  const DraksonHome({super.key});
  @override
  State<DraksonHome> createState() => _DraksonHomeState();
}

class _DraksonHomeState extends State<DraksonHome> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          CanvasScreen(),
          MoodSwatchesScreen(),
          IdeaIncubatorScreen(),
          ArchiveScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
        selectedItemColor: cAccent,
        unselectedItemColor: cInk.withValues(alpha: 0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Canvas'),
          BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Moods'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Ideas'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive'),
        ],
      ),
    );
  }
}

class CanvasScreen extends StatelessWidget {
  const CanvasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: cBg,
      child: Center(child: Text('Canvas Notes', style: AppTheme.display())),
    );
  }
}

class MoodSwatchesScreen extends StatelessWidget {
  const MoodSwatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: cSurface,
      child: Center(child: Text('Mood Swatches', style: AppTheme.display())),
    );
  }
}

class IdeaIncubatorScreen extends StatelessWidget {
  const IdeaIncubatorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: cBg,
      child: Center(child: Text('Idea Incubator', style: AppTheme.display())),
    );
  }
}

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: cSurface,
      child: Center(child: Text('Archive', style: AppTheme.display())),
    );
  }
}
