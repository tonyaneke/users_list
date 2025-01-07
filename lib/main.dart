import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_list/views/screens/home_screen.dart';
import 'package:users_list/providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget that sets up providers and theme configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: themeController.isDarkMode ? darkTheme : lightTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

/// Light theme configuration
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  shadowColor: Colors.black.withOpacity(0.1),
  cardColor: Colors.white54,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

/// Dark theme configuration
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  cardColor: Colors.black54,
  shadowColor: Colors.black.withOpacity(0.13),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

/// Manages theme state and provides methods to toggle between light/dark modes
class ThemeController with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

/// Returns appropriate skeleton color based on current theme brightness
Color getSkeletonColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[600]!;
}
