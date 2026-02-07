import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard_model.dart';

class LocalStorageService {
  // Keys for storage
  static const String flashcardsKey = 'flashcards';
  static const String themeSettingsKey = 'theme_settings';
  static const String appSettingsKey = 'app_settings';
  static const String studyStatsKey = 'study_stats';
  static const String categoriesKey = 'categories';

  // ==================== FLASHCARD METHODS ====================

  // Save list of flashcards
  static Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert each flashcard to JSON string
    List<String> flashcardsStringList = flashcards
        .map((f) => jsonEncode(f.toJson()))
        .toList();

    await prefs.setStringList(flashcardsKey, flashcardsStringList);
  }

  // Load list of flashcards
  static Future<List<Flashcard>> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? flashcardsStringList = prefs.getStringList(flashcardsKey);

    if (flashcardsStringList == null) {
      return []; // no data yet
    }

    // Convert JSON string back to Flashcard objects
    return flashcardsStringList
        .map((f) => Flashcard.fromJson(jsonDecode(f)))
        .toList();
  }

  // Clear all flashcards
  static Future<void> clearFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(flashcardsKey);
  }

  // ==================== THEME METHODS ====================

  // Save theme settings
  static Future<void> saveThemeSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeSettingsKey, json.encode(settings));
  }

  // Load theme settings
  static Future<Map<String, dynamic>?> loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(themeSettingsKey);

    if (settingsString != null && settingsString.isNotEmpty) {
      try {
        return json.decode(settingsString) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing theme settings: $e');
        return null;
      }
    }
    return null;
  }

  // Clear theme settings
  static Future<void> clearThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(themeSettingsKey);
  }

  // ==================== APP SETTINGS METHODS ====================

  // Save app settings (sound, vibration, notifications, etc.)
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(appSettingsKey, json.encode(settings));
  }

  // Load app settings
  static Future<Map<String, dynamic>> loadAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(appSettingsKey);

    if (settingsString != null && settingsString.isNotEmpty) {
      try {
        return json.decode(settingsString) as Map<String, dynamic>;
      } catch (e) {
        debugPrint(
          'Error parsing app settings: $e',
        ); // FIXED: removed developer.
      }
    }

    // Return default settings
    return {
      'soundEnabled': true,
      'vibrationEnabled': true,
      'notificationsEnabled': true,
      'dailyReminder': true,
      'reminderTime': '20:00',
      'studyGoal': 10,
      'autoPlayAudio': false,
      'hapticsEnabled': true,
    };
  }

  // ==================== STUDY STATISTICS METHODS ====================

  // Save study statistics
  static Future<void> saveStudyStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studyStatsKey, json.encode(stats));
  }

  // Load study statistics
  static Future<Map<String, dynamic>> loadStudyStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsString = prefs.getString(studyStatsKey);

    if (statsString != null && statsString.isNotEmpty) {
      try {
        return json.decode(statsString) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Error parsing study stats: $e');
      }
    }

    // Return default/empty statistics
    return {
      'totalStudyTime': 0,
      'cardsReviewed': 0,
      'dailyStreak': 0,
      'lastStudyDate': null,
      'studyDays': [],
      'categoryStats': {},
      'weeklyGoal': 0,
      'monthlyGoal': 0,
    };
  }

  // Update study time
  static Future<void> updateStudyTime(int minutes) async {
    final stats = await loadStudyStats();
    final currentTime = stats['totalStudyTime'] ?? 0;
    stats['totalStudyTime'] = currentTime + minutes;

    // Update last study date
    final now = DateTime.now();
    stats['lastStudyDate'] = now.toIso8601String();

    // Update study days
    final studyDays = List<String>.from(stats['studyDays'] ?? []);
    final today = '${now.year}-${now.month}-${now.day}';
    if (!studyDays.contains(today)) {
      studyDays.add(today);
      stats['studyDays'] = studyDays;

      // Update streak
      stats['dailyStreak'] = _calculateStreak(studyDays);
    }

    await saveStudyStats(stats);
  }

  // Helper method to calculate streak
  static int _calculateStreak(List<String> studyDays) {
    if (studyDays.isEmpty) return 0;

    studyDays.sort((a, b) => b.compareTo(a)); // Sort descending

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final yesterdayStr =
        '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    int streak = 0;
    DateTime currentDate = today;

    // Check consecutive days
    for (int i = 0; i < studyDays.length; i++) {
      final studyDay = studyDays[i];
      final expectedDate =
          '${currentDate.year}-${currentDate.month}-${currentDate.day}';

      if (studyDay == expectedDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // ==================== CATEGORY METHODS ====================

  // Save custom categories
  static Future<void> saveCustomCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(categoriesKey, categories);
  }

  // Load custom categories
  static Future<List<String>> loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(categoriesKey) ?? [];
  }

  // Add custom category
  static Future<void> addCustomCategory(String category) async {
    final categories = await loadCustomCategories();
    if (!categories.contains(category)) {
      categories.add(category);
      await saveCustomCategories(categories);
    }
  }

  // Remove custom category
  static Future<void> removeCustomCategory(String category) async {
    final categories = await loadCustomCategories();
    categories.remove(category);
    await saveCustomCategories(categories);
  }

  // ==================== UTILITY METHODS ====================

  // Check if first time launching app
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool('first_launch') ?? true;

    if (isFirst) {
      await prefs.setBool('first_launch', false);
    }

    return isFirst;
  }

  // Get app version
  static Future<String> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_version') ?? '1.0.0';
  }

  // Save app version
  static Future<void> saveAppVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_version', version);
  }

  // Clear all app data (reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Backup data
  static Future<String> createBackup() async {
    final Map<String, dynamic> backupData = {};

    // Collect all data
    backupData['flashcards'] = await loadFlashcards();
    backupData['themeSettings'] = await loadThemeSettings();
    backupData['appSettings'] = await loadAppSettings();
    backupData['studyStats'] = await loadStudyStats();
    backupData['customCategories'] = await loadCustomCategories();

    return json.encode(backupData);
  }

  // Restore from backup
  static Future<bool> restoreFromBackup(String backupData) async {
    try {
      final Map<String, dynamic> data =
          json.decode(backupData) as Map<String, dynamic>;

      if (data['flashcards'] != null) {
        await saveFlashcards(
          List<Flashcard>.from(
            (data['flashcards'] as List).map((f) => Flashcard.fromJson(f)),
          ),
        );
      }

      if (data['themeSettings'] != null) {
        await saveThemeSettings(data['themeSettings'] as Map<String, dynamic>);
      }

      if (data['appSettings'] != null) {
        await saveAppSettings(data['appSettings'] as Map<String, dynamic>);
      }

      if (data['studyStats'] != null) {
        await saveStudyStats(data['studyStats'] as Map<String, dynamic>);
      }

      if (data['customCategories'] != null) {
        await saveCustomCategories(
          List<String>.from(data['customCategories'] as List),
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error restoring backup: $e');
      return false;
    }
  }
}
