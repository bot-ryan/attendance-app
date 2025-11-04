import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  static String routeName = 'loginSignup';
  static String routePath = 'loginSignup';

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>
    with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  // Login controllers
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginPwVisible = false;

  // Register controllers
  final _regName = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();
  final _regConfirm = TextEditingController();
  bool _regPwVisible = false;
  bool _regConfirmVisible = false;

  // Forms
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tabs.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _regName.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    _regConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: cs.primary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo / Brand
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSll_6fAcb6Vcm66MnuYZUizrlD1QUs7vaP2w&s',
                        width: 120,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          width: 120,
                          height: 110,
                          child: ColoredBox(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Wordmark placeholder
                    SizedBox(
                      height: 48,
                      child: Image.asset(
                        'assets/images/Class_Attendance.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Card shell with tabs
                    Card(
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            // Tabs
                            TabBar(
                              controller: _tabs,
                              isScrollable: true,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: cs.primary,
                              unselectedLabelColor: cs.onSurface.withValues(alpha: .6),
                              indicator: UnderlineTabIndicator(
                                borderSide:
                                    BorderSide(color: cs.primary, width: 3),
                                insets:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              tabs: const [
                                Tab(text: 'Log In'),
                                Tab(text: 'Register'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Forms
                            SizedBox(
                              height: 520, // keeps height consistent while switching tabs
                              child: TabBarView(
                                controller: _tabs,
                                children: [
                                  // ------- LOGIN -------
                                  Form(
                                    key: _loginFormKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        _Input(
                                          label: 'Email address',
                                          hint: 'you@example.com',
                                          controller: _loginEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autofillHints: const [
                                            AutofillHints.username,
                                            AutofillHints.email
                                          ],
                                          validator: _requiredEmail,
                                        ),
                                        const SizedBox(height: 12),
                                        _Input(
                                          label: 'Password',
                                          hint: 'Enter your password',
                                          controller: _loginPassword,
                                          obscureText: !_loginPwVisible,
                                          autofillHints: const [
                                            AutofillHints.password
                                          ],
                                          suffix: IconButton(
                                            onPressed: () => setState(() {
                                              _loginPwVisible = !_loginPwVisible;
                                            }),
                                            icon: Icon(_loginPwVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                          validator: _requiredText,
                                        ),
                                        const SizedBox(height: 4),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {}, // UI only
                                            child: const Text('Forgot password?'),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _PrimaryButton(
                                          text: 'Log In',
                                          onPressed: () {
                                            if (_loginFormKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              // UI-only placeholder
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text('Log In tapped'),
                                              ));
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        const _DividerText(text: 'or continue with'),
                                        const SizedBox(height: 12),
                                        const _AuthChipsRow(),
                                      ],
                                    ),
                                  ),

                                  // ------- REGISTER -------
                                  Form(
                                    key: _registerFormKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        _Input(
                                          label: 'Display name',
                                          hint: 'Your name',
                                          controller: _regName,
                                          autofillHints: const [
                                            AutofillHints.name
                                          ],
                                          validator: _requiredText,
                                        ),
                                        const SizedBox(height: 12),
                                        _Input(
                                          label: 'Email address',
                                          hint: 'you@example.com',
                                          controller: _regEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          validator: _requiredEmail,
                                        ),
                                        const SizedBox(height: 12),
                                        _Input(
                                          label: 'Password',
                                          hint: 'Create a password',
                                          controller: _regPassword,
                                          obscureText: !_regPwVisible,
                                          autofillHints: const [
                                            AutofillHints.newPassword
                                          ],
                                          suffix: IconButton(
                                            onPressed: () => setState(() {
                                              _regPwVisible = !_regPwVisible;
                                            }),
                                            icon: Icon(_regPwVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                          validator: _requiredText,
                                        ),
                                        const SizedBox(height: 12),
                                        _Input(
                                          label: 'Confirm password',
                                          hint: 'Retype your password',
                                          controller: _regConfirm,
                                          obscureText: !_regConfirmVisible,
                                          autofillHints: const [
                                            AutofillHints.newPassword
                                          ],
                                          suffix: IconButton(
                                            onPressed: () => setState(() {
                                              _regConfirmVisible =
                                                  !_regConfirmVisible;
                                            }),
                                            icon: Icon(_regConfirmVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          ),
                                          validator: (v) {
                                            final base = _requiredText(v);
                                            if (base != null) return base;
                                            if (v != _regPassword.text) {
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _PrimaryButton(
                                          text: 'Create account',
                                          onPressed: () {
                                            if (_registerFormKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Create account tapped'),
                                              ));
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        const _DividerText(text: 'or sign up with'),
                                        const SizedBox(height: 12),
                                        const _AuthChipsRow(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Terms / footer
                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy (which does not exist yet).',
                      style: text.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: .9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Simple validators (UI only) ---
  static String? _requiredText(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  static String? _requiredEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
    }
}

// ===== Reusable UI bits =====

class _Input extends StatelessWidget {
  const _Input({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
    this.validator,
    this.autofillHints,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: cs.primary,
          backgroundColor: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Expanded(child: Divider(color: onSurface.withValues(alpha: .2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: TextStyle(color: onSurface.withValues(alpha: .6))),
        ),
        Expanded(child: Divider(color: onSurface.withValues(alpha: .2))),
      ],
    );
  }
}

class _AuthChipsRow extends StatelessWidget {
  const _AuthChipsRow();

  @override
  Widget build(BuildContext context) {
    //final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 12,
      children: [
        _AuthChip(icon: Icons.g_mobiledata, label: 'Google', onTap: () {
          //implement in the future
        })
      ],
    );
  }
}

class _AuthChip extends StatelessWidget {
  const _AuthChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return ActionChip(
      avatar: Icon(icon, size: 20),
      label: Text(label),
      labelStyle: TextStyle(color: onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onTap, // UI only
      backgroundColor: Colors.white,
    );
  }
}
