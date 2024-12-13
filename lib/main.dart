import 'package:final_project/screens/welcome_screen.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
