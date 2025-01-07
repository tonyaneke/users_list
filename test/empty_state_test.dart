import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:users_list/views/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState displays correct information',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'No Data',
            description: 'There is no data available.',
            type: EmptyStateType.notFound,
          ),
        ),
      ),
    );

    expect(find.text('No Data'), findsOneWidget);
    expect(find.text('There is no data available.'), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);
  });

  testWidgets('EmptyState displays action button when provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'Error',
            description: 'An error occurred.',
            type: EmptyStateType.error,
            actionLabel: 'Retry',
            onActionPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Retry'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
