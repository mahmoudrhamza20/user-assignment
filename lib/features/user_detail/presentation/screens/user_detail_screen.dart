import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/widgets/user_avatar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_navigator.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/error_widget.dart' as custom;
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/user_detail_cubit.dart';
import '../cubit/user_detail_state.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserDetailCubit>()..fetchUserDetail(userId),
      child: _UserDetailView(userId: userId),
    );
  }
}

class _UserDetailView extends StatefulWidget {
  final int userId;
  const _UserDetailView({required this.userId});

  @override
  State<_UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<_UserDetailView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    _firstNameController.addListener(() {
      context
          .read<UserDetailCubit>()
          .updateFirstName(_firstNameController.text);
    });
    _lastNameController.addListener(() {
      context.read<UserDetailCubit>().updateLastName(_lastNameController.text);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleEdit() {
    context.read<UserDetailCubit>().toggleEdit();
  }

  void _handleCancel() {
    final state = context.read<UserDetailCubit>().state;
    if (state is UserDetailLoaded) {
      _firstNameController.text = state.user.firstName;
      _lastNameController.text = state.user.lastName;
    }
    context.read<UserDetailCubit>().cancelUpdate();
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<UserDetailCubit>().updateUser(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.userDetails),
      ),
      body: BlocConsumer<UserDetailCubit, UserDetailState>(
        listener: (context, state) {
          if (state is UserDetailUpdateSuccess) {
            SnackBarUtils.showSuccess(context, AppStrings.updateSuccess);
            AppNavigator.pop(context);
          } else if (state is UserDetailUpdateError) {
            SnackBarUtils.showError(context, state.message);
          } else if (state is UserDetailLoaded) {
            // Update controllers if state has different values (e.g. after initial load)
            if (_firstNameController.text != state.firstName) {
              _firstNameController.text = state.firstName;
            }
            if (_lastNameController.text != state.lastName) {
              _lastNameController.text = state.lastName;
            }
          }
        },
        builder: (context, state) {
          if (state is UserDetailLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          if (state is UserDetailError) {
            return custom.ErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<UserDetailCubit>().fetchUserDetail(widget.userId);
              },
            );
          }

          if (state is UserDetailLoaded ||
              state is UserDetailUpdating ||
              state is UserDetailUpdateSuccess) {
            final user = state is UserDetailLoaded
                ? state.user
                : state is UserDetailUpdating
                    ? state.user
                    : (state as UserDetailUpdateSuccess).user;

            final isUpdating = state is UserDetailUpdating;
            final isEditing = state.isEditing;

            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // User Avatar
                    Center(
                      child: Hero(
                        tag: 'user-avatar-${user.id}',
                        child: UserAvatar(
                          imageUrl: user.avatar,
                          radius: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email (Read-only)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First Name
                    CustomTextField(
                      controller: _firstNameController,
                      label: AppStrings.firstName,
                      hint: 'Enter first name',
                      enabled: isEditing && !isUpdating,
                      validator: (value) =>
                          Validators.validateName(value, 'First name'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    CustomTextField(
                      controller: _lastNameController,
                      label: AppStrings.lastName,
                      hint: 'Enter last name',
                      enabled: isEditing && !isUpdating,
                      validator: (value) =>
                          Validators.validateName(value, 'Last name'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    if (isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: AppStrings.cancel,
                              onPressed: isUpdating ? null : _handleCancel,
                              isOutlined: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: AppStrings.save,
                              onPressed: isUpdating ? null : _handleUpdate,
                              isLoading: isUpdating,
                              icon: Icons.save,
                            ),
                          ),
                        ],
                      )
                    else
                      CustomButton(
                        text: AppStrings.editUser,
                        onPressed: _handleEdit,
                        icon: Icons.edit,
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
