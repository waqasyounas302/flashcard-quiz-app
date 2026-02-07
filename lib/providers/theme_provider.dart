import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/local_storage_service.dart';

class ThemeProvider with ChangeNotifier {
  // Theme modes
  static const String _system = 'system';
  static const String _light = 'light';
  static const String _dark = 'dark';
  static const String _blueDark = 'blue_dark';
  static const String _sunset = 'sunset';
  static const String _forest = 'forest';
  static const String _midnight = 'midnight';

  // Current theme settings
  String _themeMode = _system;
  bool _useSystemTheme = true;
  bool _followSystemSchedule = false;
  int _darkModeStartHour = 18; // 6 PM
  int _darkModeEndHour = 7; // 7 AM
  bool _dynamicColors = false;
  double _textScaleFactor = 1.0;
  double _fontSizeFactor = 1.0;
  bool _highContrast = false;
  bool _reduceAnimations = false;
  Color? _accentColor;

  // Available theme modes
  final List<Map<String, dynamic>> _availableThemes = [
    {
      'id': _system,
      'name': 'System',
      'icon': Icons.phone_android,
      'description': 'Follow device theme',
    },
    {
      'id': _light,
      'name': 'Light',
      'icon': Icons.light_mode,
      'description': 'Bright theme for daytime',
    },
    {
      'id': _dark,
      'name': 'Dark',
      'icon': Icons.dark_mode,
      'description': 'Dark theme for night',
    },
    {
      'id': _blueDark,
      'name': 'Blue Dark',
      'icon': Icons.nightlight,
      'description': 'Dark theme with blue accent',
    },
    {
      'id': _sunset,
      'name': 'Sunset',
      'icon': Icons.wb_sunny,
      'description': 'Warm orange theme',
    },
    {
      'id': _forest,
      'name': 'Forest',
      'icon': Icons.forest,
      'description': 'Green nature theme',
    },
    {
      'id': _midnight,
      'name': 'Midnight',
      'icon': Icons.nights_stay,
      'description': 'Deep purple theme',
    },
  ];

