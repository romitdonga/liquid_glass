import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_demo/circles.dart';
import 'package:liquid_glass_demo/home_data.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math' as math;
import 'dart:ui';

/// The main dashboard page widget displaying property listings
///
/// This StatefulWidget manages the entire dashboard interface including
/// user profile, search functionality, property cards, and navigation.
/// It demonstrates various glass morphism effects and animations.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

/// State management for the dashboard page
///
/// Handles scroll animations, search functionality, and UI state management.
/// Implements scroll-based animations for the navigation tabs.
class _DashboardPageState extends State<DashboardPage> {
  /// Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  /// Focus node for managing search field focus
  final FocusNode _searchFocusNode = FocusNode();

  /// Controller for tracking ListView scroll position
  final ScrollController _scrollController = ScrollController();

  /// Current spacing between navigation tabs (animated based on scroll)
  double _tabSpacing = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Handles scroll events to animate navigation tab spacing
  ///
  /// This method creates a dynamic animation effect where the navigation
  /// tabs spread apart when the user scrolls down, providing visual
  /// feedback about scroll position.
  void _onScroll() {
    final offset = _scrollController.offset;

    // Expand tabs when scrolled beyond 100px threshold
    if (offset > 100) {
      setState(() {
        _tabSpacing = 150;
      });
    } else {
      setState(() {
        _tabSpacing = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFF032343),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Stack(
          children: [
            const CirclesBackground(),
            ListView.separated(
              controller: _scrollController,
              itemCount: sampleHomes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              padding: const EdgeInsets.only(
                top: 188,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image(
                        image: AssetImage(sampleHomes[index].image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sampleHomes[index].name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white60,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      sampleHomes[index].location,
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bed_outlined,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${sampleHomes[index].numberOfRooms} Rooms',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.bathroom_outlined,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${sampleHomes[index].numberOfBathrooms} Baths',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '\$ ${sampleHomes[index].pricePerNight.toStringAsFixed(2)}/night',
                                      style: TextStyle(
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
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF032343).withOpacity(0),
                      Color(0xFF032343),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        LiquidGlass(
                          blur: 3,
                          settings: LiquidGlassSettings(
                            ambientStrength: 0.5,
                            lightAngle: 0.2 * math.pi,
                            glassColor: Colors.white12,
                          ),
                          shape: LiquidRoundedSuperellipse(
                            borderRadius: const Radius.circular(40),
                          ),
                          glassContainsChild: false,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'James Doe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white60,
                                  size: 16,
                                ),
                                const SizedBox(width: 2),
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
                        LiquidGlass(
                          blur: 3,
                          settings: LiquidGlassSettings(
                            ambientStrength: 0.5,
                            lightAngle: -0.2 * math.pi,
                            glassColor: Colors.white12,
                          ),
                          shape: LiquidRoundedSuperellipse(
                            borderRadius: const Radius.circular(40),
                          ),
                          glassContainsChild: false,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: LiquidGlass(
                              blur: 4,
                              settings: LiquidGlassSettings(
                                ambientStrength: 2,
                                lightAngle: 0.4 * math.pi,
                                glassColor: Colors.black12,
                                thickness: 30,
                              ),
                              shape: LiquidRoundedSuperellipse(
                                borderRadius: const Radius.circular(40),
                              ),
                              glassContainsChild: false,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
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
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: LiquidGlassLayer(
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
                              LiquidGlass.inLayer(
                                blur: 3,
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: const Radius.circular(40),
                                ),
                                glassContainsChild: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      LiquidGlass(
                                        blur: 8,
                                        settings: LiquidGlassSettings(
                                          ambientStrength: 0.5,
                                          lightAngle: 0.2 * math.pi,
                                          glassColor: Colors.black26,
                                          thickness: 10,
                                        ),
                                        shape: LiquidRoundedSuperellipse(
                                          borderRadius:
                                              const Radius.circular(40),
                                        ),
                                        glassContainsChild: false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.home_outlined,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              Text(
                                                'Home',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedSize(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                child: Container(
                                  width: _tabSpacing,
                                  height: 0,
                                ),
                              ),
                              LiquidGlass.inLayer(
                                blur: 3,
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: const Radius.circular(40),
                                ),
                                glassContainsChild: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
