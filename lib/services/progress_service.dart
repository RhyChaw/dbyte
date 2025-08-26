import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService extends ChangeNotifier {
  int _xp = 0;
  int _hearts = 5;
  int _streak = 0;
  DateTime? _lastSessionDate;

  int get xp => _xp;
  int get hearts => _hearts;
  int get streak => _streak;

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('xp') ?? 0;
    _hearts = prefs.getInt('hearts') ?? 5;
    _streak = prefs.getInt('streak') ?? 0;
    final dateStr = prefs.getString('lastSessionDate');
    if (dateStr != null) {
      _lastSessionDate = DateTime.tryParse(dateStr);
    }
    notifyListeners();
  }

  Future<void> addXp(int amount) async {
    _xp += amount;
    await _save();
    notifyListeners();
  }

  Future<void> loseHeart() async {
    if (_hearts > 0) _hearts--;
    await _save();
    notifyListeners();
  }

  Future<void> restoreHearts() async {
    _hearts = 5;
    await _save();
    notifyListeners();
  }

  Future<void> completeSession() async {
    _updateStreakIfNeeded();
    _touchSessionDate();
    await _save();
    notifyListeners();
  }

  void _updateStreakIfNeeded() {
    final today = DateTime.now();
    if (_lastSessionDate == null) {
      _streak = 1;
    } else {
      final difference = today.difference(_lastSessionDate!).inDays;
      if (difference == 1) {
        _streak++;
      } else if (difference > 1) {
        _streak = 1;
      }
    }
  }

  void _touchSessionDate() {
    _lastSessionDate = DateTime.now();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    await prefs.setInt('hearts', _hearts);
    await prefs.setInt('streak', _streak);
    if (_lastSessionDate != null) {
      await prefs.setString(
        'lastSessionDate',
        _lastSessionDate!.toIso8601String(),
      );
    }
  }
}
