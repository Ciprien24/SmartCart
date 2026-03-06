import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/core/user_profile.dart';
import 'package:smart_cart/core/user_profile_store.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  static const Color _pageBackground = Color(0xFFF4F5F9);
  static const Color _headerBlue = Color(0xFF1800AD);
  static const Color _accentOrange = Color(0xFFFF751F);
  static const Color _textDark = Color(0xFF141414);
  static const Color _textMuted = Color(0xFF74788C);

  static const List<String> _goals = <String>[
    'Lose weight',
    'Maintain',
    'Build muscle',
    'Improve health',
  ];

  static const List<String> _sexOptions = <String>[
    'Male',
    'Female',
    'Prefer not to say',
  ];

  static const List<String> _activityLevels = <String>[
    'Low',
    'Moderate',
    'High',
    'Very high',
  ];

  final UserProfileStore _store = UserProfileStore();

  bool _loading = true;
  bool _saving = false;

  int _age = 25;
  double _heightCm = 170;
  String _goal = _goals[1];
  String _sex = _sexOptions[2];
  String _activityLevel = _activityLevels[1];
  String _foodRestrictions = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _store.load();
    if (!mounted) return;
    setState(() {
      _age = profile.age;
      _heightCm = profile.heightCm;
      _goal = profile.goal;
      _sex = profile.sex;
      _activityLevel = profile.activityLevel;
      _foodRestrictions = profile.foodRestrictions;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);

    final profile = UserProfile(
      age: _age.clamp(1, 120),
      heightCm: _heightCm.clamp(60, 250),
      goal: _goal,
      sex: _sex,
      activityLevel: _activityLevel,
      foodRestrictions: _foodRestrictions.trim(),
    );

    await _store.save(profile);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(color: const Color(0xFFFFE2CF), width: 1),
          ),
          child: const Row(
            children: [
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: _accentOrange,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Profile saved',
                style: TextStyle(
                  color: _textDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double topInset) {
    return Container(
      height: 150 + topInset,
      padding: EdgeInsets.fromLTRB(24, topInset + 2, 24, 0),
      decoration: const BoxDecoration(color: _headerBlue),
      child: const Align(
        alignment: Alignment(0, -0.45),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image(
                image: AssetImage('lib/app/assets/logo_smart_cart.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'SmartCart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _textDark,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _fieldRow({
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: _accentOrange,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectionSheet({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onSelect,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        onSelect(option);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: option == current
                              ? const Color(0xFFFBE2CF)
                              : const Color(0xFFF2F3F8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNumberSheet({
    required String title,
    required String initialValue,
    required ValueChanged<String> onApply,
    bool decimal = false,
  }) async {
    final controller = TextEditingController(text: initialValue);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType: decimal
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2F3F8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      onApply(controller.text.trim());
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
  }

  Future<void> _showRestrictionsSheet() async {
    final controller = TextEditingController(text: _foodRestrictions);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Food Restrictions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'e.g. lactose-free, no pork, peanut allergy',
                    hintStyle: const TextStyle(
                      color: _textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF2F3F8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      setState(() => _foodRestrictions = controller.text.trim());
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
  }

  Widget _actionBubble({
    required IconData icon,
    required VoidCallback? onTap,
    Widget? child,
  }) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(color: _accentOrange, shape: BoxShape.circle),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: child ??
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _pageBackground,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: _pageBackground),
          _buildHeader(topInset),
          Positioned(
            top: 110 + topInset,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
              ),
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: _accentOrange),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _valueCard(
                            title: 'Age',
                            child: _fieldRow(
                              value: '$_age years',
                              onTap: () => _showNumberSheet(
                                title: 'Age',
                                initialValue: _age.toString(),
                                onApply: (value) {
                                  final parsed = int.tryParse(value);
                                  if (parsed != null) {
                                    setState(() => _age = parsed.clamp(1, 120));
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _valueCard(
                            title: 'Height (cm)',
                            child: _fieldRow(
                              value: '${_heightCm.toStringAsFixed(0)} cm',
                              onTap: () => _showNumberSheet(
                                title: 'Height (cm)',
                                initialValue: _heightCm.toStringAsFixed(0),
                                decimal: true,
                                onApply: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null) {
                                    setState(() => _heightCm = parsed.clamp(60, 250));
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _valueCard(
                            title: 'Goal',
                            child: _fieldRow(
                              value: _goal,
                              onTap: () => _showSelectionSheet(
                                title: 'Goal',
                                options: _goals,
                                current: _goal,
                                onSelect: (value) => setState(() => _goal = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _valueCard(
                            title: 'Sex',
                            child: _fieldRow(
                              value: _sex,
                              onTap: () => _showSelectionSheet(
                                title: 'Sex',
                                options: _sexOptions,
                                current: _sex,
                                onSelect: (value) => setState(() => _sex = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _valueCard(
                            title: 'Activity Level',
                            child: _fieldRow(
                              value: _activityLevel,
                              onTap: () => _showSelectionSheet(
                                title: 'Activity Level',
                                options: _activityLevels,
                                current: _activityLevel,
                                onSelect: (value) =>
                                    setState(() => _activityLevel = value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _valueCard(
                            title: 'Food Restrictions',
                            child: _fieldRow(
                              value: _foodRestrictions.isEmpty
                                  ? 'None'
                                  : _foodRestrictions,
                              onTap: _showRestrictionsSheet,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionBubble(
                  icon: CupertinoIcons.back,
                  onTap: () => Navigator.maybePop(context),
                ),
                _actionBubble(
                  icon: CupertinoIcons.check_mark,
                  onTap: _saving ? null : _saveProfile,
                  child: _saving
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
