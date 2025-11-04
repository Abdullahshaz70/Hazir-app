import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'sign_up.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = 'Service Consumer';

  bool obscurePassword = true;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter email';
    if (!EmailValidator.validate(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('--- Login Form Values ---');
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('Password: ${passwordController.text}');
      debugPrint('Role: $role');
      debugPrint('--------------------------');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form values printed in console')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Column(
                      children: const [
                        Text(
                          'HAZIR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'bhai hazir hai!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Card with form
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email
                            const _FieldLabel(icon: Icons.email_outlined, label: 'Email'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(hint: 'Enter your email'),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 14),

                            // Password
                            const _FieldLabel(icon: Icons.lock_outline, label: 'Password'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: _inputDecoration(
                                hint: 'Enter your password',
                                suffix: IconButton(
                                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 14),

                            // Role
                            const _FieldLabel(icon: Icons.group_outlined, label: 'Role'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: role,
                              items: const [
                                DropdownMenuItem(value: 'Service Provider', child: Text('Service Provider')),
                                DropdownMenuItem(value: 'Service Consumer', child: Text('Service Consumer')),
                              ],
                              onChanged: (v) => setState(() => role = v ?? role),
                              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                            ),
                            const SizedBox(height: 18),

                            // Login button
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _onLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Don't have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      border: const OutlineInputBorder(),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FieldLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(icon, size: 18, color: accent),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}