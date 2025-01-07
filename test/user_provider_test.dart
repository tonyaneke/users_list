import 'package:flutter_test/flutter_test.dart';
import 'package:users_list/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:users_list/services/api_client.dart';

void main() {
  group('UserProvider Tests', () {
    late UserProvider userProvider;

    setUp(() {
      // Mock the HTTP client
      final client = MockClient((request) async {
        if (request.url.toString() ==
            'https://jsonplaceholder.typicode.com/users') {
          return http.Response(
              jsonEncode([
                {'name': 'Leanne Graham', 'email': 'Sincere@april.biz'},
                {'name': 'Ervin Howell', 'email': 'Shanna@melissa.tv'}
              ]),
              200);
        }
        return http.Response('Not Found', 404);
      });

      userProvider = UserProvider();
    });

    test('Initial state is correct', () {
      expect(userProvider.users, isEmpty);
      expect(userProvider.isLoading, isTrue);
      expect(userProvider.errorMessage, isNull);
    });

    test('Fetch users updates state correctly', () async {
      await userProvider.fetchUsers();
      expect(userProvider.users, isNotEmpty);
      expect(userProvider.isLoading, isFalse);
      expect(userProvider.errorMessage, isNull);
    });

    test('Filter users works correctly', () async {
      await userProvider.fetchUsers();
      userProvider.filterUsers('Leanne');
      expect(userProvider.users.any((user) => user.name.contains('Leanne')),
          isTrue);
    });
  });
}
