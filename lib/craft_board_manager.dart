import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanvasNote {
  final String id;
  String title;
  String body;
  int colorValue;
  DateTime createdAt;

  CanvasNote({
    required this.id,
    required this.title,
    required this.body,
    required this.colorValue,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'colorValue': colorValue,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CanvasNote.fromJson(Map<String, dynamic> map) => CanvasNote(
    id: map['id'] as String,
    title: map['title'] as String,
    body: map['body'] as String,
    colorValue: map['colorValue'] as int? ?? 0xFFFFF7ED,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}

class ColorSwatchItem {
  final String id;
  final String name;
  final int colorValue;

  ColorSwatchItem({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorValue': colorValue,
  };

  factory ColorSwatchItem.fromJson(Map<String, dynamic> map) => ColorSwatchItem(
    id: map['id'] as String,
    name: map['name'] as String,
    colorValue: map['colorValue'] as int,
  );
}

class CraftBoardManager extends ChangeNotifier {
  static const _notesKey = 'drakson_active_notes_v2';
  static const _archiveKey = 'drakson_archived_notes_v2';
  static const _swatchesKey = 'drakson_swatches_v2';
  static const _ideasKey = 'drakson_ideas_v2';

  final List<CanvasNote> _notes = [];
  final List<CanvasNote> _archivedNotes = [];
  final List<ColorSwatchItem> _swatches = [];
  final List<String> _ideas = [];

  List<CanvasNote> get notes => List.unmodifiable(_notes);
  List<CanvasNote> get archivedNotes => List.unmodifiable(_archivedNotes);
  List<ColorSwatchItem> get swatches => List.unmodifiable(_swatches);
  List<String> get ideas => List.unmodifiable(_ideas);

  CraftBoardManager() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final notesData = prefs.getString(_notesKey);
    if (notesData != null) {
      final List dec = jsonDecode(notesData);
      _notes.clear();
      _notes.addAll(dec.map((e) => CanvasNote.fromJson(e)));
    } else {
      _notes.addAll([
        CanvasNote(
          id: '1',
          title: 'Brand Palette Draft',
          body: 'Warm ochre background with radiant terracotta accent blocks.',
          colorValue: 0xFFFFEDD5,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CanvasNote(
          id: '2',
          title: 'Layout Prototype',
          body: 'Asymmetric grid system with subtle off-white borders.',
          colorValue: 0xFFFEF3C7,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ]);
    }

    final archiveData = prefs.getString(_archiveKey);
    if (archiveData != null) {
      final List dec = jsonDecode(archiveData);
      _archivedNotes.clear();
      _archivedNotes.addAll(dec.map((e) => CanvasNote.fromJson(e)));
    }

    final swatchesData = prefs.getString(_swatchesKey);
    if (swatchesData != null) {
      final List dec = jsonDecode(swatchesData);
      _swatches.clear();
      _swatches.addAll(dec.map((e) => ColorSwatchItem.fromJson(e)));
    } else {
      _swatches.addAll([
        ColorSwatchItem(id: 's1', name: 'Terracotta Core', colorValue: 0xFFEA580C),
        ColorSwatchItem(id: 's2', name: 'Desert Amber', colorValue: 0xFFD97706),
        ColorSwatchItem(id: 's3', name: 'Soft Linen', colorValue: 0xFFFFFDF9),
        ColorSwatchItem(id: 's4', name: 'Warm Charcoal', colorValue: 0xFF291804),
      ]);
    }

    final ideasData = prefs.getStringList(_ideasKey);
    if (ideasData != null) {
      _ideas.clear();
      _ideas.addAll(ideasData);
    } else {
      _ideas.addAll([
        'Harmonize negative space',
        'Add parchment texture overlay',
        'Experiment with monospaced typography captions',
      ]);
    }

    notifyListeners();
  }

  Future<void> _persistNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, jsonEncode(_notes.map((e) => e.toJson()).toList()));
  }

  Future<void> _persistArchive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_archiveKey, jsonEncode(_archivedNotes.map((e) => e.toJson()).toList()));
  }

  Future<void> _persistSwatches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_swatchesKey, jsonEncode(_swatches.map((e) => e.toJson()).toList()));
  }

  Future<void> _persistIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_ideasKey, _ideas);
  }

  void addNote(String title, String body, int colorValue) {
    _notes.insert(0, CanvasNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    ));
    _persistNotes();
    notifyListeners();
  }

  void archiveNote(String id) {
    final idx = _notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final item = _notes.removeAt(idx);
      _archivedNotes.insert(0, item);
      _persistNotes();
      _persistArchive();
      notifyListeners();
    }
  }

  void restoreNote(String id) {
    final idx = _archivedNotes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final item = _archivedNotes.removeAt(idx);
      _notes.insert(0, item);
      _persistNotes();
      _persistArchive();
      notifyListeners();
    }
  }

  void permanentlyDeleteArchive(String id) {
    _archivedNotes.removeWhere((n) => n.id == id);
    _persistArchive();
    notifyListeners();
  }

  void clearArchive() {
    _archivedNotes.clear();
    _persistArchive();
    notifyListeners();
  }

  void addSwatch(String name, int colorValue) {
    _swatches.add(ColorSwatchItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      colorValue: colorValue,
    ));
    _persistSwatches();
    notifyListeners();
  }

  void deleteSwatch(String id) {
    _swatches.removeWhere((s) => s.id == id);
    _persistSwatches();
    notifyListeners();
  }

  void addIdea(String idea) {
    if (idea.trim().isNotEmpty) {
      _ideas.insert(0, idea.trim());
      _persistIdeas();
      notifyListeners();
    }
  }

  void removeIdea(int index) {
    if (index >= 0 && index < _ideas.length) {
      _ideas.removeAt(index);
      _persistIdeas();
      notifyListeners();
    }
  }
}
