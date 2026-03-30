// import 'package:flutter/material.dart';
// import 'package:king_jamaica_caffe/services/database_service.dart';
// import 'screens/splash_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Sembast database + seed sample data (if empty)
//   await MenuDatabase().database;   // this triggers _seedDataIfEmpty() internally
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'King Jamaica Caffe',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.brown,
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,                    // modern look (2024–2026 style)
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.brown,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//       ),
//       home:  SplashScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:king_jamaica_caffe/services/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://becaesxwfnnfztbtujvo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlY2Flc3h3Zm5uZnp0YnR1anZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ3MTgzMDEsImV4cCI6MjA5MDI5NDMwMX0.ZZuOXuUvUb1CEfBfw3CZnKnsGOPLOXErq7CdHDiXZoM',
  );

  // Initialize your database
  // await MenuDatabase().initialize();

  // Initialize database (works on all platforms including web)
  // try {
  //   await MenuDatabase().database;
  //   print('Database initialized successfully');
  // } catch (e) {
  //   print('Error initializing database: $e');
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King Jamaica Caffe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home:  SplashScreen(),
    );
  }
}