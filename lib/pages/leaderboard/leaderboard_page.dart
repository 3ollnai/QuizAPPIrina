import 'package:flutter/material.dart';
import '../../fonctions/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/scores.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Score> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    _scores = await DatabaseHelper().getScoresByUserId(userId); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaderboard')),
      body: ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Score: ${_scores[index].score}'),
            subtitle: Text('Date: ${_scores[index].date}'),
          );
        },
      ),
    );
  }
}
