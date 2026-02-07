import 'dart:async';
import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/local_storage_service.dart';

class FlashcardProvider with ChangeNotifier {
  // List of all flashcards
  List<Flashcard> _flashcards = [];
  List<Flashcard> _filteredFlashcards = [];
  String _currentFilter = 'all';
  String _currentSort = 'date_newest';
  String _currentSearchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Flashcard> get flashcards => _filteredFlashcards;
  List<Flashcard> get allFlashcards => _flashcards;
  int get totalCards => _flashcards.length;
  int get filteredCards => _filteredFlashcards.length;
  int get learnedCards => _flashcards.where((card) => card.isLearned).length;
  bool get isLoading => _isLoading;
  String get currentFilter => _currentFilter;
  String get currentSort => _currentSort;
  String get currentSearchQuery => _currentSearchQuery;

  // Progress percentage (0.0 → 1.0)
  double get progress {
    if (_flashcards.isEmpty) return 0.0;
    return learnedCards / totalCards;
  }

  // Get all unique categories
  List<String> get categories {
    final categories = _flashcards
        .map((card) => card.category)
        .toSet()
        .toList();
    categories.sort();
    return ['all', ...categories];
  }

  // Get statistics by category
  Map<String, Map<String, int>> get categoryStats {
    final stats = <String, Map<String, int>>{};

    for (final card in _flashcards) {
      if (!stats.containsKey(card.category)) {
        stats[card.category] = {'total': 0, 'learned': 0};
      }
      stats[card.category]!['total'] = stats[card.category]!['total']! + 1;
      if (card.isLearned) {
        stats[card.category]!['learned'] =
            stats[card.category]!['learned']! + 1;
      }
    }

    return stats;
  }

  // Get daily streak (example implementation)
  int get dailyStreak {
    // This would require tracking study sessions
    // For now, return a placeholder
    return 0;
  }

