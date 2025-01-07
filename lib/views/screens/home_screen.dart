import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:users_list/main.dart';
import 'package:users_list/models/user.dart';
import 'package:users_list/providers/user_provider.dart';
import 'package:users_list/views/widgets/empty_state.dart';
import 'package:users_list/views/widgets/user_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Generate dummy users for loading state
  List<User> get _dummyUsers => List.generate(
        10,
        (index) => User(
          name: 'Loading Name',
          email: 'loading@email.com',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          // Show error state if there's an error
          if (userProvider.errorMessage != null) {
            return EmptyState(
              type: EmptyStateType.error,
              title: 'Oops!',
              description: userProvider.errorMessage!,
              actionLabel: 'Try again',
              onActionPressed: () => userProvider.fetchUsers(),
            );
          }

          return RefreshIndicator(
            onRefresh: userProvider.fetchUsers,
            edgeOffset: 40,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Custom App Bar with search and filters
                _buildAppBar(context),

                // User List or Empty State
                _buildUserList(userProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build the custom app bar with search and theme toggle
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      stretch: true,
      expandedHeight: 200.0,
      toolbarHeight: 60.0,
      backgroundColor: ColorEffect.neutralValue,
      flexibleSpace: _buildFlexibleSpace(),
      leading: _buildLeadingAvatar(),
      actions: _buildActions(context),
      bottom: _buildSearchBar(context),
    );
  }

  // Build the flexible space with background image
  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      stretchModes: const [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
      ],
      background: Image.network(
        'https://i.postimg.cc/SNY2HQsL/Image.png',
        fit: BoxFit.cover,
        color: Colors.blueGrey,
      ),
    );
  }

  // Build the leading avatar
  Widget _buildLeadingAvatar() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: const CircleAvatar(
        child: Text('TA'),
      ),
    );
  }

  // Build the action buttons (theme toggle)
  List<Widget> _buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Provider.of<ThemeController>(context).isDarkMode
              ? Icons.dark_mode
              : Icons.light_mode,
        ),
        onPressed: () {
          Provider.of<ThemeController>(context, listen: false).toggleTheme();
        },
      ),
    ];
  }

  // Build the search bar with filters
  PreferredSize _buildSearchBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) =>
                context.read<UserProvider>().filterUsers(query),
            decoration: InputDecoration(
              hintText: 'Search users...',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _buildFilterMenu(context),
            ),
          ),
        ),
      ),
    );
  }

  // Build the filter menu
  Widget _buildFilterMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      onSelected: (String value) => _handleFilterSelection(context, value),
      itemBuilder: _buildFilterMenuItems,
    );
  }

  // Handle filter selection
  void _handleFilterSelection(BuildContext context, String value) {
    final provider = context.read<UserProvider>();
    switch (value) {
      case 'name_asc':
        provider.setSortCriteria('name', true);
        break;
      case 'name_desc':
        provider.setSortCriteria('name', false);
        break;
      case 'email_asc':
        provider.setSortCriteria('email', true);
        break;
      case 'email_desc':
        provider.setSortCriteria('email', false);
        break;
    }
  }

  // Build filter menu items
  List<PopupMenuItem<String>> _buildFilterMenuItems(BuildContext context) {
    return const [
      PopupMenuItem(
        value: 'name_asc',
        child: Row(
          children: [
            Icon(Icons.arrow_upward),
            SizedBox(width: 8),
            Text('Sort by name (A-Z)'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'name_desc',
        child: Row(
          children: [
            Icon(Icons.arrow_downward),
            SizedBox(width: 8),
            Text('Sort by name (Z-A)'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'email_asc',
        child: Row(
          children: [
            Icon(Icons.arrow_upward),
            SizedBox(width: 8),
            Text('Sort by email (A-Z)'),
          ],
        ),
      ),
      PopupMenuItem(
        value: 'email_desc',
        child: Row(
          children: [
            Icon(Icons.arrow_downward),
            SizedBox(width: 8),
            Text('Sort by email (Z-A)'),
          ],
        ),
      ),
    ];
  }

  // Build the user list or empty state
  Widget _buildUserList(UserProvider userProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Handle the last item - add padding at bottom
          if (index == _getChildCount(userProvider)) {
            return const SizedBox(height: 80); // Add bottom padding
          }

          // Show empty state if no users and not loading
          if (userProvider.users.isEmpty && !userProvider.isLoading) {
            return _buildEmptyState(context, userProvider);
          }

          // Show skeleton loading or actual user
          final user = userProvider.isLoading
              ? _dummyUsers[index]
              : userProvider.users[index];

          return Skeletonizer(
            enabled: userProvider.isLoading,
            child: UserListItem(user: user),
          ).animate().fade(duration: const Duration(milliseconds: 500));
        },
        // Increment childCount by 1 to account for the SizedBox
        childCount: _getChildCount(userProvider) + 1,
      ),
    );
  }

  // Get child count based on loading state and data
  int _getChildCount(UserProvider userProvider) {
    if (userProvider.isLoading) return _dummyUsers.length;
    if (userProvider.users.isEmpty) return 1; // Show empty state
    return userProvider.users.length;
  }

  // Build empty state widget
  Widget _buildEmptyState(BuildContext context, UserProvider userProvider) {
    final bool isSearching = userProvider.currentSearchQuery.isNotEmpty;
    return Center(
      child: EmptyState(
        type: EmptyStateType.notFound,
        title: isSearching ? 'No matches found' : 'No users found',
        description: isSearching
            ? 'No users match "${userProvider.currentSearchQuery}"\nTry a different search term'
            : 'Try adjusting your filters',
        actionLabel: 'Clear ${isSearching ? 'search' : 'filters'}',
        onActionPressed: () {
          context.read<UserProvider>().filterUsers('');
          context.read<UserProvider>().setSortCriteria('name', true);
        },
      ),
    );
  }
}
