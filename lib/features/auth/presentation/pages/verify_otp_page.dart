import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovia/core/routing/app_routes.dart';
import 'package:lovia/core/theme/app_spacing.dart';
import 'package:lovia/core/utils/validators.dart';
import 'package:lovia/core/widgets/app_scaffold.dart';
import 'package:lovia/core/widgets/app_text_field.dart';
import 'package:lovia/core/widgets/gradient_button.dart';
import 'package:lovia/features/auth/presentation/controllers/auth_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _otp = TextEditingController();
  late final String _email = (Get.arguments as String?) ?? '';
  String? _error;

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final error = Validators.otp(_otp.text);
    setState(() => _error = error);
    if (error != null) return;
    final otp = _otp.text.trim();
    final ok = await _auth.verifyOtp(email: _email, otp: otp);
    if (ok) {
      await Get.toNamed<void>(
        AppRoutes.resetPassword,
        arguments: {'email': _email, 'otp': otp},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(title: const Text('Verify code')),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Enter the code', style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'We sent a 6-digit code to $_email.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _otp,
              label: 'OTP',
              hint: '123456',
              prefixIcon: Icons.pin_rounded,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              errorText: _error,
            ),
            const SizedBox(height: AppSpacing.xl),
            Obx(
              () => GradientButton(
                label: 'Verify',
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
