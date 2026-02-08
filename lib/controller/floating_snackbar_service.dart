import 'package:flutter/material.dart';
import 'package:safe_space/view/widgets/floating_snackbar.dart';

class FloatingSnackbarService {
  static final FloatingSnackbarService _instance = FloatingSnackbarService._internal();

  factory FloatingSnackbarService() {
    return _instance;
  }

  FloatingSnackbarService._internal();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    _show(
      context,
      message,
      SnackBarType.success,
      duration,
      onDismiss,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
  }) {
    _show(
      context,
      message,
      SnackBarType.error,
      duration,
      onDismiss,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    _show(
      context,
      message,
      SnackBarType.warning,
      duration,
      onDismiss,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    _show(
      context,
      message,
      SnackBarType.info,
      duration,
      onDismiss,
    );
  }

  static void _show(
    BuildContext context,
    String message,
    SnackBarType type,
    Duration duration,
    VoidCallback? onDismiss,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => FloatingSnackbar(
        message: message,
        type: type,
        duration: duration,
        onDismiss: onDismiss,
      ),
    );
  }
}
