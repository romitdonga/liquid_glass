import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/circles.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';

/// The favorites page displaying saved properties with glass morphism effects
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Animation controllers for visual effects
  late final AnimationController _pulseController;
  late final AnimationController _rippleController;
  late final AnimationController _pageEntryController;

  // Animation values
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rippleAnimation;
  late final Animation<double> _entryAnimation;

  // Interaction state
  int? _hoveredCardIndex;
  int? _tappedCardIndex;

  @override
  void initState() {
    super.initState();

    // Configure animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _pageEntryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _entryAnimation = CurvedAnimation(
      parent: _pageEntryController,
      curve: Curves.easeOutQuint,
    );
    _pageEntryController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _pageEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0D7787),
      body: Stack(
        children: [
          // Animated background
          const CirclesBackground(),

          // Main content
          AnimatedBuilder(
            animation: _entryAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - _entryAnimation.value)),
                child: Opacity(
                  opacity: _entryAnimation.value,
                  child: child,
                ),
              );
            },
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: screenSize.height * 0.12,
                left: isSmallScreen ? 16 : screenSize.width * 0.05,
                right: isSmallScreen ? 16 : screenSize.width * 0.05,
                bottom: screenSize.height * 0.12,
              ),
              children: [
                _buildEmptyFavoritesMessage(isSmallScreen, screenSize),
                _buildSampleItems(isSmallScreen, screenSize),
              ],
            ),
          ),

          // Floating header
          _buildFloatingHeader(isSmallScreen, screenSize),
        ],
      ),
    );
  }

  /// Builds the floating glass header that reacts to scroll position
  Widget _buildFloatingHeader(bool isSmallScreen, Size screenSize) {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, _) {
        // Calculate header opacity based on scroll position
        final scrollOffset = _scrollController.hasClients
            ? _scrollController.offset.clamp(0.0, 80.0) / 80.0
            : 0.0;

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _entryAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - _entryAnimation.value)),
                child: Opacity(
                  opacity: _entryAnimation.value,
                  child: child,
                ),
              );
            },
            child: LiquidGlass(
              blur: 8 * scrollOffset.clamp(0.3, 1.0),
              settings: LiquidGlassSettings(
                ambientStrength: 0.6,
                lightAngle: 0.25 * math.pi,
                glassColor: Colors.white.withOpacity(0.1 + 0.1 * scrollOffset),
                thickness: 15 * scrollOffset,
              ),
              shape: LiquidRoundedSuperellipse(
                borderRadius: Radius.circular(30),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 16,
                    horizontal: isSmallScreen ? 16 : screenSize.width * 0.05,
                  ),
                  child: Row(
                    children: [
                      _buildAnimatedIcon(
                        icon: Icons.arrow_back_ios_new,
                        size: isSmallScreen ? 20 : 24,
                        onTap: () {
                          _rippleController.reset();
                          _rippleController.forward();
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: AutoSizeText(
                          'Favorites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      _buildAnimatedIcon(
                        icon: Icons.filter_list_rounded,
                        size: isSmallScreen ? 22 : 26,
                        onTap: () {
                          _rippleController.reset();
                          _rippleController.forward();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the empty favorites message with glass effect
  Widget _buildEmptyFavoritesMessage(bool isSmallScreen, Size screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main content card with glass effect
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: _buildGlassCard(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24 : screenSize.width * 0.08,
                vertical: isSmallScreen ? 16 : screenSize.height * 0.025,
              ),
              blur: 8,
              thickness: 20,
              onTap: () {
                _rippleController.reset();
                _rippleController.forward();
              },
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_rippleAnimation.value * 0.1),
                        child: Opacity(
                          opacity: 1.0 -
                              (_rippleAnimation.value * 0.3) +
                              (_rippleAnimation.value * 0.3),
                          child: child,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AutoSizeText(
                    'Your Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    minFontSize: 18,
                  ),
                  const SizedBox(height: 8),
                  const AutoSizeText(
                    'No favorite properties yet',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: isSmallScreen ? 24 : screenSize.height * 0.03),

          // Hint message with glass effect
          AnimatedBuilder(
            animation: Listenable.merge([_entryAnimation, _rippleAnimation]),
            builder: (context, child) {
              final double offsetY =
                  math.sin(_entryAnimation.value * math.pi) * 8;
              return Transform.translate(
                offset: Offset(0, offsetY),
                child: _buildGlassCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : screenSize.width * 0.04,
                    vertical: isSmallScreen ? 12 : screenSize.height * 0.02,
                  ),
                  blur: 4,
                  thickness: 5,
                  onTap: () {
                    _rippleController.reset();
                    _rippleController.forward();
                  },
                  child: const AutoSizeText(
                    'Tap on properties to add them here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds sample placeholder items for the favorites page
  Widget _buildSampleItems(bool isSmallScreen, Size screenSize) {
    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 40 : screenSize.height * 0.06),
        for (int i = 0; i < 3; i++)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (i * 200)),
            curve: Curves.easeOutQuint,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isSmallScreen ? 20 : screenSize.height * 0.025,
              ),
              child: _buildSamplePropertyItem(i, isSmallScreen, screenSize),
            ),
          ),
      ],
    );
  }

  /// Builds a sample property item with interactive effects
  Widget _buildSamplePropertyItem(
      int index, bool isSmallScreen, Size screenSize) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredCardIndex = index),
      onExit: (_) => setState(() => _hoveredCardIndex = null),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _tappedCardIndex = index),
        onTapUp: (_) => setState(() => _tappedCardIndex = null),
        onTapCancel: () => setState(() => _tappedCardIndex = null),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final bool isHovered = _hoveredCardIndex == index;
            final bool isTapped = _tappedCardIndex == index;
            final elevationEffect = isHovered ? 1.03 : 1.0;
            final tapEffect = isTapped ? 0.97 : 1.0;
            final pulseEffect = 1.0 + (_pulseAnimation.value - 1.0) * 0.3;
            final compositeScale = elevationEffect * tapEffect * pulseEffect;

            return Transform.scale(
              scale: compositeScale,
              child: _buildGlassCard(
                padding: EdgeInsets.all(
                    isSmallScreen ? 20 : screenSize.width * 0.03),
                blur: isHovered ? 8 : 6,
                thickness: isHovered ? 25 : 15,
                borderRadius: 24,
                onTap: () {
                  _rippleController.reset();
                  _rippleController.forward();
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.house_outlined,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    SizedBox(
                        width: isSmallScreen ? 16 : screenSize.width * 0.02),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Sample Property ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            minFontSize: 16,
                          ),
                          const SizedBox(height: 4),
                          AutoSizeText(
                            'Modern ${3 + index}-bedroom house with garden',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            minFontSize: 12,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildFeatureChip(
                                icon: Icons.bed_outlined,
                                text: '${3 + index}',
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 12),
                              _buildFeatureChip(
                                icon: Icons.bathroom_outlined,
                                text: '${2 + index}',
                                isSmallScreen: isSmallScreen,
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 12),
                              _buildFeatureChip(
                                icon: Icons.square_foot_outlined,
                                text: '${1200 + (index * 300)}sqft',
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(isHovered ? 0.9 : 0.6),
                      size: isHovered ? 20 : 16,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Creates a feature chip with icon and text
  Widget _buildFeatureChip({
    required IconData icon,
    required String text,
    required bool isSmallScreen,
  }) {
    return LiquidGlass(
      blur: 2,
      settings: LiquidGlassSettings(
        ambientStrength: 0.4,
        lightAngle: 0.2 * math.pi,
        glassColor: Colors.white.withOpacity(0.1),
        thickness: 5,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: Radius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 6 : 8,
          vertical: isSmallScreen ? 4 : 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: isSmallScreen ? 14 : 16,
            ),
            SizedBox(width: isSmallScreen ? 4 : 6),
            Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a reusable glass effect card with consistent styling
  Widget _buildGlassCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
    double blur = 4.0,
    double thickness = 0.0,
    double borderRadius = 40.0,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlass(
        blur: blur,
        settings: LiquidGlassSettings(
          ambientStrength: 0.5,
          lightAngle: 0.2 * math.pi,
          glassColor: Colors.white12,
          thickness: thickness,
        ),
        shape: LiquidRoundedSuperellipse(
          borderRadius: Radius.circular(borderRadius),
        ),
        glassContainsChild: false,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }

  /// Creates an animated icon button with liquid glass effect
  Widget _buildAnimatedIcon({
    required IconData icon,
    required VoidCallback onTap,
    double size = 24.0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlass(
        blur: 2,
        settings: LiquidGlassSettings(
          ambientStrength: 0.5,
          lightAngle: 0.2 * math.pi,
          glassColor: Colors.white12,
          thickness: 5,
        ),
        shape: LiquidRoundedSuperellipse(
          borderRadius: const Radius.circular(12),
        ),
        child: AnimatedBuilder(
          animation: _rippleAnimation,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform.scale(
                scale: 1.0 + (_rippleAnimation.value * 0.1),
                child: Opacity(
                  opacity: 1.0 -
                      (_rippleAnimation.value * 0.3) +
                      (_rippleAnimation.value * 0.3),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: size,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
