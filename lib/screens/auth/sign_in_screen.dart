import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// A screen for users to sign in using email/password or Google Sign-In.
///
/// It provides form fields for email and password, along with buttons for
/// standard sign-in and Google Sign-In. It uses [AuthProvider] to handle
/// authentication logic and displays appropriate feedback to the user.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Attempts to sign in the user with email and password.
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigation is handled by the root MaterialApp based on auth state changes.
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Sign in failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Attempts to sign in the user with Google.
  Future<void> _signInWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      // Navigation is handled by the root MaterialApp based on auth state changes.
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Google Sign-in failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.paddingXXL),

              // Logo and welcome text
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: AppColors.white,
                        size: AppDimensions.iconXL,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    Text(
                      AppStrings.appName,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    Text(
                      AppStrings.appTagline,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXXL),

              // Sign in form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.signIn,
                      style: AppTypography.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),

                    CustomTextField(
                      controller: _emailController,
                      labelText: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    CustomTextField(
                      controller: _passwordController,
                      labelText: AppStrings.password,
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password
                        },
                        child: Text(AppStrings.forgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: AppStrings.signIn,
                          isLoading: authProvider.isLoading,
                          onPressed: _signIn,
                          // isPrimary is true by default
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Sign in with Google Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: AppStrings.signInWithGoogle,
                          isLoading: authProvider.isLoading,
                          onPressed: _signInWithGoogle,
                          icon: Icons
                              .login, // Example icon, replace if you have a Google icon
                          isPrimary:
                              false, // Set to false for secondary styling
                          // backgroundColor: AppColors.white, // Optional: if you want a specific background for Google button
                          // textColor: AppColors.textPrimary, // Optional: if you want a specific text color for Google button
                        );
                      },
                    ),

                    const SizedBox(height: AppDimensions.paddingXL),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.dontHaveAccount,
                          style: AppTypography.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sign up
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(AppStrings.signUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
