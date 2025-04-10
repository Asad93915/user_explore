import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  List<User> users = [];
  List<User> filteredUsers = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  bool isRefreshing = false;  // Add this flag
  bool hasMore = true;
  String searchQuery = "";
  String? errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchUsers() async {
    if (isLoading || !hasMore || isRefreshing) return; // Avoid fetching while refreshing

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userModel = await _apiService.fetchUsers(currentPage);

      if (userModel != null) {
        users.addAll(userModel.data ?? []);
        filteredUsers = List.from(users);
        totalPages = userModel.totalPages ?? 1;
        currentPage++;

        if (currentPage > totalPages) {
          hasMore = false;
        }
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
      hasMore = false;
    } catch (e) {
      errorMessage = 'An unexpected error occurred';
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Refresh Users
  void refreshUsers() {
    users.clear();
    filteredUsers.clear();
    currentPage = 1;
    totalPages = 1;
    hasMore = true; // Reset pagination
  }
  void searchUsers(String query) {
    searchQuery = query;
    if (query.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      filteredUsers = users
          .where((user) =>
      user.firstName!.toLowerCase().contains(query.toLowerCase()) ||
          user.lastName!.toLowerCase().contains(query.toLowerCase()) ||
          user.email!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

