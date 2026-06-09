import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static const _storage = FlutterSecureStorage();

  static const _pinKey        = 'kash_pin_hash';
  static const _authEnabled   = 'kash_auth_enabled';
  static const _failedKey     = 'kash_failed_attempts';
  static const _lockUntilKey  = 'kash_lock_until';
  static const _captureKey    = 'kash_block_capture';

  static Future<bool> get biometricAvailable async {
    return await _localAuth.canCheckBiometrics &&
           await _localAuth.isDeviceSupported();
  }

  static Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Accede a tus finanzas en Kash',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  static Future<void> savePin(String pin) async {
    final hash = sha256
        .convert(utf8.encode('$pin-kash-salt-v1'))
        .toString();
    await _storage.write(key: _pinKey, value: hash);
    await _storage.write(key: _authEnabled, value: 'true');
    await _storage.delete(key: _failedKey);
    await _storage.delete(key: _lockUntilKey);
  }

  static Future<PinResult> verifyPin(String pin) async {
    final lockUntil = await _storage.read(key: _lockUntilKey);
    if (lockUntil != null) {
      final until = DateTime.parse(lockUntil);
      if (DateTime.now().isBefore(until)) {
        final secs = until.difference(DateTime.now()).inSeconds;
        return PinResult.locked(secs);
      }
    }

    final hash = sha256
        .convert(utf8.encode('$pin-kash-salt-v1'))
        .toString();
    final saved = await _storage.read(key: _pinKey);

    if (hash == saved) {
      await _storage.delete(key: _failedKey);
      await _storage.delete(key: _lockUntilKey);
      return PinResult.success();
    }

    final fails = int.parse(await _storage.read(key: _failedKey) ?? '0') + 1;
    await _storage.write(key: _failedKey, value: fails.toString());

    if (fails >= 5) {
      final until = DateTime.now().add(const Duration(seconds: 30));
      await _storage.write(key: _lockUntilKey, value: until.toIso8601String());
      await _storage.delete(key: _failedKey);
      return PinResult.locked(30);
    }

    return PinResult.wrong(5 - fails);
  }

  static Future<bool> get isEnabled async {
    return await _storage.read(key: _authEnabled) == 'true';
  }

  static Future<void> disable() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _authEnabled);
    await _storage.delete(key: _failedKey);
    await _storage.delete(key: _lockUntilKey);
  }

  static Future<bool> get blockCapture async {
    return await _storage.read(key: _captureKey) != 'false';
  }

  static Future<void> setBlockCapture(bool value) async {
    await _storage.write(key: _captureKey, value: value ? 'true' : 'false');
  }
}

class PinResult {
  final bool ok;
  final bool locked;
  final int? lockedSeconds;
  final int? remainingAttempts;

  PinResult._({
    this.ok = false,
    this.locked = false,
    this.lockedSeconds,
    this.remainingAttempts,
  });

  factory PinResult.success()           => PinResult._(ok: true);
  factory PinResult.wrong(int left)     => PinResult._(remainingAttempts: left);
  factory PinResult.locked(int seconds) => PinResult._(locked: true, lockedSeconds: seconds);
}