  // Load flashcards from local storage with loading state
  Future<void> loadFlashcards() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading
      _flashcards = await LocalStorageService.loadFlashcards();
      _applyFiltersAndSort();
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading flashcards: $error');
      // You could show an error message here
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new flashcard with animation delay
  Future<void> addFlashcard(Flashcard flashcard) async {
    _flashcards.add(flashcard);
    _applyFiltersAndSort();
    await LocalStorageService.saveFlashcards(_flashcards);

    // Add a small delay to show success animation
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  // Edit an existing flashcard
  Future<void> editFlashcard(int index, Flashcard flashcard) async {
    if (index >= 0 && index < _filteredFlashcards.length) {
      final originalIndex = _flashcards.indexOf(_filteredFlashcards[index]);
      if (originalIndex >= 0) {
        _flashcards[originalIndex] = flashcard;
        _applyFiltersAndSort();
        await LocalStorageService.saveFlashcards(_flashcards);
        notifyListeners();
      }
    }
  }

  // Delete a flashcard with undo capability preparation
  Future<Flashcard?> deleteFlashcard(int index) async {
    if (index >= 0 && index < _filteredFlashcards.length) {
      final flashcardToDelete = _filteredFlashcards[index];
      final originalIndex = _flashcards.indexOf(flashcardToDelete);

      if (originalIndex >= 0) {
        _flashcards.removeAt(originalIndex);
        _applyFiltersAndSort();
        await LocalStorageService.saveFlashcards(_flashcards);
        notifyListeners();
        return flashcardToDelete; // Return for potential undo
      }
    }
    return null;
  }

  // Undo delete
  Future<void> undoDelete(Flashcard flashcard) async {
    _flashcards.add(flashcard);
    _applyFiltersAndSort();
    await LocalStorageService.saveFlashcards(_flashcards);
    notifyListeners();
  }

  // Toggle isLearned status with visual feedback
  Future<void> toggleLearned(int index) async {
    if (index >= 0 && index < _filteredFlashcards.length) {
      final originalIndex = _flashcards.indexOf(_filteredFlashcards[index]);
      if (originalIndex >= 0) {
        _flashcards[originalIndex].isLearned =
            !_flashcards[originalIndex].isLearned;
        _applyFiltersAndSort();
        await LocalStorageService.saveFlashcards(_flashcards);
        notifyListeners();
      }
    }
  }

  // Bulk mark as learned/unlearned
  Future<void> bulkToggleLearned(List<int> indices, bool markAsLearned) async {
    for (final index in indices) {
      if (index >= 0 && index < _filteredFlashcards.length) {
        final originalIndex = _flashcards.indexOf(_filteredFlashcards[index]);
        if (originalIndex >= 0) {
          _flashcards[originalIndex].isLearned = markAsLearned;
        }
      }
    }
    _applyFiltersAndSort();
    await LocalStorageService.saveFlashcards(_flashcards);
    notifyListeners();
  }

  // Set filter
  void setFilter(String filter) {
    _currentFilter = filter;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Set sort
  void setSort(String sort) {
    _currentSort = sort;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Search flashcards
  void searchFlashcards(String query) {
    _currentSearchQuery = query.toLowerCase();
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _currentSearchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Apply filters and sorting
  void _applyFiltersAndSort() {
    // Apply filter
    List<Flashcard> filtered = _flashcards;

    if (_currentFilter != 'all') {
      filtered = filtered
          .where((card) => card.category == _currentFilter)
          .toList();
    }

    // Apply search
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((card) {
        return card.question.toLowerCase().contains(_currentSearchQuery) ||
            card.answer.toLowerCase().contains(_currentSearchQuery) ||
            card.category.toLowerCase().contains(_currentSearchQuery);
      }).toList();
    }

    // Apply sort
    switch (_currentSort) {
      case 'date_newest':
        // Assuming Flashcard has createdAt field
        // filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'date_oldest':
        // filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'alphabetical':
        filtered.sort((a, b) => a.question.compareTo(b.question));
        break;
      case 'learned_first':
        filtered.sort((a, b) {
          if (a.isLearned && !b.isLearned) return -1;
          if (!a.isLearned && b.isLearned) return 1;
          return 0;
        });
        break;
      case 'unlearned_first':
        filtered.sort((a, b) {
          if (!a.isLearned && b.isLearned) return -1;
          if (a.isLearned && !b.isLearned) return 1;
          return 0;
        });
        break;
      case 'random':
        filtered.shuffle();
        break;
    }

    _filteredFlashcards = filtered;
  }

  // Get flashcards by category
  List<Flashcard> getFlashcardsByCategory(String category) {
    return _flashcards.where((card) => card.category == category).toList();
  }

  // Get random flashcard for quiz mode
  Flashcard? getRandomFlashcard({bool onlyUnlearned = false}) {
    final availableCards = onlyUnlearned
        ? _flashcards.where((card) => !card.isLearned).toList()
        : _flashcards;

    if (availableCards.isEmpty) return null;

    final random =
        DateTime.now().microsecondsSinceEpoch % availableCards.length;
    return availableCards[random];
  }

  // Get next card for study session
  Flashcard? getNextCard(int currentIndex, {bool onlyUnlearned = false}) {
    final availableCards = onlyUnlearned
        ? _flashcards.where((card) => !card.isLearned).toList()
        : _flashcards;

    if (availableCards.isEmpty) return null;

    final nextIndex = (currentIndex + 1) % availableCards.length;
    return availableCards[nextIndex];
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalCards': totalCards,
      'learnedCards': learnedCards,
      'progress': progress,
      'categories': categories.length - 1, // minus 'all'
      'dailyStreak': dailyStreak,
      'averagePerCategory': totalCards / (categories.length - 1),
    };
  }

  // Clear all flashcards with confirmation
  Future<void> clearAll() async {
    _flashcards.clear();
    _filteredFlashcards.clear();
    _currentFilter = 'all';
    _currentSearchQuery = '';
    await LocalStorageService.clearFlashcards();
    notifyListeners();
  }

  // Import flashcards (for future expansion)
  Future<void> importFlashcards(List<Flashcard> newFlashcards) async {
    _flashcards.addAll(newFlashcards);
    _applyFiltersAndSort();
    await LocalStorageService.saveFlashcards(_flashcards);
    notifyListeners();
  }

  // Export flashcards (for future expansion)
  List<Flashcard> exportFlashcards() {
    return List.from(_flashcards);
  }

  // Reset all filters and sorting
  void resetFilters() {
    _currentFilter = 'all';
    _currentSort = 'date_newest';
    _currentSearchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }
}
