import 'package:flutter/material.dart';

class CraftNote {
  final String id;
  final String text;
  final Color color;
  final double x;
  final double y;

  CraftNote({
    required this.id,
    required this.text,
    required this.color,
    required this.x,
    required this.y,
  });
}

class CraftBoardNotifier extends ValueNotifier<List<CraftNote>> {
  CraftBoardNotifier()
      : super([
          CraftNote(
            id: 'n1',
            text: 'Blueprint Schema: Multi-tier microservices architecture',
            color: const Color(0xFFFFD166),
            x: 40,
            y: 60,
          ),
          CraftNote(
            id: 'n2',
            text: 'Color palette: Terracotta & Raw Umber finish',
            color: const Color(0xFF06D6A0),
            x: 180,
            y: 220,
          ),
        ]);

  void addNote(String text, Color color) {
    value = [
      ...value,
      CraftNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        color: color,
        x: 60,
        y: 120,
      ),
    ];
  }

  void removeNote(String id) {
    value = value.where((n) => n.id != id).toList();
  }
}
