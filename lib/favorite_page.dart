import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/circles.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;

/// The favorites page displaying saved properties with glass morphism effect
class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  /// Controller for tracking ListView scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF032343),
      body: Stack(
        children: [
          // Animated circle background
          const CirclesBackground(),

          // Scrollable content
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
              bottom: 100,
            ),
            children: [
              _buildEmptyFavoritesMessage(),
              _buildSampleItems(),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the empty favorites message with glass effect
  Widget _buildEmptyFavoritesMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main content card with glass effect
          _buildGlassCard(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
            blur: 8,
            thickness: 20,
            child: Column(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Favorites',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No favorite properties yet',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Hint message with glass effect
          _buildGlassCard(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            blur: 4,
            child: const Text(
              'Tap on properties to add them here',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds sample placeholder items for the favorites page
  Widget _buildSampleItems() {
    return Column(
      children: [
        const SizedBox(height: 40),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _buildGlassCard(
              padding: const EdgeInsets.all(20.0),
              blur: 6,
              borderRadius: 24,
              child: Row(
                children: [
                  const Icon(
                    Icons.house_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Sample Property',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Properties you like will appear here',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white60,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Creates a reusable glass effect card with the specified parameters
  ///
  /// This helper method reduces code duplication for glass cards with similar styles
  Widget _buildGlassCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
    double blur = 4.0,
    double thickness = 0.0,
    double borderRadius = 40.0,
  }) {
    return LiquidGlass(
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
    );
  }
}
