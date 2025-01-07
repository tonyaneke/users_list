import 'package:flutter_test/flutter_test.dart';
import 'package:users_list/main.dart';

void main() {
  group('ThemeController Tests', () {
    late ThemeController themeController;

    setUp(() {
      themeController = ThemeController();
    });

    test('Initial theme is light mode', () {
      expect(themeController.isDarkMode, isFalse);
    });

    test('Toggle theme changes mode', () {
      themeController.toggleTheme();
      expect(themeController.isDarkMode, isTrue);
      themeController.toggleTheme();
      expect(themeController.isDarkMode, isFalse);
    });
  });
}
