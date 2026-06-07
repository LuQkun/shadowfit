// ============================================================
// bottom_nav.dart – Chapter 6: MainScreen Navigation
// BottomNavigationBar + Drawer wrapping all 5 pages
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';
import 'home.dart';
import 'media.dart';
import 'form_page.dart';
import 'profile.dart';
import 'developer_page.dart';
import 'drawer_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ── Page Index ────────────────────────────────────────────
  int _currentIndex = 0;

  // ── Page Config ───────────────────────────────────────────
  static const List<Map<String, dynamic>> _pageConfig = [
    {
      'title': 'HUNTER STATUS',
      'icon':  Icons.home_outlined,
      'activeIcon': Icons.home,
      'label': 'Home',
    },
    {
      'title': 'MEDIA LIBRARY',
      'icon':  Icons.play_circle_outline,
      'activeIcon': Icons.play_circle,
      'label': 'Media',
    },
    {
      'title': 'LOG MISSION',
      'icon':  Icons.add_circle_outline,
      'activeIcon': Icons.add_circle,
      'label': 'Mission',
    },
    {
      'title': 'HUNTER PROFILE',
      'icon':  Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Profile',
    },
    {
      'title': 'SYSTEM DEVELOPERS',
      'icon':  Icons.groups_outlined,
      'activeIcon': Icons.groups,
      'label': 'Team',
    },
  ];

  // ── Pages ────────────────────────────────────────────────
  // Using IndexedStack to preserve page state
  static const List<Widget> _pages = [
    HomePage(),
    MediaPage(),
    FormPage(),
    ProfilePage(),
    DeveloperPage(),
  ];

  // ── Navigate ─────────────────────────────────────────────
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final config = _pageConfig[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      // ── App Bar ──────────────────────────────────────────
      appBar: AppBar(
        title: Text(config['title'] as String),
        actions: [
          // Notification bell
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.neonPurple),
            onPressed: () {},
          ),
          // Rank badge
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient:     AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow:    AppTheme.purpleGlow,
                ),
                child: const Text(
                  'B  Lv.42',
                  style: TextStyle(
                    color:      Colors.white,
                    fontSize:   11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // ── Drawer ───────────────────────────────────────────
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onNavigate:   _onPageChanged,
      ),
      // ── Body ─────────────────────────────────────────────
      // IndexedStack preserves each page's scroll/state
      body: IndexedStack(
        index:    _currentIndex,
        children: _pages,
      ),
      // ── Bottom Navigation Bar ────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Bottom Nav Builder ────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        boxShadow: [
          BoxShadow(
            color:       AppTheme.primaryPurple.withOpacity(0.25),
            blurRadius:  20,
            spreadRadius: 2,
            offset:      const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex:     _currentIndex,
        onTap:            _onPageChanged,
        backgroundColor:  Colors.transparent,
        elevation:        0,
        selectedItemColor:   AppTheme.neonPurple,
        unselectedItemColor: const Color(0xFF444466),
        showSelectedLabels:   true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.3),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: List.generate(_pageConfig.length, (i) {
          final item     = _pageConfig[i];
          final isActive = i == _currentIndex;
          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: isActive ? AppTheme.primaryGradient : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isActive ? AppTheme.purpleGlow : null,
              ),
              child: Icon(
                isActive
                    ? item['activeIcon'] as IconData
                    : item['icon']       as IconData,
                size: 22,
              ),
            ),
            label: item['label'] as String,
          );
        }),
      ),
    );
  }
}
