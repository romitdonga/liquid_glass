import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/dashboard_page.dart';
import 'package:liquid_glass_demo/favorite_page.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';

/// Main navigation container with glass effects and animated transitions
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  double _tabSpacing = 0.0;
  final GlobalKey<DashboardPageState> _dashboardKey = GlobalKey();
  bool _isSearchHovered = false;

  /// Fixed screens that can be navigated between
  List<Widget> get _screens => [
        DashboardPage(key: _dashboardKey),
        const FavoritePage(),
      ];

  /// Handles scroll notifications to animate tab spacing
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final double newSpacing = notification.metrics.pixels > 10 ? 150 : 0;
      if (_tabSpacing != newSpacing) {
        setState(() => _tabSpacing = newSpacing);
      }
    }
    return false;
  }

  /// Changes the current tab with animation
  void _changeTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  /// Activates search by focusing the search field
  void _activateSearch() {
    if (_currentIndex != 0) {
      _changeTab(0);
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
      backgroundColor: const Color(0xFF0D7787),
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
            _buildLiquidTabs(),

            // Animated spacing
            AnimatedSize(
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: SizedBox(width: _tabSpacing, height: 0),
            ),

            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the tabs with liquid animation between selections
  Widget _buildLiquidTabs() {
    return LiquidGlass.inLayer(
      blur: 2,
      shape: LiquidRoundedSuperellipse(
        borderRadius: const Radius.circular(40),
      ),
      glassContainsChild: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabItem(
              index: 0,
              icon: Icons.home,
              label: 'Home',
            ),
            _buildTabItem(
              index: 1,
              icon: Icons.favorite_border_rounded,
              activeIcon: Icons.favorite,
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual tab item with selection state
  Widget _buildTabItem({
    required int index,
    required IconData icon,
    IconData? activeIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    final Widget tabContent = isSelected
        ? LiquidGlass(
            blur: 8,
            settings: LiquidGlassSettings(
              ambientStrength: 0.5,
              lightAngle: 0.2 * math.pi,
              glassColor: Colors.black26,
              thickness: 10,
            ),
            shape: LiquidRoundedSuperellipse(
              borderRadius: const Radius.circular(40),
            ),
            glassContainsChild: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
              child: Row(
                children: [
                  Icon(
                    activeIcon ?? icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  AutoSizeText(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          );

    return GestureDetector(
      onTap: () => _changeTab(index),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        child: tabContent,
      ),
    );
  }

  /// Builds the search button with hover animation
  Widget _buildSearchButton() {
    return GestureDetector(
      onTap: _activateSearch,
      onTapDown: (_) => setState(() => _isSearchHovered = true),
      onTapUp: (_) => setState(() => _isSearchHovered = false),
      onTapCancel: () => setState(() => _isSearchHovered = false),
      child: LiquidGlass.inLayer(
        blur: _isSearchHovered ? 4 : 2,
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
