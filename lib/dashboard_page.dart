import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_demo/circles.dart';
import 'package:liquid_glass_demo/home_data.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;
import 'dart:ui';

/// Main dashboard page displaying property listings with glass morphism effects
///
/// This StatefulWidget manages the dashboard interface including
/// user profile, search functionality, and property cards.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

/// State class for the dashboard page with public methods for external control
class DashboardPageState extends State<DashboardPage> {
  /// Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  /// Focus node for managing search field focus
  final FocusNode _searchFocusNode = FocusNode();

  /// Controller for tracking ListView scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Public method to focus the search field from external widgets
  void focusSearch() => _searchFocusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    // Set system UI style for status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFF0D7787),
      body: GestureDetector(
        onTap: () => _searchFocusNode.unfocus(),
        child: Stack(
          children: [
            // Animated background circles
            const CirclesBackground(),

            // Property listings in a scrollable list
            _buildPropertyList(),

            // Gradient overlay at top for better readability
            _buildTopGradientOverlay(),

            // Top app bar with profile and search
            _buildTopBar(),
          ],
        ),
      ),
    );
  }

  /// Builds the scrollable list of property cards
  Widget _buildPropertyList() {
    return ListView.separated(
      controller: _scrollController,
      itemCount: sampleHomes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      padding: const EdgeInsets.only(
        top: 188,
        left: 16,
        right: 16,
        bottom: 100, // Extra padding for bottom navigation bar
      ),
      itemBuilder: (_, index) => _buildPropertyCard(sampleHomes[index]),
    );
  }

  /// Builds an individual property card with image and details
  Widget _buildPropertyCard(HomeData home) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Property image
          AspectRatio(
            aspectRatio: 1,
            child: Image(
              image: AssetImage(home.image),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Glass overlay with property details
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Property name and favorite button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            home.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),

                      // Location info
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white60,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            home.location,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Property details and price
                      Row(
                        children: [
                          _buildPropertyFeature(Icons.bed_outlined,
                              '${home.numberOfRooms} Rooms'),

                          const SizedBox(width: 8),

                          _buildPropertyFeature(Icons.bathroom_outlined,
                              '${home.numberOfBathrooms} Baths'),

                          const Spacer(),

                          // Price per night
                          Text(
                            '\$ ${home.pricePerNight.toStringAsFixed(2)}/night',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a property feature with icon and text
  Widget _buildPropertyFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Creates a gradient overlay at the top of the screen
  Widget _buildTopGradientOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D7787).withOpacity(0),
              const Color(0xFF0D7787),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  /// Builds the top app bar with user profile and search
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [
            // User profile and notifications row
            Row(
              children: [
                // User avatar with glass effect
                _buildGlassContainer(
                  blur: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/alex-suprun.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // User name and location
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'James Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white60,
                          size: 16,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'New York, NY',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const Spacer(),

                // Notification button with glass effect
                _buildGlassContainer(
                  blur: 2,
                  settings: LiquidGlassSettings(
                    ambientStrength: 0.5,
                    lightAngle: -0.2 * math.pi,
                    glassColor: Colors.white12,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildSearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the search bar with glass effect
  Widget _buildSearchBar() {
    return _buildGlassContainer(
      blur: 1,
      settings: LiquidGlassSettings(
        ambientStrength: 2,
        lightAngle: 0.4 * math.pi,
        glassColor: Colors.black12,
        thickness: 30,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            hintText: 'Search properties...',
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white60,
              size: 22,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// Helper to create glass effect containers with consistent styling
  Widget _buildGlassContainer({
    required Widget child,
    double blur = 4.0,
    LiquidGlassSettings? settings,
  }) {
    return LiquidGlass(
      blur: blur,
      settings: settings ??
          LiquidGlassSettings(
            ambientStrength: 0.5,
            lightAngle: 0.2 * math.pi,
            glassColor: Colors.white12,
          ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: const Radius.circular(40),
      ),
      glassContainsChild: false,
      child: child,
    );
  }
}
