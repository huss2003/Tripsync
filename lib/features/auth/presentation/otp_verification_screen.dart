import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../presentation/auth_notifier.dart';

/// C.3 OTP Verification — 6-digit code entry.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen> {
  final _codeCtrl = TextEditingController();
  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSeconds == 0) {
        _timer?.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final colors = Theme.of(context).extension<TripSyncColors>()!;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text('Enter the code sent to',
                  style: Theme.of(context).textTheme.headlineLarge),
              Text('+91 ${widget.phone}',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '000000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colors.borderDefault),
                  ),
                ),
                onChanged: (v) {
                  if (v.length == 6) {
                    ref
                        .read(authNotifierProvider.notifier)
                        .verifyOtp(v);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Resend in $_resendSeconds',
                    style: TextStyle(color: colors.textSecondary)),
                if (_resendSeconds == 0)
                  TextButton(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .sendOtp('+91${widget.phone}');
                      _startResendTimer();
                    },
                    child: const Text('Resend'),
                  ),
              ]),
              if (authState.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(authState.errorMessage!,
                    style: TextStyle(color: colors.statusError)),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
