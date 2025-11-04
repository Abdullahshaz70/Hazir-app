import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'login.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  String countryCode = '+92 (PK)';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  String role = 'Service Consumer';

  bool obscurePassword = true;
  bool obscureConfirm = true;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter email';
    if (!EmailValidator.validate(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';

    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Must contain at least one uppercase letter';

    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Must contain at least one lowercase letter';

    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Must contain at least one numeric character';

    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passConfirmController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('--- SignUp Form Values ---');
      debugPrint('Full Name: ${nameController.text.trim()}');
      debugPrint('Country Code: $countryCode');
      debugPrint('Phone: ${phoneController.text.trim()}');
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
                            // Full Name
                            const _FieldLabel(icon: Icons.person_outline, label: 'Full Name'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: nameController,
                              decoration: _inputDecoration(hint: 'Enter your full name'),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                            ),
                            const SizedBox(height: 14),

                            // Phone number with country dropdown
                            const _FieldLabel(icon: Icons.phone, label: 'Phone Number'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    ),
                                    child: CountryCodePicker(
                                      onChanged: (country) => setState(() {
                                        countryCode = '${country.dialCode} (${country.code})';
                                      }),
                                      initialSelection: 'PK',
                                      favorite: const ['+92', 'PK'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: _inputDecoration(hint: 'e.g., 300 1234567'),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Please enter phone number';
                                      if (v.trim().length < 11) return 'Enter a valid phone number';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

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

                            // Confirm Password
                            const _FieldLabel(icon: Icons.lock_outline, label: 'Confirm Password'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: passConfirmController,
                              obscureText: obscureConfirm,
                              decoration: _inputDecoration(
                                hint: 'Re-enter your password',
                                suffix: IconButton(
                                  icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                                ),
                              ),
                              validator: (v) {
                                final basic = _validatePassword(v);
                                if (basic != null) return basic;
                                if (v != passwordController.text) return 'Passwords do not match';
                                return null;
                              },
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

                            // Sign Up button
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _onSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Already have account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Log In'),
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