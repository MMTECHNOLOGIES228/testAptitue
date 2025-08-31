import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testtechniqueflutter/models/project_model.dart';
import 'package:testtechniqueflutter/providers/project_provider.dart';
import 'package:testtechniqueflutter/services/api_service.dart';
import 'utils/theme.dart';
import 'screens/project_list_screen.dart';

void main() async{
  final api = ApiService();
  // 
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Hive.registerAdapter(ProjectAdapter());
  await Hive.openBox<Project>('projectsBox');
  // 
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProjectProvider(api: api),
      child: const MyApp(),
    ),
    // const MyApp()
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Projects App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Utilise le thème système
      home: const ProjectListScreen(),
    );
  }
}
