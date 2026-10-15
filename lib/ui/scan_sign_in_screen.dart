import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../theme/tokens.dart';
import '../util/sign_in_link.dart';
import 'widgets/common.dart';

/// Points the camera at the QR code the installer showed, and returns the
/// sign-in in it.
class ScanSignInScreen extends StatefulWidget {
  const ScanSignInScreen({super.key});

  /// Opens the scanner; null when the owner backs out.
  static Future<SignInLink?> open(BuildContext context) =>
      Navigator.push<SignInLink>(
        context,
        MaterialPageRoute(builder: (_) => const ScanSignInScreen()),
      );

  @override
  State<ScanSignInScreen> createState() => _ScanSignInScreenState();
}

class _ScanSignInScreenState extends State<ScanSignInScreen> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  var _done = false;
  var _notACode = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    for (final barcode in capture.barcodes) {
      final scan = SignInLink.parse(barcode.rawValue);
      if (scan != null) {
        _done = true;
        Navigator.pop(context, scan);
        return;
      }
    }
    if (!_notACode) setState(() => _notACode = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RmTopBar(
              title: 'Scan the sign-in code',
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
              child: Text(
                _notACode
                    ? "That QR code isn't a rest-mail sign-in. Point at the "
                          'one the installer showed.'
                    : 'Point the camera at the QR code the installer showed.',
                style: rmText(15, color: c.ink2, height: 1.45),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        error.errorCode ==
                                MobileScannerErrorCode.permissionDenied
                            ? 'rest-mail needs the camera to scan the code. '
                                  'Allow it in Settings, or type the password '
                                  'instead.'
                            : "The camera didn't start. Type the password "
                                  'instead.',
                        textAlign: TextAlign.center,
                        style: rmText(15, color: c.ink2, height: 1.45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
