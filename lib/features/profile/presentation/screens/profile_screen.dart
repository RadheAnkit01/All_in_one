import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/features/auth/auth_providers.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Refresh profile',
            onPressed: () {
              ref.invalidate(currentUserProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
        automaticallyImplyActions: true,
        automaticallyImplyLeading: true,
        useDefaultSemanticsOrder: true,
      ),
      body: userAsync.when(
        data: (user) => _ProfileContent(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          final message = error is Failure
              ? error.message
              : 'Unable to load your profile.';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(currentUserProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.push('/');
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final fullName = [
      user.fname,
      user.lname,
    ].where((name) => name != null && name.isNotEmpty).join(' ');

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh is handled by invalidating currentUserProvider
        // from the screen's parent in a dedicated callback.
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 16),

          // Profile avatar
          Center(
            child: CircleAvatar(
              radius: 48,
              child: Text(
                user.fname?.isNotEmpty == true
                    ? user.fname![0].toUpperCase()
                    : 'U',
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              fullName.isEmpty ? 'User' : fullName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              user.email ?? 'No email available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.person_outline,
                  title: 'First Name',
                  value: user.fname,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.person_outline,
                  title: 'Last Name',
                  value: user.lname,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: user.email,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone Number',
                  value: user.fullPhoneNumber,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.flag_outlined,
                  title: 'Country Code',
                  value: user.countryCode,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.person_pin_outlined,
                  title: 'Gender',
                  value: user.gender,
                ),
                const Divider(height: 1),
                _ProfileTile(
                  icon: Icons.school_outlined,
                  title: 'Selected Course ID',
                  value: user.selectedCourseId?.toString(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              // Navigation only. No new API request.
              context.go('/');
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      subtitle: Text(
        value == null || value!.isEmpty ? 'Not available' : value!,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
