import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraksonStore extends ChangeNotifier {
  List<String> notes = [];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('drakson_data');
    if (data != null) {
      final json = jsonDecode(data);
      if (json['notes'] != null) {
        notes = List<String>.from(json['notes']);
      }
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = {'notes': notes};
    await prefs.setString('drakson_data', jsonEncode(json));
  }
}
