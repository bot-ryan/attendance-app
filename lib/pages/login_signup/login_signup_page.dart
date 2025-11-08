// lib/pages/login_signup/login_signup_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // If user is already logged in somehow, don’t show login again
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Let GoRouter redirect handle it; this avoids a flash of the login UI.
      // No manual navigation needed, router will send them to /home.
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Realfun Attendance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login or create an account to continue',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  /// Prebuilt email/password login + signup + forgot password
                  SupaEmailAuth(
                    // For mobile deep link callback if you use email confirmations.
                    // For basic setups / dev, leaving this as-is is fine.
                    redirectTo: kIsWeb ? null : 'io.realfun.attendance://callback',

                    onSignInComplete: (response) {
                      // Auth state changes -> GoRouter listener will auto-redirect.
                      // You can show a small message if you want:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed in successfully')),
                      );
                    },
                    onSignUpComplete: (response) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account created. Check your email if confirmation is required.'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Optional: Social providers (only if configured in Supabase)
                  // SupaSocialsAuth(
                  //   socialProviders: const [
                  //     OAuthProvider.google,
                  //     OAuthProvider.github,
                  //   ],
                  //   onSuccess: (session) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('Signed in with social provider')),
                  //     );
                  //   },
                  //   onError: (error) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('Error: $error')),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
