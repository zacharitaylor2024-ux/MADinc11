import 'package:flutter/material.dart';

import 'success_screen.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedCreatureType;

  bool _obscurePassword = true;

  DateTime? _birthDate;
  final _dateController = TextEditingController();

  // State field
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true); // potion starts brewing

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // user may have left the screen

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: _nameController.text.trim(),
          creatureType: _selectedCreatureType!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 👶 Child
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              //Birth Date
              TextFormField(
                controller: _dateController,
                readOnly: true, // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) =>
                    _birthDate == null ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(), // no future birthdays!
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Creature Type',
                  prefixIcon: Icon(Icons.auto_awesome),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Ghost', child: Text('Ghost')),
                  DropdownMenuItem(value: 'Bat', child: Text('Bat')),
                  DropdownMenuItem(
                    value: 'Black Cat',
                    child: Text('Black Cat'),
                  ),
                  DropdownMenuItem(
                    value: 'Pumpkin Spirit',
                    child: Text('Pumpkin Spirit'),
                  ),
                  DropdownMenuItem(value: 'Witch', child: Text('Witch')),
                ],
                onChanged: _submitting
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCreatureType = value;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a creature type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // 🚀 Sign Up Button
              ElevatedButton(
                onPressed: _submitting ? null : _submit, // null = disabled
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Register Creature',
                        style: TextStyle(fontSize: 18),
                      ),
              ),

              const SignupTip(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupTip extends StatefulWidget {
  const SignupTip({super.key});

  @override
  State<SignupTip> createState() => _SignupTipState();
}

class _SignupTipState extends State<SignupTip> {
  static const String _category = 'password_help';

  static const Map<String, List<String>> _tips = {
    'password_help': [
      'Do not be afraid to create a long complicated password, especially if you plan to save this password to a password manager.',
      'The most common password is "password", so do not use it.',
      'Including capital letters, numbers, and symbols can significantly increase the strength of your password.'
          'Once you make an account there will be a forgot password feature,  so make it as secure as possible.',
    ],
  };

  bool _loading = false;
  bool _failNextRequest = false;
  String? _tip;
  String? _error;
  int _nextTip = 0;

  Future<void> _getTip() async {
    if (_loading) return;

    final shouldFail = _failNextRequest;

    setState(() {
      _loading = true;
      _tip = null;
      _error = null;
      _failNextRequest = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    if (shouldFail) {
      setState(() {
        _loading = false;
        _error = 'Demo error: the tip could not be loaded. Try again.';
      });
      return;
    }

    final matchingTips = _tips[_category]!;
    final selectedTip = matchingTips[_nextTip % matchingTips.length];
    _nextTip++;

    setState(() {
      _loading = false;
      _tip = selectedTip.length <= 240
          ? selectedTip
          : selectedTip.substring(0, 240);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: _loading ? null : _getTip,
          child: Text(_loading ? 'Loading tip...' : 'Get a signup tip'),
        ),
        if (_loading) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
        if (_tip != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Preset demo tip—not live AI.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_tip!),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!),
          TextButton(
            onPressed: _loading ? null : _getTip,
            child: const Text('Retry'),
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Demo: fail the next tip request'),
          value: _failNextRequest,
          onChanged: _loading
              ? null
              : (value) {
                  setState(() {
                    _failNextRequest = value;
                  });
                },
        ),
      ],
    );
  }
}
