// ============================================================
// register.dart – Register Page (new account → SQLite)
// ============================================================

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'theme.dart';
import 'database_helper.dart';
import 'session_manager.dart';
import 'user_model.dart';
import 'bottom_nav.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey        = GlobalKey<FormState>();
  final _usernameCtrl   = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool  _obscurePass    = true;
  bool  _obscureConfirm = true;
  bool  _isLoading      = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Register logic ────────────────────────────────────────
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    // Check for duplicate email before inserting
    final existing = await DatabaseHelper.instance
        .getUserByEmail(_emailCtrl.text.trim().toLowerCase());

    if (existing != null) {
      setState(() {
        _isLoading    = false;
        _errorMessage = 'An account with this email already exists.';
      });
      return;
    }

    try {
      final newId = await DatabaseHelper.instance.registerUser(
        User(
          username: _usernameCtrl.text.trim(),
          email:    _emailCtrl.text.trim().toLowerCase(),
          password: _passwordCtrl.text,
        ),
      );

      // Auto-login after successful registration
      await SessionManager.saveSession(
        userId:   newId,
        username: _usernameCtrl.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder:       (_, __, ___) => const MainScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (_) => false,
      );
    } on DatabaseException catch (e) {
      setState(() {
        _isLoading    = false;
        _errorMessage = e.isUniqueConstraintError()
            ? 'Email already in use.'
            : 'Registration failed. Please try again.';
      });
    } catch (_) {
      setState(() {
        _isLoading    = false;
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:       0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.neonPurple, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 36),
              _buildForm(),
              const SizedBox(height: 20),
              _buildLoginLink(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() => Column(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape:     BoxShape.circle,
              gradient:  AppTheme.cyanGradient,
              boxShadow: AppTheme.cyanGlow,
            ),
            child: const Icon(Icons.person_add_outlined,
                color: Colors.white, size: 38),
          ),
          const SizedBox(height: 16),
          const Text(
            'CREATE ACCOUNT',
            style: TextStyle(
                color: Colors.white, fontSize: 24,
                fontWeight: FontWeight.w900, letterSpacing: 3),
          ),
          const SizedBox(height: 6),
          Text(
            'Begin your hunter journey',
            style: TextStyle(
                color: AppTheme.neonCyan.withOpacity(0.7),
                fontSize: 13, letterSpacing: 1.5),
          ),
        ],
      );

  // ── Form ──────────────────────────────────────────────────
  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow:    AppTheme.cardGlow,
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.25)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Error banner
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:        Colors.redAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Username
            _buildField(
              controller: _usernameCtrl,
              label:      'Username',
              hint:       'Your hunter name',
              icon:       Icons.person_outline,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Username is required';
                if (v.trim().length < 3) return 'Minimum 3 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            // Email
            _buildField(
              controller:  _emailCtrl,
              label:       'Email',
              hint:        'hunter@shadowguild.my',
              icon:        Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@') || !v.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            // Password
            _buildField(
              controller:  _passwordCtrl,
              label:       'Password',
              hint:        'Min. 6 characters',
              icon:        Icons.lock_outline,
              obscureText: _obscurePass,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.neonPurple, size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePass = !_obscurePass),
              ),
              validator: (v) {
                if (v == null || v.isEmpty)  return 'Password is required';
                if (v.length < 6)             return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 14),
            // Confirm Password
            _buildField(
              controller:  _confirmCtrl,
              label:       'Confirm Password',
              hint:        'Re-enter password',
              icon:        Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.neonPurple, size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm password';
                if (v != _passwordCtrl.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 26),
            // Submit
            GestureDetector(
              onTap: _isLoading ? null : _register,
              child: Container(
                width:  double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient:     AppTheme.cyanGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow:    AppTheme.cyanGlow,
                ),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text(
                          'AWAKEN & REGISTER',
                          style: TextStyle(
                              color: Colors.white, fontSize: 14,
                              fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Login link ────────────────────────────────────────────
  Widget _buildLoginLink() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already a hunter? ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45), fontSize: 13)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Sign In',
              style: TextStyle(
                  color: AppTheme.neonPurple, fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );

  // ── Reusable TextField ────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String                label,
    required String                hint,
    required IconData              icon,
    bool                           obscureText  = false,
    TextInputType                  keyboardType = TextInputType.text,
    Widget?                        suffixIcon,
    String? Function(String?)?     validator,
  }) =>
      TextFormField(
        controller:   controller,
        obscureText:  obscureText,
        keyboardType: keyboardType,
        style:        const TextStyle(color: Colors.white),
        validator:    validator,
        decoration: InputDecoration(
          labelText:  label,
          hintText:   hint,
          hintStyle:  TextStyle(color: Colors.white.withOpacity(0.2)),
          prefixIcon: Icon(icon, color: AppTheme.neonPurple, size: 20),
          suffixIcon: suffixIcon,
        ),
      );
}
