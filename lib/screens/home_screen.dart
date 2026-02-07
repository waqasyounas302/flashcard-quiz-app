import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../providers/theme_provider.dart';
import '../models/flashcard_model.dart';
import 'add_edit_flashcard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  bool showAnswer = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipping) return;
    _isFlipping = true;

    _flipController.forward().then((_) {
      setState(() {
        showAnswer = !showAnswer;
      });
      _flipController.reverse().then((_) {
        _isFlipping = false;
      });
    });
  }

  void _navigateCard(bool forward) {
    setState(() {
      if (forward &&
          currentIndex <
              Provider.of<FlashcardProvider>(
                    context,
                    listen: false,
                  ).flashcards.length -
                  1) {
        currentIndex++;
      } else if (!forward && currentIndex > 0) {
        currentIndex--;
      }
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final flashcardProvider = Provider.of<FlashcardProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<Flashcard> flashcards = flashcardProvider.flashcards;
    final bool isDarkMode = themeProvider.isDarkMode;

    // Color Scheme
    final Color primaryColor = isDarkMode
        ? Colors.blueAccent
        : const Color(0xFF2575FC);
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F7);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color accentColor = isDarkMode
        ? Colors.amber
        : const Color(0xFFFF9800);

    // EMPTY STATE
    if (flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: CustomPaint(painter: _WavePatternPainter()),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Start Your Learning Journey',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first flashcard to begin mastering new concepts',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddEditFlashcardScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text(
                        'Create First Flashcard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(primaryColor),
      );
    }

    // SAFE INDEX
    if (currentIndex >= flashcards.length) {
      currentIndex = flashcards.length - 1;
    }

    final Flashcard card = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 700;
            final double padding = isSmallScreen ? 12.0 : 20.0;
            final double cardPadding = isSmallScreen ? 16.0 : 32.0;
            final double iconSize = isSmallScreen ? 40.0 : 60.0;
            final double fontSize = isSmallScreen ? 18.0 : 24.0;
            final double buttonPadding = isSmallScreen ? 14.0 : 18.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HEADER
                      _buildHeader(
                        context,
                        themeProvider,
                        flashcardProvider,
                        primaryColor,
                        isDarkMode,
                        card,
                        isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      // PROGRESS SECTION
                      _buildProgressSection(
                        flashcardProvider,
                        primaryColor,
                        accentColor,
                        isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // FLASHCARD
                      Container(
                        height: isSmallScreen
                            ? constraints.maxHeight * 0.45
                            : constraints.maxHeight * 0.5,
                        child: GestureDetector(
                          onTap: _flipCard,
                          child: AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (context, child) {
                              final angle = _flipAnimation.value * 3.14159;
                              final transform = Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle);

                              return Transform(
                                transform: transform,
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          isDarkMode ? 0.3 : 0.1,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(cardPadding),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              showAnswer
                                                  ? Icons.lightbulb_outline
                                                  : Icons.help_outline,
                                              size: iconSize,
                                              color: primaryColor.withOpacity(
                                                0.8,
                                              ),
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 15 : 25,
                                            ),
                                            Text(
                                              showAnswer
                                                  ? card.answer
                                                  : card.question,
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                                height: 1.4,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 12 : 20,
                                            ),
                                            Text(
                                              showAnswer
                                                  ? 'Answer'
                                                  : 'Question',
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 12
                                                    : 14,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 12 : 20,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: primaryColor.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.touch_app,
                                                    size: isSmallScreen
                                                        ? 12
                                                        : 14,
                                                    color: primaryColor,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Tap to flip',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen
                                                          ? 10
                                                          : 12,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 30),

                      // CARD INDICATORS
                      _buildCardIndicators(
                        flashcards.length,
                        currentIndex,
                        primaryColor,
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // ACTION BUTTONS
                      _buildActionButtons(
                        card,
                        flashcardProvider,
                        primaryColor,
                        isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 15 : 25),

                      // NAVIGATION BUTTONS
                      _buildNavigationButtons(
                        flashcards.length,
                        primaryColor,
                        isSmallScreen,
                        buttonPadding,
                      ),

                      SizedBox(height: isSmallScreen ? 10 : 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(primaryColor),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeProvider themeProvider,
    FlashcardProvider flashcardProvider,
    Color primaryColor,
    bool isDarkMode,
    Flashcard card,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flashcard Pro',
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Card ${currentIndex + 1} of ${flashcardProvider.totalCards}',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(
              icon: themeProvider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: isDarkMode ? Colors.amber : Colors.deepPurple,
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: 'Toggle theme',
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            _buildIconButton(
              icon: Icons.edit_outlined,
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditFlashcardScreen(
                      flashcard: card,
                      index: currentIndex,
                    ),
                  ),
                );
              },
              tooltip: 'Edit card',
              isSmallScreen: isSmallScreen,
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            _buildIconButton(
              icon: Icons.delete_outline,
              color: Colors.red,
              onPressed: () {
                _showDeleteDialog(context, flashcardProvider, primaryColor);
              },
              tooltip: 'Delete card',
              isSmallScreen: isSmallScreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isSmallScreen,
  }) {
    return Container(
      width: isSmallScreen ? 36 : 44,
      height: isSmallScreen ? 36 : 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: isSmallScreen ? 18 : 22),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildProgressSection(
    FlashcardProvider provider,
    Color primaryColor,
    Color accentColor,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(provider.progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    width: constraints.maxWidth * provider.progress,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentColor, primaryColor],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learned: ${provider.learnedCards}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 13,
                  color: primaryColor.withOpacity(0.8),
                ),
              ),
              Text(
                'Total: ${provider.totalCards}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 13,
                  color: primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardIndicators(int total, int current, Color primaryColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          total,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: index == current ? 24 : 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index == current
                  ? primaryColor
                  : primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    Flashcard card,
    FlashcardProvider provider,
    Color primaryColor,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => provider.toggleLearned(currentIndex),
            icon: Icon(
              card.isLearned ? Icons.check_circle : Icons.circle_outlined,
              size: isSmallScreen ? 16 : 20,
            ),
            label: Text(
              card.isLearned ? 'Marked as Learned' : 'Mark as Learned',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: card.isLearned
                  ? Colors.green.withOpacity(0.1)
                  : primaryColor.withOpacity(0.1),
              foregroundColor: card.isLearned ? Colors.green : primaryColor,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: card.isLearned
                      ? Colors.green.withOpacity(0.3)
                      : primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _flipCard,
            icon: Icon(
              showAnswer ? Icons.undo : Icons.flip,
              size: isSmallScreen ? 16 : 20,
            ),
            label: Text(
              showAnswer ? 'Show Question' : 'Show Answer',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(
    int totalCards,
    Color primaryColor,
    bool isSmallScreen,
    double buttonPadding,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: currentIndex > 0 ? () => _navigateCard(false) : null,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            label: Text(
              'Previous',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: primaryColor,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              shadowColor: Colors.transparent,
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 10 : 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: currentIndex < totalCards - 1
                ? () => _navigateCard(true)
                : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            label: Text(
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(Color primaryColor) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditFlashcardScreen()),
        );
      },
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add, size: 24),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    FlashcardProvider provider,
    Color primaryColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text(
              'Delete Card',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this flashcard? This action cannot be undone.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: primaryColor, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteFlashcard(currentIndex);
              setState(() {
                showAnswer = false;
                if (currentIndex > 0) currentIndex--;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Delete', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class _WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path = Path();
    final waveCount = 15;
    final waveHeight = size.height / 15;

    for (int i = 0; i < waveCount; i++) {
      final x = size.width * i / waveCount;
      path.moveTo(x, size.height / 2);
      path.quadraticBezierTo(
        x + size.width / (waveCount * 2),
        size.height / 2 - waveHeight,
        x + size.width / waveCount,
        size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
