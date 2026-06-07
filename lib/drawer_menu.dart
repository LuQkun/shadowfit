// ============================================================
// drawer_menu.dart – Chapter 6: Reusable Navigation Drawer
// Dark anime styled side menu with all navigation options
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';
import 'login.dart';
import 'session_manager.dart';

class AppDrawer extends StatelessWidget {
  /// The currently active page index
  final int currentIndex;

  /// Called when a drawer item is tapped with its index
  final ValueChanged<int> onNavigate;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  // ── Drawer Items ──────────────────────────────────────────
  static const List<Map<String, dynamic>> _navItems = [
    {'label': 'Home',           'icon': Icons.home_outlined,         'index': 0},
    {'label': 'Media',          'icon': Icons.play_circle_outline,   'index': 1},
    {'label': 'Log Mission',    'icon': Icons.add_task,              'index': 2},
    {'label': 'Profile',        'icon': Icons.person_outline,        'index': 3},
    {'label': 'Developer Team', 'icon': Icons.groups_outlined,       'index': 4},
  ];

  // ── Logout ────────────────────────────────────────────────
  void _logout(BuildContext context) {
    Navigator.pop(context); // Close drawer first
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Return to the login portal?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL',
                style: TextStyle(color: AppTheme.neonPurple)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SessionManager.logout().then((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A22),
      child: Column(
        children: [
          // ── Header ────────────────────────────────────
          _buildDrawerHeader(),
          const SizedBox(height: 8),
          // ── Nav Items ────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ..._navItems.map((item) => _buildNavTile(
                      context:  context,
                      label:    item['label'] as String,
                      icon:     item['icon']  as IconData,
                      index:    item['index'] as int,
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: Color(0xFF2A2A4A), thickness: 1),
                ),
                // Logout tile
                _buildLogoutTile(context),
              ],
            ),
          ),
          // ── Footer ───────────────────────────────────
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  // ── Drawer Header ─────────────────────────────────────────
  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0D30), Color(0xFF1A1A44)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App logo
          Row(
            children: [
              Container(
                width:  50,
                height: 50,
                decoration: BoxDecoration(
                  shape:      BoxShape.circle,
                  gradient:   AppTheme.primaryGradient,
                  boxShadow:  AppTheme.purpleGlow,
                ),
                child: const Icon(Icons.shield,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppTheme.primaryGradient.createShader(b),
                    child: const Text(
                      'SHADOWFIT',
                      style: TextStyle(
                        color:         Colors.white,
                        fontSize:      20,
                        fontWeight:    FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Text(
                    'Hunter Training System',
                    style: TextStyle(
                      color:    Colors.white.withOpacity(0.45),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // User info row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.primaryPurple.withOpacity(0.3),
                child: const Icon(Icons.person,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sung Jin-Woo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      gradient:     AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'B-RANK  ·  Lv.42',
                      style: TextStyle(
                          color:     Colors.white,
                          fontSize:  10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Nav Tile ──────────────────────────────────────────────
  Widget _buildNavTile(
      {required BuildContext context,
      required String        label,
      required IconData      icon,
      required int           index}) {
    final isActive = currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        gradient: isActive ? AppTheme.primaryGradient : null,
        color:    isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive ? AppTheme.purpleGlow : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : AppTheme.textSecondary,
          size:  22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color:      isActive ? Colors.white : AppTheme.textSecondary,
            fontSize:   14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 0.5,
          ),
        ),
        trailing: isActive
            ? Container(
                width:  6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              )
            : null,
        onTap: () {
          Navigator.pop(context); // Close drawer
          onNavigate(index);
        },
      ),
    );
  }

  // ── Logout Tile ───────────────────────────────────────────
  Widget _buildLogoutTile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        leading: const Icon(Icons.logout,
            color: Colors.redAccent, size: 22),
        title: const Text(
          'Logout',
          style: TextStyle(
              color:      Colors.redAccent,
              fontSize:   14,
              fontWeight: FontWeight.w600),
        ),
        onTap: () => _logout(context),
      ),
    );
  }

  // ── Drawer Footer ─────────────────────────────────────────
  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'ShadowFit v1.0.0  ·  © 2024',
        style: TextStyle(
          color:    Colors.white.withOpacity(0.2),
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
