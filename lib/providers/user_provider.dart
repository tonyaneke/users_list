import 'package:flutter/material.dart';
import 'package:users_list/models/user.dart';
import 'dart:convert';
import 'package:users_list/services/api_client.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  final ApiClient _apiClient = ApiClient();

  String _sortBy = 'name';
  bool _sortAscending = true;

  String _currentSearchQuery = '';

  UserProvider() {
    fetchUsers();
  }

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get currentSearchQuery => _currentSearchQuery;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await _apiClient.get('https://jsonplaceholder.typicode.com/users');
      final List<dynamic> data = json.decode(response.body);
      _users = data.map((json) => User.fromJson(json)).toList();
      _filteredUsers = _users;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterUsers(String query) {
    _currentSearchQuery = query;
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (_filteredUsers.isEmpty) {
      _filteredUsers = [];
    }
    _applyFiltersAndSort();
  }

  void setSortCriteria(String field, bool ascending) {
    _sortBy = field;
    _sortAscending = ascending;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<User> result = List.from(_filteredUsers);

    result.sort((a, b) {
      if (_sortAscending) {
        switch (_sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'email':
            return a.email.compareTo(b.email);
          default:
            return 0;
        }
      } else {
        switch (_sortBy) {
          case 'name':
            return b.name.compareTo(a.name);
          case 'email':
            return b.email.compareTo(a.email);
          default:
            return 0;
        }
      }
    });

    _filteredUsers = result;
    notifyListeners();
  }
}
