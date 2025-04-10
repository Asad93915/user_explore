import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../widgets/user_tile_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import '../widgets/user_tile_widget.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    addScrollListener();
  }

  addScrollListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUsers();

      // Wait for one more frame to ensure ListView is built and controller is attached
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && _scrollController.position.maxScrollExtent == 0 && userProvider.hasMore && !userProvider.isLoading) {
          userProvider.fetchUsers();
        }
      });
    });

    _scrollController.addListener(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (_scrollController.hasClients && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !userProvider.isLoading && userProvider.hasMore) {
        userProvider.fetchUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Explorer")),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.errorMessage != null && userProvider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    userProvider.errorMessage!,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: userProvider.fetchUsers,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: userProvider.isLoading && userProvider.users.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name or email",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      userProvider.searchUsers(value);
                    },
                  ),
                ),
                if (userProvider.errorMessage != null && userProvider.users.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      userProvider.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      userProvider.refreshUsers();
                      addScrollListener();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: userProvider.filteredUsers.length + 1,
                      itemBuilder: (context, index) {
                        if (index < userProvider.filteredUsers.length) {
                          final user = userProvider.filteredUsers[index];
                          return UserTileWidget(user: user);
                        } else if (userProvider.isLoading && userProvider.hasMore) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
