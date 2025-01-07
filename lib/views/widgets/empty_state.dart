import 'package:flutter/material.dart';

/// Defines different types of empty states that can be displayed
enum EmptyStateType {
  error, // For general errors (exclamation mark)
  noNetwork, // For network connection issues (electric plug)
  notFound, // For when items can't be found (magnifying glass)
  technical, // For technical issues (tool)
}

/// A widget that displays an empty state with an icon, title, description and optional action button.
/// Used to show meaningful feedback when there is no content to display.
class EmptyState extends StatelessWidget {
  /// The title text displayed below the icon
  final String title;

  /// The description text displayed below the title
  final String description;

  /// Optional callback function when the action button is pressed
  final VoidCallback? onActionPressed;

  /// Optional label text for the action button
  final String? actionLabel;

  /// The type of empty state to display, determines which icon is shown
  final EmptyStateType type;

  /// Creates an empty state widget
  ///
  /// [title] and [description] are required parameters
  /// [onActionPressed] and [actionLabel] are optional - if both provided, an action button will be shown
  /// [type] defaults to [EmptyStateType.notFound] if not specified
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.onActionPressed,
    this.actionLabel,
    this.type = EmptyStateType.notFound,
  });

  /// Returns the appropriate icon based on the empty state type
  IconData _getIconForType() {
    switch (type) {
      case EmptyStateType.error:
        return Icons.error_outline;
      case EmptyStateType.noNetwork:
        return Icons.wifi_off;
      case EmptyStateType.notFound:
        return Icons.search_off;
      case EmptyStateType.technical:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display icon based on type
            Icon(
              _getIconForType(),
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            // Title text
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Description text
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            // Conditionally show action button if callback and label provided
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
