import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/dashboard_page.dart';
import 'package:liquid_glass_demo/favorite_page.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;

/// Main navigation container that manages screen switching with custom glass navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  // Current selected tab index
  int _currentIndex = 0;

  // Tab spacing state (animated based on scroll)
  double _tabSpacing = 0.0;

  // Animation controller for tab transitions
  late final AnimationController _animationController;

  // Animation for liquid tab movement
  late final Animation<double> _tabAnimation;

  // Animation for tab width expansion/contraction
  late final Animation<double> _tabWidthAnimation;

  // Key to access dashboard page state
  final GlobalKey<DashboardPageState> _dashboardKey = GlobalKey();

  // Search button hover state
  bool _isSearchHovered = false;

  // Fixed screens that can be navigated between
  List<Widget> get _screens => [
        DashboardPage(key: _dashboardKey),
        const FavoritePage(),
      ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create tab animation with curved effect
    _tabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Create tab width animation
    _tabWidthAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handles scroll notifications from child pages
  ///
  /// Expands tab spacing when scrolled beyond threshold, creating
  /// a visual animation effect for the navigation bar
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final double newSpacing = notification.metrics.pixels > 10 ? 150 : 0;
      if (_tabSpacing != newSpacing) {
        setState(() => _tabSpacing = newSpacing);
      }
    }
    return false; // Allow the notification to continue to be dispatched
  }

  /// Change the current tab with animated transition
  void _changeTab(int index) {
    if (_currentIndex == index) return;

    // Set animation direction based on tab index
    if (index > _currentIndex) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }

    setState(() => _currentIndex = index);
  }

  /// Activate search by focusing the search field on the dashboard page
  void _activateSearch() {
    if (_currentIndex != 0) {
      // Switch to home tab first if we're not there
      _changeTab(0);
      // Wait for tab change animation to complete before focusing
      Future.delayed(const Duration(milliseconds: 600), () {
        _dashboardKey.currentState?.focusSearch();
      });
    } else {
      _dashboardKey.currentState?.focusSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF032343),
      body: Stack(
        children: [
          // Page content with scroll notification listener
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),

          // Custom glass navigation bar at bottom
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: _buildNavigationBar(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the glass-effect navigation bar with tab items
  Widget _buildNavigationBar() {
    return LiquidGlassLayer(
      settings: LiquidGlassSettings(
        ambientStrength: 0.5,
        lightAngle: 0.2 * math.pi,
        glassColor: Colors.white12,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Navigation items container with liquid selection
            _buildLiquidTabs(),

            // Animated spacing between nav items and right icon
            AnimatedSize(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: SizedBox(width: _tabSpacing, height: 0),
            ),

            // Search icon with glass effect
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the tabs with liquid animation between selections
  Widget _buildLiquidTabs() {
    // Define some constants for layout
    const double tabsHeight = 56.0;
    const double tabsPadding = 4.0;
    const double itemWidth = 85.0;
    const double homeOffset = 0.0;
    const double favOffset = itemWidth + 4.0;

    return SizedBox(
      height: tabsHeight,
      width: itemWidth * 2 + 12,
      child: Stack(
        children: [
          // Base glass container with rounded corners
          Positioned.fill(
            child: LiquidGlass.inLayer(
              blur: 3,
              shape: LiquidRoundedSuperellipse(
                borderRadius: const Radius.circular(40),
              ),
              glassContainsChild: false,
              child: const SizedBox(),
            ),
          ),

          // Animated liquid selection indicator
          AnimatedBuilder(
            animation: _tabAnimation,
            builder: (context, _) {
              final double animValue = _tabAnimation.value;

              // Calculate the selector position based on animation
              final double selectionPosition = _currentIndex == 0
                  ? homeOffset + (favOffset - homeOffset) * animValue
                  : favOffset - (favOffset - homeOffset) * (1 - animValue);

              // Create liquid-like transformations for width and height
              double extraWidth = 0;
              double verticalStretch = 0;

              // Mid-animation transformations to create flowing effect
              if (animValue > 0.05 && animValue < 0.95) {
                // Expand width in middle of transition, contract at ends
                final double widthMultiplier =
                    _getSinValue(animValue * 2, 0.5, 1.0);
                extraWidth = itemWidth * 0.3 * widthMultiplier;

                // Create slight vertical squish-and-expand effect
                verticalStretch = 4 * _getSinValue(animValue * 3, 0.5, 0.8);
              }

              return Positioned(
                left: selectionPosition - (extraWidth / 2),
                top: tabsPadding - (verticalStretch / 2),
                bottom: tabsPadding - (verticalStretch / 2),
                width: itemWidth + extraWidth,
                child: LiquidGlass(
                  blur: 8,
                  settings: LiquidGlassSettings(
                    ambientStrength:
                        0.5 + (animValue > 0.3 && animValue < 0.7 ? 0.1 : 0),
                    lightAngle: 0.2 * math.pi,
                    glassColor: Colors.black26,
                    thickness: 10,
                  ),
                  shape: LiquidRoundedSuperellipse(
                    borderRadius: const Radius.circular(36),
                  ),
                  glassContainsChild: false,
                  child: const SizedBox(),
                ),
              );
            },
          ),

          // Tab items (fixed, don't move)
          Padding(
            padding: const EdgeInsets.all(tabsPadding),
            child: Row(
              children: [
                // Home tab
                _buildTabIcon(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_outlined,
                  label: 'Home',
                ),
                const SizedBox(width: 4),
                // Favorites tab
                _buildTabIcon(
                  index: 1,
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite,
                  label: 'Favorites',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper function to create smooth sinusoidal animation curves
  /// Creates a value that rises and falls like a sine wave
  double _getSinValue(double phase, double min, double max) {
    // Convert phase to range 0-1 for full sine cycle
    final normalized = phase % 1.0;
    // Calculate sin value (0 to 1)
    final sinValue = (1 + math.sin(normalized * math.pi * 2 - math.pi / 2)) / 2;
    // Map to desired range
    return min + sinValue * (max - min);
  }

  /// Builds individual tab icon and label
  Widget _buildTabIcon({
    required int index,
    required IconData icon,
    IconData? activeIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _changeTab(index),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon changes based on selection state
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? (activeIcon ?? icon) : icon,
                key: ValueKey<bool>(isSelected),
                color: Colors.white,
                size: 24,
              ),
            ),

            // Label appears when selected
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: isSelected
                  ? Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search button on the right side of navigation
  /// with hover animation and tap to focus search
  Widget _buildSearchButton() {
    return GestureDetector(
      onTap: _activateSearch,
      onTapDown: (_) => setState(() => _isSearchHovered = true),
      onTapUp: (_) => setState(() => _isSearchHovered = false),
      onTapCancel: () => setState(() => _isSearchHovered = false),
      child: LiquidGlass(
        blur: _isSearchHovered ? 5 : 3,
        settings: LiquidGlassSettings(
          ambientStrength: _isSearchHovered ? 0.7 : 0.5,
          lightAngle: 0.2 * math.pi,
          glassColor: _isSearchHovered ? Colors.white24 : Colors.white12,
          thickness: _isSearchHovered ? 15 : 10,
        ),
        shape: LiquidRoundedSuperellipse(
          borderRadius: const Radius.circular(40),
        ),
        glassContainsChild: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.all(_isSearchHovered ? 14.0 : 12.0),
          child: Icon(
            Icons.search_outlined,
            color: Colors.white,
            size: _isSearchHovered ? 34 : 32,
          ),
        ),
      ),
    );
  }
}
