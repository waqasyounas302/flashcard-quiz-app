import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final Color? selectedColor;
  final bool showCheckmark;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.color,
    this.selectedColor,
    this.showCheckmark = true,
  });

  // Color mapping for categories
  static Map<String, Color> categoryColors = {
    'General': const Color(0xFF6A11CB),
    'Math': const Color(0xFF2196F3),
    'Science': const Color(0xFF4CAF50),
    'Programming': const Color(0xFFFF9800),
    'History': const Color(0xFF795548),
    'Language': const Color(0xFFE91E63),
    'Business': const Color(0xFF9C27B0),
    'Art': const Color(0xFFFF5722),
    'Music': const Color(0xFF00BCD4),
    'Medical': const Color(0xFFF44336),
    'Technology': const Color(0xFF607D8B),
    'Literature': const Color(0xFF8BC34A),
    'Geography': const Color(0xFF3F51B5),
    'Physics': const Color(0xFF009688),
    'Chemistry': const Color(0xFFFFC107),
    'Biology': const Color(0xFF8BC34A),
  };

  // Icon mapping for categories
  static Map<String, IconData> categoryIcons = {
    'General': Icons.category_outlined,
    'Math': Icons.calculate_outlined,
    'Science': Icons.science_outlined,
    'Programming': Icons.code_outlined,
    'History': Icons.history_outlined,
    'Language': Icons.language_outlined,
    'Business': Icons.business_outlined,
    'Art': Icons.palette_outlined,
    'Music': Icons.music_note_outlined,
    'Medical': Icons.medical_services_outlined,
    'Technology': Icons.computer_outlined,
    'Literature': Icons.menu_book_outlined,
    'Geography': Icons.public_outlined,
    'Physics': Icons.biotech_outlined,
    'Chemistry': Icons.psychology_outlined,
    'Biology': Icons.spa_outlined,
  };

  Color get _backgroundColor {
    final defaultColor =
        color ?? categoryColors[label] ?? const Color(0xFF2575FC);
    return isSelected
        ? (selectedColor ?? defaultColor)
        : defaultColor.withOpacity(0.1);
  }

  Color get _foregroundColor {
    final defaultColor =
        color ?? categoryColors[label] ?? const Color(0xFF2575FC);
    return isSelected ? Colors.white : defaultColor;
  }

  IconData get _iconData {
    return icon ?? categoryIcons[label] ?? Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? _foregroundColor.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _foregroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: _foregroundColor.withOpacity(0.2),
          highlightColor: _foregroundColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_iconData, size: 18, color: _foregroundColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: _foregroundColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                if (isSelected && showCheckmark) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 12, color: _foregroundColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced version with counter
class CategoryChipWithCounter extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;
  final IconData? icon;
  final Color? color;
  final Color? selectedColor;

  const CategoryChipWithCounter({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count = 0,
    this.icon,
    this.color,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:
            CategoryChip.categoryColors[label]?.withOpacity(
              isSelected ? 1 : 0.1,
            ) ??
            const Color(0xFF2575FC).withOpacity(isSelected ? 1 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? (CategoryChip.categoryColors[label] ?? const Color(0xFF2575FC))
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color:
                      (CategoryChip.categoryColors[label] ??
                              const Color(0xFF2575FC))
                          .withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon ??
                      CategoryChip.categoryIcons[label] ??
                      Icons.category_outlined,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : CategoryChip.categoryColors[label] ??
                            const Color(0xFF2575FC),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : CategoryChip.categoryColors[label] ??
                              const Color(0xFF2575FC),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (CategoryChip.categoryColors[label] ??
                                    const Color(0xFF2575FC))
                                .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : CategoryChip.categoryColors[label] ??
                                  const Color(0xFF2575FC),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Horizontal scrolling chip selector
class CategorySelector extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final bool scrollable;
  final bool showCounts;
  final Map<String, int>? categoryCounts;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.scrollable = true,
    this.showCounts = false,
    this.categoryCounts,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    final chips = widget.categories.map((category) {
      return widget.showCounts
          ? CategoryChipWithCounter(
              label: category,
              isSelected: category == widget.selectedCategory,
              onTap: () => widget.onCategorySelected(category),
              count: widget.categoryCounts?[category] ?? 0,
            )
          : CategoryChip(
              label: category,
              isSelected: category == widget.selectedCategory,
              onTap: () => widget.onCategorySelected(category),
            );
    }).toList();

    if (widget.scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: chips),
      );
    } else {
      return Wrap(spacing: 8, runSpacing: 8, children: chips);
    }
  }
}

// Example usage in a screen:
/*
class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  String selectedCategory = 'General';

  final List<String> categories = [
    'General',
    'Math',
    'Science',
    'Programming',
    'History',
    'Language',
    'Business',
    'Art',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            // Basic selector
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),
            SizedBox(height: 24),
            Text(
              'With Counts:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            // Selector with counts
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
              showCounts: true,
              categoryCounts: {
                'General': 10,
                'Math': 5,
                'Science': 8,
                'Programming': 12,
                'History': 3,
                'Language': 7,
                'Business': 4,
                'Art': 6,
              },
            ),
            SizedBox(height: 24),
            // Individual chips
            Wrap(
              spacing: 8,
              children: [
                CategoryChip(
                  label: 'Custom 1',
                  isSelected: selectedCategory == 'Custom 1',
                  onTap: () => setState(() => selectedCategory = 'Custom 1'),
                  color: Colors.purple,
                ),
                CategoryChip(
                  label: 'Custom 2',
                  isSelected: selectedCategory == 'Custom 2',
                  onTap: () => setState(() => selectedCategory = 'Custom 2'),
                  color: Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/