  // Available accent colors
  final List<Color> _availableAccentColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.amber,
  ];

  // Getters
  String get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;
  bool get followSystemSchedule => _followSystemSchedule;
  bool get dynamicColors => _dynamicColors;
  double get textScaleFactor => _textScaleFactor;
  double get fontSizeFactor => _fontSizeFactor;
  bool get highContrast => _highContrast;
  bool get reduceAnimations => _reduceAnimations;
  Color? get accentColor => _accentColor;
  List<Map<String, dynamic>> get availableThemes => _availableThemes;
  List<Color> get availableAccentColors => _availableAccentColors;
  bool get isDarkMode => _shouldUseDarkMode();

  // For quick toggle
  bool get isDarkThemeActive => _shouldUseDarkMode();

  // Timer for auto theme switching
  Timer? _themeScheduleTimer;

  ThemeProvider() {
    _loadThemeSettings();
    _setupThemeSchedule();
  }

  // Load theme settings from local storage
  Future<void> _loadThemeSettings() async {
    final settings = await LocalStorageService.loadThemeSettings();
    if (settings != null) {
      _themeMode = settings['themeMode'] ?? _system;
      _useSystemTheme = settings['useSystemTheme'] ?? true;
      _followSystemSchedule = settings['followSystemSchedule'] ?? false;
      _darkModeStartHour = settings['darkModeStartHour'] ?? 18;
      _darkModeEndHour = settings['darkModeEndHour'] ?? 7;
      _dynamicColors = settings['dynamicColors'] ?? false;
      _textScaleFactor = settings['textScaleFactor']?.toDouble() ?? 1.0;
      _fontSizeFactor = settings['fontSizeFactor']?.toDouble() ?? 1.0;
      _highContrast = settings['highContrast'] ?? false;
      _reduceAnimations = settings['reduceAnimations'] ?? false;

      if (settings['accentColor'] != null) {
        _accentColor = Color(settings['accentColor']);
      }
    }
    notifyListeners();
  }

  // Save theme settings to local storage
  Future<void> _saveThemeSettings() async {
    final settings = {
      'themeMode': _themeMode,
      'useSystemTheme': _useSystemTheme,
      'followSystemSchedule': _followSystemSchedule,
      'darkModeStartHour': _darkModeStartHour,
      'darkModeEndHour': _darkModeEndHour,
      'dynamicColors': _dynamicColors,
      'textScaleFactor': _textScaleFactor,
      'fontSizeFactor': _fontSizeFactor,
      'highContrast': _highContrast,
      'reduceAnimations': _reduceAnimations,
      'accentColor': _accentColor?.value,
    };
    await LocalStorageService.saveThemeSettings(settings);
  }

  // Setup theme schedule timer
  void _setupThemeSchedule() {
    _themeScheduleTimer?.cancel();
    _themeScheduleTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_followSystemSchedule && _themeMode == _system) {
        final shouldBeDark = _shouldUseDarkMode();
        if (shouldBeDark != _shouldUseDarkMode()) {
          notifyListeners();
        }
      }
    });
  }

  // Determine if dark mode should be used
  bool _shouldUseDarkMode() {
    final now = DateTime.now();
    final currentHour = now.hour;

    switch (_themeMode) {
      case _system:
        if (_followSystemSchedule) {
          // Check if current time is within dark mode hours
          if (_darkModeStartHour < _darkModeEndHour) {
            // Normal range (e.g., 18:00 to 7:00)
            return currentHour >= _darkModeStartHour ||
                currentHour < _darkModeEndHour;
          } else {
            // Cross midnight (e.g., 20:00 to 6:00)
            return currentHour >= _darkModeStartHour ||
                currentHour < _darkModeEndHour;
          }
        }
        return false; // Default to light if not following schedule

      case _dark:
      case _blueDark:
      case _midnight:
        return true;

      case _light:
      case _sunset:
      case _forest:
      default:
        return false;
    }
  }

  // Get current theme based on settings
  ThemeData get currentTheme {
    final isDark = _shouldUseDarkMode();

    ThemeData baseTheme;

    switch (_themeMode) {
      case _blueDark:
        baseTheme = AppTheme.blueDarkTheme;
        break;
      case _sunset:
        baseTheme = AppTheme.sunsetTheme;
        break;
      case _forest:
        baseTheme = AppTheme.forestTheme;
        break;
      case _midnight:
        baseTheme = AppTheme.midnightTheme;
        break;
      default:
        baseTheme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }

    // Apply accent color if set
    if (_accentColor != null) {
      baseTheme = baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: _accentColor!,
          secondary: _accentColor!,
        ),
      );
    }

    // Apply high contrast if enabled
    if (_highContrast) {
      baseTheme = baseTheme.copyWith(
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.black,
          secondary: Colors.black,
          surface: Colors.white,
        ),
      );
    }

    // Apply text scaling
    baseTheme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontSizeFactor: _fontSizeFactor * _textScaleFactor,
      ),
    );

    // Reduce animations if enabled
    if (_reduceAnimations) {
      baseTheme = baseTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );
    }

    return baseTheme;
  }

  // Simple toggle (backward compatibility)
  void toggleTheme() {
    if (_themeMode == _dark ||
        _themeMode == _blueDark ||
        _themeMode == _midnight) {
      setTheme(_light);
    } else {
      setTheme(_dark);
    }
  }

  // Set specific theme
  Future<void> setTheme(String themeId) async {
    _themeMode = themeId;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Toggle use system theme
  Future<void> toggleSystemTheme() async {
    _useSystemTheme = !_useSystemTheme;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Toggle follow system schedule
  Future<void> toggleSystemSchedule() async {
    _followSystemSchedule = !_followSystemSchedule;
    await _saveThemeSettings();
    _setupThemeSchedule();
    notifyListeners();
  }

  // Set dark mode schedule hours
  Future<void> setDarkModeSchedule(int startHour, int endHour) async {
    _darkModeStartHour = startHour;
    _darkModeEndHour = endHour;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Toggle dynamic colors
  Future<void> toggleDynamicColors() async {
    _dynamicColors = !_dynamicColors;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Set text scale factor
  Future<void> setTextScaleFactor(double factor) async {
    _textScaleFactor = factor.clamp(0.8, 1.5);
    await _saveThemeSettings();
    notifyListeners();
  }

  // Set font size factor
  Future<void> setFontSizeFactor(double factor) async {
    _fontSizeFactor = factor.clamp(0.8, 1.5);
    await _saveThemeSettings();
    notifyListeners();
  }

  // Reset text size to default
  Future<void> resetTextSize() async {
    _textScaleFactor = 1.0;
    _fontSizeFactor = 1.0;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Toggle high contrast
  Future<void> toggleHighContrast() async {
    _highContrast = !_highContrast;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Toggle reduce animations
  Future<void> toggleReduceAnimations() async {
    _reduceAnimations = !_reduceAnimations;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Set accent color
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Reset accent color to default
  Future<void> resetAccentColor() async {
    _accentColor = null;
    await _saveThemeSettings();
    notifyListeners();
  }

  // Get theme info by ID
  Map<String, dynamic>? getThemeInfo(String themeId) {
    return _availableThemes.firstWhere(
      (theme) => theme['id'] == themeId,
      orElse: () => _availableThemes.first,
    );
  }

  // Get current theme info
  Map<String, dynamic> get currentThemeInfo {
    return getThemeInfo(_themeMode) ?? _availableThemes.first;
  }

  // Check if theme is dark variant
  bool isDarkVariant(String themeId) {
    return themeId == _dark ||
        themeId == _blueDark ||
        themeId == _midnight ||
        themeId == _system && _shouldUseDarkMode();
  }

  // Check if theme is light variant
  bool isLightVariant(String themeId) {
    return themeId == _light ||
        themeId == _sunset ||
        themeId == _forest ||
        themeId == _system && !_shouldUseDarkMode();
  }

  // Get theme preview color
  Color getThemePreviewColor(String themeId) {
    switch (themeId) {
      case _light:
        return const Color(0xFFF5F5F7);
      case _dark:
        return const Color(0xFF121212);
      case _blueDark:
        return const Color(0xFF0A1A2F);
      case _sunset:
        return const Color(0xFFFFF3E0);
      case _forest:
        return const Color(0xFFE8F5E9);
      case _midnight:
        return const Color(0xFF1A1A2E);
      default:
        return _shouldUseDarkMode()
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F7);
    }
  }

  // Get theme preview accent color
  Color getThemeAccentPreview(String themeId) {
    switch (themeId) {
      case _light:
        return Colors.blue;
      case _dark:
        return Colors.blueAccent;
      case _blueDark:
        return Colors.lightBlue;
      case _sunset:
        return Colors.orange;
      case _forest:
        return Colors.green;
      case _midnight:
        return Colors.deepPurple;
      default:
        return Colors.blue;
    }
  }

  @override
  void dispose() {
    _themeScheduleTimer?.cancel();
    super.dispose();
  }
}
