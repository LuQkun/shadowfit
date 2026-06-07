// ============================================================
// media.dart – Chapter 3: Media & Content Page
// Workout plans, tips, anime routines, challenges, nutrition
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  // ── Category Filter ───────────────────────────────────────
  final List<String> _categories = [
    'All', 'Plans', 'Tips', 'Anime', 'Challenges', 'Nutrition',
  ];
  int _selectedCategory = 0;

  // ── Media Content Items ───────────────────────────────────
  final List<Map<String, dynamic>> _mediaItems = [
    {
      'category': 'Plans',
      'icon':     Icons.fitness_center,
      'color':    const Color(0xFF7B2FBE),
      'title':    'Shadow Monarch 30-Day Plan',
      'subtitle': 'Full body · Intermediate · 30 days',
      'tag':      'FEATURED',
      'tagColor': const Color(0xFF7B2FBE),
    },
    {
      'category': 'Tips',
      'icon':     Icons.tips_and_updates,
      'color':    const Color(0xFF00B4D8),
      'title':    'Hunter\'s Recovery Guide',
      'subtitle': 'Sleep, stretching & active rest',
      'tag':      'NEW',
      'tagColor': const Color(0xFF00B4D8),
    },
    {
      'category': 'Anime',
      'icon':     Icons.sports_martial_arts,
      'color':    const Color(0xFFFF416C),
      'title':    'Sung Jin-Woo Push-Up Routine',
      'subtitle': '1000 reps challenge · All levels',
      'tag':      'ANIME',
      'tagColor': const Color(0xFFFF416C),
    },
    {
      'category': 'Challenges',
      'icon':     Icons.emoji_events,
      'color':    const Color(0xFFFFD700),
      'title':    'Double Dungeon Challenge',
      'subtitle': '7-day intense HIIT program',
      'tag':      'HOT',
      'tagColor': const Color(0xFFFF8C00),
    },
    {
      'category': 'Nutrition',
      'icon':     Icons.restaurant_menu,
      'color':    const Color(0xFF4CAF50),
      'title':    'Mana Replenish Diet',
      'subtitle': 'High protein hunter meal plan',
      'tag':      'GUIDE',
      'tagColor': const Color(0xFF4CAF50),
    },
    {
      'category': 'Plans',
      'icon':     Icons.directions_run,
      'color':    const Color(0xFF448AFF),
      'title':    'Speed & Agility Protocol',
      'subtitle': 'Sprint drills · 4 weeks · Advanced',
      'tag':      'PLAN',
      'tagColor': const Color(0xFF448AFF),
    },
    {
      'category': 'Tips',
      'icon':     Icons.psychology,
      'color':    const Color(0xFFBB86FC),
      'title':    'Mental Fortitude Training',
      'subtitle': 'Mindset tips for elite hunters',
      'tag':      'TIPS',
      'tagColor': const Color(0xFFBB86FC),
    },
    {
      'category': 'Anime',
      'icon':     Icons.bolt,
      'color':    const Color(0xFFFFD700),
      'title':    'Goku-Style Power Workout',
      'subtitle': 'Bodyweight · Extreme intensity',
      'tag':      'ANIME',
      'tagColor': const Color(0xFFFF416C),
    },
    {
      'category': 'Challenges',
      'icon':     Icons.military_tech,
      'color':    const Color(0xFFFF416C),
      'title':    'S-Rank Gate Trial',
      'subtitle': 'Ultimate 21-day total body test',
      'tag':      'CHALLENGE',
      'tagColor': const Color(0xFFFF416C),
    },
    {
      'category': 'Nutrition',
      'icon':     Icons.local_drink,
      'color':    const Color(0xFF00E5FF),
      'title':    'Hunter Hydration Protocol',
      'subtitle': 'Electrolytes & performance drinks',
      'tag':      'NUTRITION',
      'tagColor': const Color(0xFF4CAF50),
    },
  ];

  // ── Filtered List ─────────────────────────────────────────
  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _mediaItems;
    final cat = _categories[_selectedCategory];
    return _mediaItems.where((m) => m['category'] == cat).toList();
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Featured Banner ───────────────────────────────
        _buildFeaturedBanner(),
        // ── Category Chips ────────────────────────────────
        _buildCategoryChips(),
        // ── Media List ────────────────────────────────────
        Expanded(child: _buildMediaList()),
      ],
    );
  }

  // ── Featured Banner ───────────────────────────────────────
  Widget _buildFeaturedBanner() {
    return Container(
      margin:  const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height:  140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FBE), Color(0xFF00B4D8)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow:    AppTheme.purpleGlow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top:   -20,
            child: Container(
              width:  130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '★  FEATURED CONTENT',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hunter Media Library',
                      style: TextStyle(
                          color:      Colors.white,
                          fontSize:   22,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${_mediaItems.length} training resources available',
                      style: TextStyle(
                          color:    Colors.white.withOpacity(0.7),
                          fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Chips ────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding:       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount:     _categories.length,
        itemBuilder:   (_, i) {
          final selected = i == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:  const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: selected ? AppTheme.primaryGradient : null,
                color:    selected ? null : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : AppTheme.primaryPurple.withOpacity(0.3),
                ),
                boxShadow: selected ? AppTheme.purpleGlow : null,
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color:      selected ? Colors.white : AppTheme.textSecondary,
                  fontSize:   12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Media List ────────────────────────────────────────────
  Widget _buildMediaList() {
    final items = _filtered;
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No content in this category.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }
    return ListView.builder(
      padding:   const EdgeInsets.fromLTRB(16, 4, 16, 20),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildMediaCard(items[i]),
    );
  }

  // ── Media Card ────────────────────────────────────────────
  Widget _buildMediaCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow:    AppTheme.cardGlow,
        border: Border.all(
          color: (item['color'] as Color).withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width:  50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                (item['color'] as Color).withOpacity(0.8),
                (item['color'] as Color).withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end:   Alignment.bottomRight,
            ),
          ),
          child: Icon(
            item['icon'] as IconData,
            color: Colors.white,
            size:  26,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                item['title'] as String,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:        (item['tagColor'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: (item['tagColor'] as Color).withOpacity(0.5),
                ),
              ),
              child: Text(
                item['tag'] as String,
                style: TextStyle(
                  color:      item['tagColor'] as Color,
                  fontSize:   9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item['subtitle'] as String,
            style: TextStyle(
              color:    AppTheme.neonCyan.withOpacity(0.65),
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.play_circle_outline,
          color: AppTheme.neonPurple,
          size:  28,
        ),
      ),
    );
  }
}
