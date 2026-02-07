import 'package:flutter/material.dart';

class FlashcardCard extends StatefulWidget {
  final String text;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;
  final IconData? icon;
  final bool isFlipping;
  final double flipAngle;
  final bool showHint;
  final String? hintText;
  final Alignment? gradientBegin;
  final Alignment? gradientEnd;
  final BoxShadow? customShadow;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool interactive;

  const FlashcardCard({
    super.key,
    required this.text,
    required this.onTap,
    this.subtitle,
    this.onDoubleTap,
    this.onLongPress,
    this.backgroundColor,
    this.gradientStartColor,
    this.gradientEndColor,
    this.textStyle,
    this.subtitleStyle,
    this.icon,
    this.isFlipping = false,
    this.flipAngle = 0.0,
    this.showHint = true,
    this.hintText,
    this.gradientBegin,
    this.gradientEnd,
    this.customShadow,
    this.borderRadius,
    this.padding,
    this.interactive = true,
  });

  @override
  State<FlashcardCard> createState() => _FlashcardCardState();
}

class _FlashcardCardState extends State<FlashcardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white.withOpacity(0.1),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.interactive) {
      _animationController.forward();
      setState(() => _isTapped = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.interactive) {
      _animationController.reverse();
      setState(() => _isTapped = false);
    }
  }

  void _handleTapCancel() {
    if (widget.interactive) {
      _animationController.reverse();
      setState(() => _isTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // Default colors
    final defaultGradientStart =
        widget.gradientStartColor ??
        (isDark ? Colors.grey[900]! : Colors.white);
    final defaultGradientEnd =
        widget.gradientEndColor ??
        (isDark ? Colors.grey[800]! : Colors.grey[50]!);
    final defaultTextStyle =
        widget.textStyle ??
        TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
          height: 1.4,
          fontFamily: 'Inter',
        );
    final defaultSubtitleStyle =
        widget.subtitleStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          letterSpacing: 1.2,
        );
    final defaultBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(20);
    final defaultPadding = widget.padding ?? const EdgeInsets.all(24);

    // Shadow based on theme
    final defaultShadow =
        widget.customShadow ??
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
          blurRadius: 20,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Apply flip transformation if needed
        Matrix4 transform = Matrix4.identity();
        if (widget.isFlipping) {
          transform.setEntry(3, 2, 0.001);
          transform.rotateY(widget.flipAngle);
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: defaultBorderRadius,
                boxShadow: [
                  defaultShadow,
                  if (_isTapped)
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: defaultBorderRadius,
                child: InkWell(
                  onTap: widget.onTap,
                  onDoubleTap: widget.onDoubleTap,
                  onLongPress: widget.onLongPress,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: defaultBorderRadius,
                  splashColor: theme.primaryColor.withOpacity(0.1),
                  highlightColor: theme.primaryColor.withOpacity(0.05),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: defaultBorderRadius,
                      gradient: LinearGradient(
                        begin: widget.gradientBegin ?? Alignment.topLeft,
                        end: widget.gradientEnd ?? Alignment.bottomRight,
                        colors: [defaultGradientStart, defaultGradientEnd],
                        stops: const [0.0, 1.0],
                      ),
                      border: Border.all(
                        color: _isTapped
                            ? theme.primaryColor.withOpacity(0.3)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern (subtle)
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.03,
                            child: CustomPaint(
                              painter: _CardPatternPainter(
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: defaultPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon (if provided)
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  size: 48,
                                  color: theme.primaryColor.withOpacity(0.8),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Main text
                              SelectableText(
                                widget.text,
                                textAlign: TextAlign.center,
                                style: defaultTextStyle,
                              ),

                              // Subtitle (if provided)
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  widget.subtitle!,
                                  textAlign: TextAlign.center,
                                  style: defaultSubtitleStyle,
                                ),
                              ],

                              // Hint (if enabled)
                              if (widget.showHint && widget.interactive) ...[
                                const SizedBox(height: 32),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        size: 16,
                                        color: theme.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.hintText ?? 'Tap to flip',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Corner decoration
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Ripple effect overlay
                        if (_isTapped)
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: defaultBorderRadius,
                              child: Container(color: _colorAnimation.value),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Pattern painter for card background
class _CardPatternPainter extends CustomPainter {
  final Color color;

  _CardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    const radius = 1.0;

    // Draw grid of dots
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }

    // Draw border lines
    final borderPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final borderRect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(borderRect, const Radius.circular(18)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative: Minimal card style
class MinimalFlashcardCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? borderColor;

  const MinimalFlashcardCard({
    super.key,
    required this.text,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? theme.primaryColor.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Flipping animation wrapper
class FlippingFlashcardCard extends StatefulWidget {
  final String frontText;
  final String backText;
  final String frontSubtitle;
  final String backSubtitle;
  final IconData frontIcon;
  final IconData backIcon;
  final Duration flipDuration;
  final bool isFlipped;
  final VoidCallback onFlip;

  const FlippingFlashcardCard({
    super.key,
    required this.frontText,
    required this.backText,
    this.frontSubtitle = 'Question',
    this.backSubtitle = 'Answer',
    this.frontIcon = Icons.help_outline,
    this.backIcon = Icons.lightbulb_outline,
    this.flipDuration = const Duration(milliseconds: 600),
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  State<FlippingFlashcardCard> createState() => _FlippingFlashcardCardState();
}

class _FlippingFlashcardCardState extends State<FlippingFlashcardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: widget.flipDuration,
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    if (widget.isFlipped) {
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlippingFlashcardCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.14159;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: FlashcardCard(
            text: _flipAnimation.value < 0.5
                ? widget.frontText
                : widget.backText,
            subtitle: _flipAnimation.value < 0.5
                ? widget.frontSubtitle
                : widget.backSubtitle,
            icon: _flipAnimation.value < 0.5
                ? widget.frontIcon
                : widget.backIcon,
            onTap: widget.onFlip,
            isFlipping:
                _flipAnimation.value > 0.0 && _flipAnimation.value < 1.0,
            flipAngle: angle,
            showHint: true,
            hintText: 'Tap to flip',
          ),
        );
      },
    );
  }
}
