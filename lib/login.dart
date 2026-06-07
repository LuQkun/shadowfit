// ============================================================
// login.dart – Login Page (SQLite auth + session save)
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';
import 'database_helper.dart';
import 'session_manager.dart';
import 'bottom_nav.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey           = GlobalKey<FormState>();
  final _emailCtrl         = TextEditingController();
  final _passwordCtrl      = TextEditingController();
  bool _obscurePassword    = true;
  bool _isLoading          = false;
  String? _errorMessage;

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Login logic ──────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    final user = await DatabaseHelper.instance.loginUser(
      _emailCtrl.text,
      _passwordCtrl.text,
    );

    if (!mounted) return;

    if (user == null) {
      setState(() {
        _isLoading    = false;
        _errorMessage = 'Invalid email or password. Try again.';
      });
      return;
    }

    // Persist session
    await SessionManager.saveSession(
      userId:   user.id!,
      username: user.username,
    );

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:       (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildLogo(),
                const SizedBox(height: 18),
                _buildTitle(),
                const SizedBox(height: 44),
                _buildForm(),
                const SizedBox(height: 24),
                _buildRegisterLink(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────
  Widget _buildLogo() => Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          shape:     BoxShape.circle,
          gradient:  AppTheme.primaryGradient,
          boxShadow: AppTheme.purpleGlow,
        ),
        child: const Icon(Icons.shield, color: Colors.white, size: 50),
      );

  // ── Title ─────────────────────────────────────────────────
  Widget _buildTitle() => Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Text(
              'SHADOWFIT',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w900,
                  letterSpacing: 6, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '✦  Awaken Your Power  ✦',
            style: TextStyle(
                fontSize: 14, color: AppTheme.neonCyan.withOpacity(0.85),
                letterSpacing: 3),
          ),
        ],
      );

  // ── Form ──────────────────────────────────────────────────
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Icon(Icons.warning_amber_rounded,
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
          // Email
          _buildField(
            controller: _emailCtrl,
            label:      'Email',
            hint:       'hunter@shadowguild.my',
            icon:       Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@'))              return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password
          _buildField(
            controller:  _passwordCtrl,
            label:       'Password',
            hint:        '••••••••',
            icon:        Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.neonPurple, size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6)           return 'Minimum 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 28),
          // Submit button
          GestureDetector(
            onTap: _isLoading ? null : _login,
            child: Container(
              width:  double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient:     AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow:    AppTheme.purpleGlow,
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text(
                        'ENTER THE SYSTEM',
                        style: TextStyle(
                            color: Colors.white, fontSize: 15,
                            fontWeight: FontWeight.bold, letterSpacing: 2),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Register link ─────────────────────────────────────────
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('New hunter? ',
            style: TextStyle(
                color: Colors.white.withOpacity(0.45), fontSize: 13)),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
                color:      AppTheme.neonPurple,
                fontSize:   13,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

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
