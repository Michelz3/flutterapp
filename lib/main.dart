import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_data.dart';
import 'screens/main_navigation_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FishingSpotsApp());
}

class FishingSpotsApp extends StatelessWidget {
  const FishingSpotsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppData(),
      child: MaterialApp(
        title: 'Fishing Spots Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
          useMaterial3: true,
        ),
        home: const MainNavigationPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}