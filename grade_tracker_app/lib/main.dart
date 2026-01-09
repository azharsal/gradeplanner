import 'package:flutter/material.dart';
import 'package:grade_tracker_app/providers/semester_provider.dart';
import 'package:grade_tracker_app/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final semestersProvider = SemestersProvider();
  await semestersProvider.loadSemestersFromJson();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => semestersProvider),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          brightness: Brightness.light,
        ),
        home: MainScreen(),
      ),
    ),
  );
}
