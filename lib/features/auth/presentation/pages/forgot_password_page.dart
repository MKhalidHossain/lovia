import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/utils/validators.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/app_text_field.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _email = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final error = Validators.email(_email.text);
    setState(() => _error = error);
    if (error != null) return;
    final email = _email.text.trim();
    final ok = await _auth.requestPasswordReset(email);
    if (ok) await Get.toNamed<void>(AppRoutes.verifyOtp, arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: const Text('Reset password')),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Forgot password?', style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Enter your email and we'll send you a 6-digit code.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _email,
              label: 'Email',
              hint: 'you@example.com',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              errorText: _error,
            ),
            const SizedBox(height: AppSpacing.xl),
            Obx(
              () => GradientButton(
                label: 'Send code',
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
