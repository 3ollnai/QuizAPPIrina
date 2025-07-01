import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../fonctions/database_helper.dart'; 
import 'package:applicationquiz/models/scores.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Score> _scores = []; 

  @override
  void initState() {
    super.initState();
    _loadScores(); 
  }

  Future<void> _loadScores() async {
    String userId = _auth.currentUser!.uid; 
    List<Score> scores = await DatabaseHelper().getScoresByUserId(userId); 
    setState(() {
      _scores = scores; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans le Quiz!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
              child: Text('Commencer le Quiz'),
            ),
            SizedBox(height: 40),
            Text(
              'Historique des parties jouées:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _scores.isEmpty
                ? Text('Aucun score enregistré.')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _scores.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Score: ${_scores[index].score}'),
                          subtitle: Text('Date: ${_scores[index].date}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
