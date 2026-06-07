// ============================================================
// main.dart – App Entry (checks session → auto-login or Login)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'session_manager.dart';
import 'login.dart';
import 'bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:                    Colors.transparent,
    statusBarIconBrightness:           Brightness.light,
    systemNavigationBarColor:          AppTheme.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ShadowFitApp());
}

class ShadowFitApp extends StatelessWidget {
  const ShadowFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                    'ShadowFit',
      debugShowCheckedModeBanner: false,
      theme:                    AppTheme.darkTheme,
      // ── Auto-restore session ─────────────────────────────
      home: FutureBuilder<bool>(
        future: SessionManager.isLoggedIn(),
        builder: (context, snap) {
          // Show splash while checking
          if (!snap.hasData) {
            return const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.neonPurple),
              ),
            );
          }
          // Route based on session
          return snap.data! ? const MainScreen() : const LoginPage();
        },
      ),
    );
  }
}
