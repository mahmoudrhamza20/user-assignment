import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/features/auth/presentation/screens/widgets/credential_row.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  void _handleLogin(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    if (_formKey.currentState!.validate()) {
      cubit.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            SnackBarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo/Icon
                      const Icon(
                        Icons.person_outline,
                        size: 100,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),

                      // Title
                      const Text(
                        AppStrings.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      CustomTextField(
                        controller: cubit.emailController,
                        label: AppStrings.email,
                        hint: AppStrings.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: Validators.validateEmail,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        controller: cubit.passwordController,
                        label: AppStrings.password,
                        hint: AppStrings.passwordHint,
                        obscureText: state.obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            cubit.togglePasswordVisibility();
                          },
                        ),
                        validator: Validators.validatePassword,
                        enabled: !isLoading,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(context),
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      CustomButton(
                        text: AppStrings.login,
                        onPressed: () => _handleLogin(context),
                        isLoading: isLoading,
                        icon: Icons.login,
                      ),
                      const SizedBox(height: 24),

                      // Demo Credentials Info
                      Container(
                        padding: const EdgeInsetsDirectional.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryLight),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.primaryDark,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Demo Credentials',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            CredentialRow(
                              label: 'Email',
                              value: 'eve.holt@reqres.in',
                            ),
                            SizedBox(height: 8),
                            CredentialRow(
                              label: 'Password',
                              value: 'cityslicka',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
