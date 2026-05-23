import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loginCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;
    final result = await ref.read(authProvider.notifier).login(
      _loginCtrl.text.trim(),
      _passCtrl.text,
    );
    if (!mounted) return;
    if (result is ApiSuccess) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final t = Localizations.of<dynamic>(context, dynamic);

    return Scaffold(
      body: Column(
        children: [
          // Hero header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 32,
              bottom: 32,
              left: 24,
              right: 24,
            ),
            color: AppColors.primary,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'U',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Uellow Vendor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'إدارة متجرك في أي وقت ومكان',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Email field
                  TextField(
                    controller: _loginCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Email or username',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Password field
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Error
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        auth.error == 'invalid_credentials'
                            ? 'Invalid email or password'
                            : 'Network error. Check your connection.',
                        style: const TextStyle(color: AppColors.danger, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Sign in button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Forgot password
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
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
}
