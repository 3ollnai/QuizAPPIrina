import 'package:flutter/material.dart';
import '../pages/forms/login.dart';
import '../pages/forms/inscription.dart';
import '../pages/quiz/quiz_page.dart';
import '../pages/leaderboard/leaderboard_page.dart';
import '../pages/home.dart'; 

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/inscription':
        return MaterialPageRoute(builder: (_) => InscriptionPage());
      case '/home': 
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/quiz':
        return MaterialPageRoute(builder: (_) => QuizPage());
      case '/leaderboard':
        return MaterialPageRoute(builder: (_) => LeaderboardPage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
