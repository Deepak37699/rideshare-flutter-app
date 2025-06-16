import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// A customizable button widget.
///
/// This button can be configured as a primary (solid) button, an outlined button,
/// or a secondary styled button using the [isPrimary] flag. It also supports
/// an optional icon, loading state, and custom dimensions/colors.
class CustomButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state.
  ///
  /// If true, a circular progress indicator is shown instead of the text/icon.
  final bool isLoading;

  /// Whether the button should be an outlined button.
  final bool isOutlined;

  /// Whether the button should use primary styling.
  ///
  /// Defaults to true. If false, and [isOutlined] is also false,
  /// it will use a secondary styling (e.g., grey background).
  final bool isPrimary;

  /// The background color of the button.
  ///
  /// If null, the color is determined by [isPrimary] and [isOutlined].
  final Color? backgroundColor;

  /// The text color of the button.
  ///
  /// If null, the color is determined by [isPrimary] and [isOutlined].
  final Color? textColor;

  /// The width of the button.
  ///
  /// Defaults to `double.infinity`.
  final double? width;

  /// The height of the button.
  ///
  /// Defaults to `AppDimensions.buttonHeightM`.
  final double? height;

  /// An optional icon to display before the text.
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isPrimary = true,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? AppDimensions.buttonHeightM,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary,
            side: BorderSide(color: backgroundColor ?? AppColors.primary),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppDimensions.iconS),
                      const SizedBox(width: AppDimensions.paddingS),
                    ],
                    Text(text),
                  ],
                ),
        ),
      );
    }

    // Updated style for ElevatedButton based on isPrimary
    final Color effectiveBackgroundColor =
        backgroundColor ??
        (isPrimary
            ? AppColors.primary
            : Colors
                  .grey[200]!); // Using Colors.grey[200] as a secondary background
    final Color effectiveForegroundColor =
        textColor ??
        (isPrimary
            ? AppColors.textOnPrimary
            : AppColors
                  .primary); // Using AppColors.primary as secondary text color

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeightM,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppDimensions.iconS),
                    const SizedBox(width: AppDimensions.paddingS),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
