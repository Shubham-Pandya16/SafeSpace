import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';

enum SnackBarType { success, error, info, warning }

class FloatingSnackbar extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback? onDismiss;

  const FloatingSnackbar({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<FloatingSnackbar> createState() => _FloatingSnackbarState();
}

class _FloatingSnackbarState extends State<FloatingSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onDismiss?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return AppColors.green;
      case SnackBarType.error:
        return const Color(0xFFE63946);
      case SnackBarType.warning:
        return const Color(0xFFFFC107);
      case SnackBarType.info:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.error_rounded;
      case SnackBarType.warning:
        return Icons.warning_rounded;
      case SnackBarType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getBackgroundColor().withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _animationController.reverse();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                            widget.onDismiss?.call();
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
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
}
