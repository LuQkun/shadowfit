// ============================================================
// profile.dart – Chapter 4: Hunter Profile Page
// CircleAvatar, personal info cards, rank badge, logout
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';
import 'login.dart';
import 'session_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ── Profile Data ──────────────────────────────────────────
  static const _name      = 'Sung Jin-Woo';
  static const _email     = 'sungJW@shadowguild.my';
  static const _phone     = '+60 12-345 6789';
  static const _studentId = 'CS2024001';
  static const _course    = 'BSc Computer Science';
  static const _rank      = 'B-Rank Hunter';

  // ── Info Rows ─────────────────────────────────────────────
  static const List<Map<String, dynamic>> _infoItems = [
    {'icon': Icons.email_outlined,     'label': 'Email',      'value': _email},
    {'icon': Icons.phone_outlined,     'label': 'Phone',      'value': _phone},
    {'icon': Icons.badge_outlined,     'label': 'Student ID', 'value': _studentId},
    {'icon': Icons.school_outlined,    'label': 'Course',     'value': _course},
    {'icon': Icons.military_tech,      'label': 'Rank',       'value': _rank},
  ];

  // ── Stat Badges ───────────────────────────────────────────
  static const List<Map<String, dynamic>> _statBadges = [
    {'label': 'Workouts', 'value': '128',  'icon': Icons.fitness_center},
    {'label': 'Level',    'value': '42',   'icon': Icons.star},
    {'label': 'EXP',      'value': '45K',  'icon': Icons.bolt},
    {'label': 'Streak',   'value': '14d',  'icon': Icons.local_fire_department},
  ];

  // ── Logout ────────────────────────────────────────────────
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to leave the system?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('STAY',
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Profile Header ────────────────────────────
          _buildProfileHeader(),
          // ── Stat Badges ───────────────────────────────
          _buildStatBadges(),
          const SizedBox(height: 20),
          // ── Info Cards ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('HUNTER DETAILS'),
                const SizedBox(height: 12),
                _buildInfoCard(),
                const SizedBox(height: 24),
                // ── Logout Button ──────────────────────
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    width:  double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCC2929), Color(0xFFFF416C)],
                        begin:  Alignment.centerLeft,
                        end:    Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:       Colors.redAccent.withOpacity(0.4),
                          blurRadius:  14,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'LOGOUT FROM SYSTEM',
                          style: TextStyle(
                            color:         Colors.white,
                            fontSize:      15,
                            fontWeight:    FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A1A), Color(0xFF1A1A42)],
          begin:  Alignment.topCenter,
          end:    Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Avatar with glow
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape:     BoxShape.circle,
                  boxShadow: AppTheme.purpleGlow,
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: AppTheme.cardBg,
                  child: Container(
                    width:  110,
                    height: 110,
                    decoration: const BoxDecoration(
                      shape:    BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 52),
                  ),
                ),
              ),
              Container(
                width:  28,
                height: 28,
                decoration: BoxDecoration(
                  shape:    BoxShape.circle,
                  gradient: AppTheme.cyanGradient,
                  border: Border.all(color: AppTheme.background, width: 2),
                ),
                child: const Icon(Icons.edit,
                    color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Name
          const Text(
            _name,
            style: TextStyle(
              color:      Colors.white,
              fontSize:   22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          // Rank badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              gradient:     AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow:    AppTheme.purpleGlow,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.military_tech,
                    color: Colors.amber, size: 16),
                SizedBox(width: 5),
                Text(
                  'B-RANK HUNTER',
                  style: TextStyle(
                    color:         Colors.white,
                    fontSize:      12,
                    fontWeight:    FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Stat Badges ───────────────────────────────────────────
  Widget _buildStatBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        boxShadow: AppTheme.cardGlow,
      ),
      child: Row(
        children: _statBadges.map((s) {
          return Expanded(
            child: Column(
              children: [
                Icon(s['icon'] as IconData,
                    color: AppTheme.neonPurple, size: 22),
                const SizedBox(height: 4),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  s['label'] as String,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Info Card ─────────────────────────────────────────────
  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow:    AppTheme.cardGlow,
        border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.25)),
      ),
      child: Column(
        children: _infoItems.asMap().entries.map((entry) {
          final isLast = entry.key == _infoItems.length - 1;
          final item   = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width:  38,
                  height: 38,
                  decoration: BoxDecoration(
                    color:        AppTheme.primaryPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.primaryPurple.withOpacity(0.3)),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppTheme.neonPurple,
                    size:  20,
                  ),
                ),
                title: Text(
                  item['label'] as String,
                  style: const TextStyle(
                      color:    AppTheme.textSecondary,
                      fontSize: 11,
                      letterSpacing: 0.5),
                ),
                subtitle: Text(
                  item['value'] as String,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height:  1,
                  color:   Colors.white.withOpacity(0.05),
                  indent:  16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
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
}
