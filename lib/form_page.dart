// ============================================================
// form_page.dart – Chapter 5 & 7: Workout Form + SQLite CRUD
// Updated: scoped to logged-in userId via SessionManager
// ============================================================

import 'package:flutter/material.dart';
import 'theme.dart';
import 'database_helper.dart';
import 'workout_model.dart';
import 'session_manager.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage>
    with SingleTickerProviderStateMixin {
  final _formKey            = GlobalKey<FormState>();
  final _nameController     = TextEditingController();
  final _muscleController   = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController    = TextEditingController();

  List<Workout> _workouts  = [];
  bool  _isLoading         = false;
  bool  _isSaving          = false;
  Workout? _editingWorkout;
  int   _userId            = 0; // loaded from session

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initUserId();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _muscleController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ── Load userId from session then fetch workouts ──────────
  Future<void> _initUserId() async {
    final id = await SessionManager.getUserId();
    setState(() => _userId = id ?? 0);
    await _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() => _isLoading = true);
    final list = await DatabaseHelper.instance.getWorkoutsByUser(_userId);
    setState(() { _workouts = list; _isLoading = false; });
  }

  // ── Submit (insert or update) ─────────────────────────────
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final workout = Workout(
      id:           _editingWorkout?.id,
      userId:       _userId,
      workoutName:  _nameController.text.trim(),
      targetMuscle: _muscleController.text.trim(),
      duration:     _durationController.text.trim(),
      notes:        _notesController.text.trim(),
    );

    if (_editingWorkout == null) {
      await DatabaseHelper.instance.insertWorkout(workout);
    } else {
      await DatabaseHelper.instance.updateWorkout(workout);
    }

    setState(() { _isSaving = false; _editingWorkout = null; });
    _clearForm();
    await _loadWorkouts();

    if (mounted) {
      _showSuccessDialog('Mission Logged!', 'Your workout has been saved.');
      _tabController.animateTo(1);
    }
  }

  void _editWorkout(Workout w) {
    setState(() {
      _editingWorkout         = w;
      _nameController.text     = w.workoutName;
      _muscleController.text   = w.targetMuscle;
      _durationController.text = w.duration;
      _notesController.text    = w.notes;
    });
    _tabController.animateTo(0);
  }

  Future<void> _deleteWorkout(Workout w) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => _buildConfirmDialog(w.workoutName),
    );
    if (confirm == true) {
      // Pass both id and userId for safe delete
      await DatabaseHelper.instance.deleteWorkout(w.id!, _userId);
      await _loadWorkouts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${w.workoutName} deleted.'),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _muscleController.clear();
    _durationController.clear();
    _notesController.clear();
    setState(() => _editingWorkout = null);
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.cardBg,
          child: TabBar(
            controller:          _tabController,
            indicatorColor:      AppTheme.neonPurple,
            indicatorWeight:     3,
            labelColor:          AppTheme.neonPurple,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 1),
            tabs: const [
              Tab(text: '  ADD MISSION  '),
              Tab(text: '  MY MISSIONS  '),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildFormTab(), _buildListTab()],
          ),
        ),
      ],
    );
  }

  // ── Form Tab ──────────────────────────────────────────────
  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_editingWorkout != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin:  const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color:        AppTheme.neonPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neonPurple.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: AppTheme.neonPurple, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Editing: ${_editingWorkout!.workoutName}',
                      style: const TextStyle(
                          color: AppTheme.neonPurple, fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearForm,
                    child: const Icon(Icons.close,
                        color: AppTheme.neonPurple, size: 18),
                  ),
                ],
              ),
            ),
          ],
          Container(
            padding:    const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:        AppTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow:    AppTheme.cardGlow,
              border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _formHeader(),
                  const SizedBox(height: 20),
                  _buildFormField(
                    controller: _nameController,
                    label:      'Workout Name',
                    hint:       'e.g. Shadow Push-Ups',
                    icon:       Icons.fitness_center,
                    validator:  (v) => v == null || v.trim().isEmpty
                        ? 'Workout name is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _muscleController,
                    label:      'Target Muscle',
                    hint:       'e.g. Chest, Back, Legs',
                    icon:       Icons.accessibility_new,
                    validator:  (v) => v == null || v.trim().isEmpty
                        ? 'Target muscle is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _durationController,
                    label:      'Duration',
                    hint:       'e.g. 45 min / 5 sets',
                    icon:       Icons.timer_outlined,
                    validator:  (v) => v == null || v.trim().isEmpty
                        ? 'Duration is required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _notesController,
                    label:      'Notes / Comments',
                    hint:       'Additional details...',
                    icon:       Icons.notes,
                    maxLines:   3,
                    validator:  (v) => v == null || v.trim().isEmpty
                        ? 'Notes cannot be empty' : null,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isSaving ? null : _submitForm,
                    child: Container(
                      width:  double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient:     AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:    AppTheme.purpleGlow,
                      ),
                      child: Center(
                        child: _isSaving
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(
                                _editingWorkout == null
                                    ? '▶  LOG MISSION'
                                    : '✔  UPDATE MISSION',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formHeader() => Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient:     AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.add_task, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LOG MISSION',
                  style: TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              Text('Record your training session',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      );

  // ── List Tab ──────────────────────────────────────────────
  Widget _buildListTab() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.neonPurple));
    }
    if (_workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center,
                size: 60, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 16),
            const Text('No missions logged yet.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Add your first workout above!',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.3), fontSize: 13)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadWorkouts,
      color:     AppTheme.neonPurple,
      child: ListView.builder(
        padding:   const EdgeInsets.all(16),
        itemCount: _workouts.length,
        itemBuilder: (_, i) => _buildWorkoutCard(_workouts[i]),
      ),
    );
  }

  Widget _buildWorkoutCard(Workout w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:        AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow:    AppTheme.cardGlow,
        border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient:     AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fitness_center,
                  color: Colors.white, size: 24),
            ),
            title: Text(w.workoutName,
                style: const TextStyle(color: Colors.white, fontSize: 15,
                    fontWeight: FontWeight.bold)),
            subtitle: Text(w.targetMuscle,
                style: TextStyle(
                    color: AppTheme.neonCyan.withOpacity(0.7), fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppTheme.neonPurple, size: 20),
                  onPressed: () => _editWorkout(w),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 20),
                  onPressed: () => _deleteWorkout(w),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Wrap(
              spacing: 8, runSpacing: 6,
              children: [
                _infoPill(Icons.timer_outlined, w.duration, AppTheme.neonCyan),
                if (w.notes.isNotEmpty)
                  _infoPill(Icons.notes,
                      w.notes.length > 28
                          ? '${w.notes.substring(0, 28)}…'
                          : w.notes,
                      AppTheme.neonPurple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPill(IconData icon, String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:        color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Text(text,
                style: TextStyle(color: color, fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _buildFormField({
    required TextEditingController controller,
    required String                label,
    required String                hint,
    required IconData              icon,
    int                            maxLines = 1,
    String? Function(String?)?     validator,
  }) =>
      TextFormField(
        controller: controller,
        maxLines:   maxLines,
        style:      const TextStyle(color: Colors.white),
        validator:  validator,
        decoration: InputDecoration(
          labelText:  label,
          hintText:   hint,
          hintStyle:  TextStyle(color: Colors.white.withOpacity(0.2)),
          prefixIcon: Icon(icon, color: AppTheme.neonPurple, size: 20),
        ),
      );

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                shape:     BoxShape.circle,
                gradient:  AppTheme.primaryGradient,
                boxShadow: AppTheme.purpleGlow,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  gradient:     AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('CONTINUE',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmDialog(String name) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Mission?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete "$name"? This cannot be undone.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL',
                style: TextStyle(color: AppTheme.neonPurple)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('DELETE'),
          ),
        ],
      );
}
