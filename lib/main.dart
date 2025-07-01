import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/router.dart' as app_router; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Éducatif',
      initialRoute: '/',
      onGenerateRoute: app_router.Router.generateRoute, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
