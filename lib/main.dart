import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hive/favorite_show.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteShowAdapter());
  await Hive.openBox<FavoriteShow>('favorites');

  // Cek apakah sudah login
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('username') != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NontonSkuy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141414),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          surface: Color(0xFF1F1F1F),
        ),
        fontFamily: 'Roboto',
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}