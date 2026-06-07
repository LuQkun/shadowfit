// ============================================================
// developer_page.dart – System Developer / About Team Page
// Futuristic anime-style team showcase with neon glow cards
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  // ── Team Members Data ─────────────────────────────────────
  static const List<Map<String, dynamic>> _team = [
    {
      'name':    'Luqman',
      'role':    'UI Designer',
      'desc':    'Designed the user interface and overall anime-themed user experience.',
      'icon':    Icons.palette_outlined,
      'rank':    'S-RANK',
      'badge':   '🎨',
      'gradient': [Color(0xFF7B2FBE), Color(0xFF448AFF)],
    },
    {
      'name':    'Paan',
      'role':    'Backend Developer',
      'desc':    'Developed database integration and application logic.',
      'icon':    Icons.storage_outlined,
      'rank':    'S-RANK',
      'badge':   '⚙️',
      'gradient': [Color(0xFF00B4D8), Color(0xFF0077B6)],
    },
    {
      'name':    'Safwan',
      'role':    'System Tester',
      'desc':    'Performed testing, debugging, and quality assurance.',
      'icon':    Icons.bug_report_outlined,
      'rank':    'A-RANK',
      'badge':   '🔍',
      'gradient': [Color(0xFFFF416C), Color(0xFFFF8C00)],
    },
    {
      'name':    'Cot',
      'role':    'Documentation Specialist',
      'desc':    'Managed project documentation and reporting.',
      'icon':    Icons.article_outlined,
      'rank':    'A-RANK',
      'badge':   '📋',
      'gradient': [Color(0xFF4CAF50), Color(0xFF00E5FF)],
    },
  ];

  // ── Role Icons ────────────────────────────────────────────
  static const Map<String, IconData> _roleIcons = {
    'UI Designer':               Icons.brush,
    'Backend Developer':         Icons.developer_mode,
    'System Tester':             Icons.verified_outlined,
    'Documentation Specialist':  Icons.description_outlined,
  };

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroBanner(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('DEVELOPMENT TEAM'),
                const SizedBox(height: 14),
                // Team Cards Grid
                GridView.builder(
                  shrinkWrap:   true,
                  physics:      const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:   2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing:  12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: _team.length,
                  itemBuilder: (_, i) => _buildTeamCard(_team[i]),
                ),
                const SizedBox(height: 26),
                _sectionLabel('PROJECT INFO'),
                const SizedBox(height: 14),
                _buildProjectInfo(),
                const SizedBox(height: 26),
                _buildTechStack(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero Banner ───────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A0A1A), Color(0xFF1A1040), Color(0xFF0A0A1A)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        boxShadow: AppTheme.purpleGlow,
      ),
      child: Column(
        children: [
          // Icon with glow
          Container(
            width:  80,
            height: 80,
            decoration: BoxDecoration(
              shape:     BoxShape.circle,
              gradient:  AppTheme.primaryGradient,
              boxShadow: AppTheme.purpleGlow,
            ),
            child: const Icon(Icons.groups, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Text(
              'SYSTEM DEVELOPERS',
              style: TextStyle(
                color:         Colors.white,
                fontSize:      24,
                fontWeight:    FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ShadowFit Development Team',
            style: TextStyle(
              color:       AppTheme.neonCyan.withOpacity(0.8),
              fontSize:    14,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Built with Flutter  ·  v1.0.0',
            style: TextStyle(
              color:    Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          // Decorative divider
          Row(
            children: [
              Expanded(
                child: Container(height: 1,
                    color: AppTheme.primaryPurple.withOpacity(0.3)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.shield,
                    color: AppTheme.neonPurple.withOpacity(0.5), size: 16),
              ),
              Expanded(
                child: Container(height: 1,
                    color: AppTheme.primaryPurple.withOpacity(0.3)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Team Card ─────────────────────────────────────────────
  Widget _buildTeamCard(Map<String, dynamic> member) {
    final colors = (member['gradient'] as List).cast<Color>();
    return Container(
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:       colors[0].withOpacity(0.3),
            blurRadius:  14,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: colors[0].withOpacity(0.35)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top gradient bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin:  Alignment.centerLeft,
                  end:    Alignment.centerRight,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Avatar
            Container(
              width:  72,
              height: 72,
              decoration: BoxDecoration(
                shape:     BoxShape.circle,
                gradient: LinearGradient(
                  colors: colors,
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:       colors[0].withOpacity(0.5),
                    blurRadius:  14,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                member['icon'] as IconData,
                color: Colors.white,
                size:  34,
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              member['name'] as String,
              style: const TextStyle(
                color:      Colors.white,
                fontSize:   15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors[0].withOpacity(0.8), colors[1].withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                member['role'] as String,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Rank badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:        colors[0].withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: colors[0].withOpacity(0.4)),
              ),
              child: Text(
                member['rank'] as String,
                style: TextStyle(
                  color:         colors[0],
                  fontSize:      9,
                  fontWeight:    FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                member['desc'] as String,
                textAlign: TextAlign.center,
                maxLines:  3,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  color:    AppTheme.textSecondary,
                  fontSize: 10,
                  height:   1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Project Info ──────────────────────────────────────────
  Widget _buildProjectInfo() {
    final items = [
      {'label': 'Project',  'value': 'ShadowFit',        'icon': Icons.apps},
      {'label': 'Version',  'value': '1.0.0',            'icon': Icons.tag},
      {'label': 'Platform', 'value': 'Flutter (Mobile)', 'icon': Icons.phone_android},
      {'label': 'Database', 'value': 'SQLite (sqflite)',  'icon': Icons.storage},
      {'label': 'Theme',    'value': 'Solo Leveling Dark', 'icon': Icons.style},
    ];
    return Container(
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
        boxShadow:    AppTheme.cardGlow,
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          final item   = e.value;
          return Column(
            children: [
              ListTile(
                dense: true,
                leading: Icon(item['icon'] as IconData,
                    color: AppTheme.neonPurple, size: 20),
                title: Text(item['label'] as String,
                    style: const TextStyle(
                        color:    AppTheme.textSecondary,
                        fontSize: 12)),
                trailing: Text(item['value'] as String,
                    style: const TextStyle(
                        color:      Colors.white,
                        fontSize:   13,
                        fontWeight: FontWeight.w600)),
              ),
              if (!isLast)
                Divider(height: 1,
                    color: Colors.white.withOpacity(0.05),
                    indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Tech Stack ────────────────────────────────────────────
  Widget _buildTechStack() {
    final techs = [
      {'label': 'Flutter',     'color': const Color(0xFF027DFD)},
      {'label': 'Dart',        'color': const Color(0xFF00B4D8)},
      {'label': 'SQLite',      'color': const Color(0xFF4CAF50)},
      {'label': 'sqflite',     'color': const Color(0xFF7B2FBE)},
      {'label': 'Material UI', 'color': const Color(0xFFFF416C)},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('TECH STACK'),
        const SizedBox(height: 12),
        Wrap(
          spacing:    8,
          runSpacing: 8,
          children: techs.map((t) {
            final col = t['color'] as Color;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:        col.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: col.withOpacity(0.45)),
                boxShadow: [
                  BoxShadow(
                      color:       col.withOpacity(0.2),
                      blurRadius:  8,
                      spreadRadius: 1),
                ],
              ),
              child: Text(
                t['label'] as String,
                style: TextStyle(
                  color:         col,
                  fontSize:      12,
                  fontWeight:    FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
