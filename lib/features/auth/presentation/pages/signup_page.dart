import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/utils/validators.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/app_text_field.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final nameError = Validators.name(_name.text);
    final emailError = Validators.email(_email.text);
    final passwordError = Validators.password(_password.text);
    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (nameError != null || emailError != null || passwordError != null) {
      return;
    }
    _auth.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: const Text('Create account')),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Join Lovia', style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create an account to start chatting. 18+ only.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _name,
              label: 'Name',
              hint: 'Your display name',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              errorText: _nameError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _email,
              label: 'Email',
              hint: 'you@example.com',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              errorText: _emailError,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _password,
              label: 'Password',
              hint: 'At least 6 characters',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              errorText: _passwordError,
              suffix: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Obx(
              () => GradientButton(
                label: 'Create account',
                isLoading: _auth.isBusy.value,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
