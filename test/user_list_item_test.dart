import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:users_list/models/user.dart';
import 'package:users_list/views/widgets/user_list_item.dart';

void main() {
  testWidgets('UserListItem displays user information',
      (WidgetTester tester) async {
    final user = User(name: 'John Doe', email: 'john.doe@example.com');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserListItem(user: user),
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
  });
}
