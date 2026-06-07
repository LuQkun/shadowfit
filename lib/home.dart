// ============================================================
// home.dart – Chapter 2: Hunter Status Dashboard
// Dashboard with rank cards, stats, quick actions, activity
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ── EXP / Progress state ─────────────────────────────────
  final double _expProgress = 0.72;

  // ── Stat Cards data ──────────────────────────────────────
  final List<Map<String, dynamic>> _statCards = [
    {
      'label':    'Calories',
      'value':    '1,240',
      'unit':     'kcal',
      'icon':     Icons.local_fire_department,
      'gradient': [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    },
    {
      'label':    'Workout',
      'value':    '1h 45m',
      'unit':     'today',
      'icon':     Icons.timer_outlined,
      'gradient': [const Color(0xFF7B2FBE), const Color(0xFF448AFF)],
    },
    {
      'label':    'Daily EXP',
      'value':    '3,600',
      'unit':     'exp',
      'icon':     Icons.star_outline,
      'gradient': [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
    },
    {
      'label':    'Rank',
      'value':    'B',
      'unit':     'Hunter',
      'icon':     Icons.military_tech,
      'gradient': [const Color(0xFF00B4D8), const Color(0xFF0077B6)],
    },
  ];

  // ── Quick Actions ────────────────────────────────────────
  final List<Map<String, dynamic>> _quickActions = [
    {'label': 'Start\nWorkout',  'icon': Icons.fitness_center,      'color': const Color(0xFF7B2FBE)},
    {'label': 'Meal\nPlan',      'icon': Icons.restaurant_menu,     'color': const Color(0xFF00B4D8)},
    {'label': 'Progress',        'icon': Icons.bar_chart,           'color': const Color(0xFFFF416C)},
    {'label': 'Training\nMode',  'icon': Icons.sports_martial_arts, 'color': const Color(0xFFFFD700)},
  ];

  // ── Recent Activities ────────────────────────────────────
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'icon':     Icons.fitness_center,
      'color':    const Color(0xFF7B2FBE),
      'title':    'Shadow Push-Ups',
      'subtitle': '5 sets · 50 reps · +720 EXP',
    },
    {
      'icon':     Icons.directions_run,
      'color':    const Color(0xFF00B4D8),
      'title':    'Sprint Training',
      'subtitle': '10 km · 48 min · +900 EXP',
    },
    {
      'icon':     Icons.sports_gymnastics,
      'color':    const Color(0xFFFF8C00),
      'title':    'Core Conditioning',
      'subtitle': '20 min · 6 exercises · +540 EXP',
    },
    {
      'icon':     Icons.sports_martial_arts,
      'color':    const Color(0xFFFF416C),
      'title':    'Combat Drills',
      'subtitle': '30 min · Full body · +810 EXP',
    },
    {
      'icon':     Icons.self_improvement,
      'color':    const Color(0xFF0077B6),
      'title':    'Mana Meditation',
      'subtitle': '15 min · Recovery · +360 EXP',
    },
  ];

  // ── Animation ────────────────────────────────────────────
  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Banner ────────────────────────────
            _buildWelcomeBanner(),
            const SizedBox(height: 20),
            // ── EXP Progress ──────────────────────────────
            _buildExpBar(),
            const SizedBox(height: 20),
            // ── Stat Cards ────────────────────────────────
            _sectionLabel('HUNTER STATS'),
            const SizedBox(height: 10),
            _buildStatCards(),
            const SizedBox(height: 22),
            // ── Quick Actions ─────────────────────────────
            _sectionLabel('QUICK ACTIONS'),
            const SizedBox(height: 10),
            _buildQuickActions(),
            const SizedBox(height: 22),
            // ── Recent Activities ─────────────────────────
            _sectionLabel('RECENT ACTIVITIES'),
            const SizedBox(height: 10),
            _buildRecentActivities(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Welcome Banner ────────────────────────────────────────
  Widget _buildWelcomeBanner() {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:     AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow:    AppTheme.purpleGlow,
      ),
      child: Row(
        children: [
          Container(
            width:  58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white30, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Hunter',
                  style: TextStyle(
                    color:    Colors.white.withOpacity(0.75),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'HUNTER STATUS',
                  style: TextStyle(
                    color:         Colors.white,
                    fontSize:      20,
                    fontWeight:    FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _rankBadge('B-Rank'),
                    const SizedBox(width: 8),
                    _rankBadge('Lv. 42'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.military_tech, color: Colors.amber, size: 32),
              const SizedBox(height: 2),
              Text(
                'B',
                style: TextStyle(
                  color:      Colors.amber.shade200,
                  fontSize:   22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:        Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color:      Colors.white,
          fontSize:   11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── EXP Progress Bar ──────────────────────────────────────
  Widget _buildExpBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow:    AppTheme.cardGlow,
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXP Progress',
                style: TextStyle(
                  color:    AppTheme.neonPurple,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '3,600 / 5,000 EXP',
                style: TextStyle(
                  color:    AppTheme.neonCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:           _expProgress,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.neonPurple),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(_expProgress * 100).toInt()}%  —  Next rank: A-Rank',
            style: TextStyle(
              color:    Colors.white.withOpacity(0.45),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ─────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width:  3,
          height: 16,
          decoration: BoxDecoration(
            gradient:     AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color:         AppTheme.neonPurple,
            fontSize:      12,
            fontWeight:    FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // ── Stat Cards ────────────────────────────────────────────
  Widget _buildStatCards() {
    return GridView.builder(
      shrinkWrap:   true,
      physics:      const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 1.45,
      ),
      itemCount: _statCards.length,
      itemBuilder: (_, i) {
        final card = _statCards[i];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (card['gradient'] as List).cast<Color>(),
              begin:  Alignment.topLeft,
              end:    Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:       (card['gradient'] as List<Color>)[0].withOpacity(0.4),
                blurRadius:  12,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card['label'] as String,
                    style: const TextStyle(
                      color:    Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Icon(card['icon'] as IconData,
                      color: Colors.white70, size: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['value'] as String,
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    card['unit'] as String,
                    style: const TextStyle(
                      color:    Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Quick Actions ─────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      children: _quickActions.map((action) {
        return Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color:        AppTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: (action['color'] as Color).withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color:       (action['color'] as Color).withOpacity(0.2),
                    blurRadius:  8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    action['icon'] as IconData,
                    color: action['color'] as Color,
                    size:  24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color:    Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Recent Activities ─────────────────────────────────────
  Widget _buildRecentActivities() {
    return ListView.builder(
      shrinkWrap: true,
      physics:    const NeverScrollableScrollPhysics(),
      itemCount:  _recentActivities.length,
      itemBuilder: (_, i) {
        final item = _recentActivities[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color:        AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            boxShadow:    AppTheme.cardGlow,
            border: Border.all(
              color: AppTheme.primaryPurple.withOpacity(0.15),
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width:  44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (item['color'] as Color).withOpacity(0.15),
                border: Border.all(
                  color: (item['color'] as Color).withOpacity(0.5),
                ),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size:  22,
              ),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(
                color:      Colors.white,
                fontSize:   14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              item['subtitle'] as String,
              style: TextStyle(
                color:    AppTheme.neonCyan.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.neonPurple,
              size:  20,
            ),
          ),
        );
      },
    );
  }
}
