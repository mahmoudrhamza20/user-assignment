import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/constants/app_strings.dart';
import 'package:user_management_app/core/di/dependency_injection.dart';
import 'package:user_management_app/core/widgets/error_widget.dart' as custom;
import 'package:user_management_app/core/widgets/loading_widget.dart';
import 'package:user_management_app/core/widgets/user_card.dart';
import 'package:user_management_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:user_management_app/features/user_detail/presentation/screens/user_detail_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_navigator.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UsersCubit>()..fetchUsers(),
      child: const _UsersListView(),
    );
  }
}

class _UsersListView extends StatefulWidget {
  const _UsersListView();

  @override
  State<_UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<_UsersListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UsersCubit>().loadMoreUsers();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.users),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          if (state is UsersError) {
            return custom.ErrorWidget(
              message: state.message,
              onRetry: () => context.read<UsersCubit>().fetchUsers(),
            );
          }

          if (state is UsersLoaded || state is UsersRefreshing) {
            final users = state is UsersLoaded
                ? state.users
                : (state as UsersRefreshing).users;

            if (users.isEmpty) {
              return const custom.ErrorWidget(
                message: AppStrings.noUsers,
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<UsersCubit>().refreshUsers(),
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index >= users.length) {
                    return _buildLoadMoreIndicator(state);
                  }

                  final user = users[index];
                  return UserCard(
                    user: user,
                    onTap: () {
                      AppNavigator.push(
                        context,
                        UserDetailScreen(userId: user.id),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator(UsersState state) {
    if (state is UsersLoaded) {
      if (state.isLoadingMore) {
        return const Padding(
          padding: EdgeInsetsDirectional.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state.hasReachedMax) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No more users',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
