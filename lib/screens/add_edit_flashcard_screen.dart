import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  final Flashcard? flashcard;
  final int? index;

  const AddEditFlashcardScreen({super.key, this.flashcard, this.index});

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _gradientAnimation;

  late TextEditingController _questionController;
  late TextEditingController _answerController;

  String selectedCategory = 'General';
  bool _isProcessing = false;
  int _currentStep = 1;

  final List<String> categories = [
    'General',
    'Math',
    'Science',
    'Programming',
    'History',
    'Language',
    'Business',
    'Art',
    'Music',
    'Medical',
  ];

  final Map<String, IconData> categoryIcons = {
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
  };

  final Map<String, Color> categoryColors = {
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
  };

  @override
  void initState() {
    super.initState();

    _questionController = TextEditingController(
      text: widget.flashcard?.question ?? '',
    );
    _answerController = TextEditingController(
      text: widget.flashcard?.answer ?? '',
    );
    selectedCategory = widget.flashcard?.category ?? 'General';

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF6A11CB),
      end: const Color(0xFF2575FC),
    ).animate(_controller);

    _controller.forward();
  }

  Future<void> _saveFlashcard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Show processing animation
    await Future.delayed(const Duration(milliseconds: 500));

    final newFlashcard = Flashcard(
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
      category: selectedCategory,
      isLearned: widget.flashcard?.isLearned ?? false,
      createdAt: DateTime.now(),
    );

    final provider = Provider.of<FlashcardProvider>(context, listen: false);

    if (widget.flashcard == null) {
      provider.addFlashcard(newFlashcard);
    } else {
      provider.editFlashcard(widget.index!, newFlashcard);
    }

    // Show success animation before navigating back
    setState(() => _currentStep = 3);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _nextStep() {
    if (_currentStep == 1 && _questionController.text.trim().isNotEmpty) {
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      _saveFlashcard();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode
        ? Colors.blueAccent
        : const Color(0xFF2575FC);
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F7);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              // HEADER
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _currentStep == 3 ? 0 : 1,
                  child: Text(
                    widget.flashcard == null
                        ? 'Create New Flashcard'
                        : 'Edit Flashcard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                centerTitle: true,
                floating: true,
                snap: true,
              ),

              // CONTENT
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _currentStep == 3
                        ? _buildSuccessScreen()
                        : Form(
                            key: _formKey,
                            child: Column(
                              key: ValueKey<int>(_currentStep),
                              children: [
                                // PROGRESS INDICATOR
                                _buildProgressIndicator(primaryColor),

                                const SizedBox(height: 40),

                                // STEP CONTENT
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(0, 0.1),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: _controller,
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                    child: _buildStepContent(
                                      isDarkMode,
                                      cardColor,
                                      primaryColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // NAVIGATION BUTTONS
                                _buildNavigationButtons(primaryColor),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(Color primaryColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStepCircle(1, 'Question', primaryColor),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _currentStep >= 2
                          ? primaryColor
                          : primaryColor.withOpacity(0.2),
                      _currentStep >= 2
                          ? primaryColor
                          : primaryColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            _buildStepCircle(2, 'Category', primaryColor),
            Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _currentStep >= 3
                          ? primaryColor
                          : primaryColor.withOpacity(0.2),
                      _currentStep == 3
                          ? primaryColor
                          : primaryColor.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
            _buildStepCircle(3, 'Save', primaryColor),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _getStepTitle(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepCircle(int stepNumber, String label, Color primaryColor) {
    final bool isActive = _currentStep >= stepNumber;
    final bool isCurrent = _currentStep == stepNumber;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? primaryColor : primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? primaryColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: isCurrent
                          ? primaryColor
                          : primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? primaryColor : primaryColor.withOpacity(0.5),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'What is your question?';
      case 2:
        return 'Choose a category';
      case 3:
        return 'Saving your flashcard';
      default:
        return '';
    }
  }

  Widget _buildStepContent(
    bool isDarkMode,
    Color cardColor,
    Color primaryColor,
  ) {
    switch (_currentStep) {
      case 1:
        return _buildQuestionStep(cardColor, primaryColor);
      case 2:
        return _buildCategoryStep(primaryColor);
      default:
        return const SizedBox();
    }
  }

  Widget _buildQuestionStep(Color cardColor, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // QUESTION INPUT
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, color: primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Question',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _questionController,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter your question here...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ANSWER INPUT
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Answer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _answerController,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter the answer here...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an answer' : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // CHARACTER COUNT
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${_questionController.text.length}/200',
              style: TextStyle(
                fontSize: 12,
                color: _questionController.text.length > 180
                    ? Colors.orange
                    : primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryStep(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the category that best fits your flashcard',
          style: TextStyle(fontSize: 14, color: primaryColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 30),

        // CATEGORY GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final bool isSelected = selectedCategory == category;
            final Color categoryColor =
                categoryColors[category] ?? primaryColor;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected
                    ? categoryColor
                    : categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? categoryColor : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => selectedCategory = category);
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          categoryIcons[category] ?? Icons.category_outlined,
                          color: isSelected ? Colors.white : categoryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : categoryColor,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(Color primaryColor) {
    return Row(
      children: [
        if (_currentStep > 1)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_currentStep > 1) const SizedBox(width: 16),
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: primaryColor.withOpacity(0.3),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep == 2 ? 'Save Flashcard' : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentStep == 2
                              ? Icons.save_outlined
                              : Icons.arrow_forward_ios_rounded,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, size: 60, color: Colors.green),
        ),
        const SizedBox(height: 40),
        Text(
          widget.flashcard == null
              ? 'Flashcard Created!'
              : 'Flashcard Updated!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Your flashcard has been saved successfully.\nYou can now review it in your deck.',
          style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Done',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
