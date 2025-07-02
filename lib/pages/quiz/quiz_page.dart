import 'package:applicationquiz/models/scores.dart';
import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../fonctions/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> _questions = [
    Question(
      question: 'Quelle est la capitale de la France?',
      options: ['Paris', 'Londres', 'Berlin', 'Madrid'],
      answer: 'Paris',
    ),
    Question(
      question: 'Quelle est la couleur du ciel?',
      options: ['Rouge', 'Bleu', 'Vert', 'Jaune'],
      answer: 'Bleu',
    ),
    Question(
      question: 'Quel est l\'animal terrestre le plus rapide?',
      options: ['Lion', 'Tigre', 'Guépard', 'Éléphant'],
      answer: 'Guépard',
    ),
    Question(
      question: 'Qui a écrit "Les Misérables"?',
      options: ['Victor Hugo', 'Marcel Proust', 'Gustave Flaubert', 'Émile Zola'],
      answer: 'Victor Hugo',
    ),
    Question(
      question: 'Quelle est la formule chimique de l\'eau?',
      options: ['H2O', 'CO2', 'O2', 'NaCl'],
      answer: 'H2O',
    ),
    Question(
      question: 'Quel langage est principalement utilisé pour le développement web côté client?',
      options: ['Python', 'Java', 'JavaScript', 'C#'],
      answer: 'JavaScript',
    ),
    Question(
      question: 'Quel est le plus grand océan du monde?',
      options: ['Atlantique', 'Indien', 'Arctique', 'Pacifique'],
      answer: 'Pacifique',
    ),
    Question(
      question: 'Qui a découvert la pénicilline?',
      options: ['Louis Pasteur', 'Alexander Fleming', 'Marie Curie', 'Albert Einstein'],
      answer: 'Alexander Fleming',
    ),
    Question(
      question: 'Quel est le langage de programmation principalement utilisé pour le développement Android?',
      options: ['Swift', 'Kotlin', 'JavaScript', 'Ruby'],
      answer: 'Kotlin',
    ),
    Question(
      question: 'Quel pays est connu comme le pays du soleil levant?',
      options: ['Chine', 'Japon', 'Corée du Sud', 'Thaïlande'],
      answer: 'Japon',
    ),
    Question(
      question: 'Quel est le symbole chimique de l\'or?',
      options: ['Au', 'Ag', 'Pb', 'Fe'],
      answer: 'Au',
    ),
    Question(
      question: 'Qui a écrit "Roméo et Juliette"?',
      options: ['Molière', 'Shakespeare', 'Hugo', 'Dumas'],
      answer: 'Shakespeare',
    ),
    Question(
      question: 'Quel est le langage de programmation utilisé pour le développement iOS?',
      options: ['Swift', 'C++', 'PHP', 'Go'],
      answer: 'Swift',
    ),
    Question(
      question: 'Quel est le plus grand pays du monde?',
      options: ['Canada', 'Chine', 'Russie', 'États-Unis'],
      answer: 'Russie',
    ),
    Question(
      question: 'Quelle planète est connue sous le nom de "planète rouge"?',
      options: ['Mars', 'Vénus', 'Jupiter', 'Saturne'],
      answer: 'Mars',
    ),
    Question(
      question: 'Quel est le langage de programmation le plus utilisé pour le développement web côté serveur?',
      options: ['Java', 'Python', 'PHP', 'C#'],
      answer: 'PHP',
    ),
    Question(
      question: 'Qui a peint la Mona Lisa?',
      options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Monet'],
      answer: 'Da Vinci',
    ),
    Question(
      question: 'Quelle est la capitale de l\'Italie?',
      options: ['Rome', 'Milan', 'Venise', 'Florence'],
      answer: 'Rome',
    ),
    Question(
      question: 'Quel est le plus grand mammifère marin?',
      options: ['Dauphin', 'Requin', 'Baleine bleue', 'Orque'],
      answer: 'Baleine bleue',
    ),
    Question(
      question: 'Quel est le nom de l\'algorithme de tri le plus connu?',
      options: ['Tri à bulles', 'Tri rapide', 'Tri par insertion', 'Tri fusion'],
      answer: 'Tri rapide',
    ),
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;

  void _answerQuestion(String answer) {
    if (answer == _questions[_currentQuestionIndex].answer) {
      _score++;
    }

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        if (_currentQuestionIndex < _questions.length - 1) {
          _currentQuestionIndex++;
        } else {
          _finishQuiz();
        }
      });
    });
  }

  void _finishQuiz() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Score score = Score(userId: userId, score: _score, date: DateTime.now());
    await DatabaseHelper().insertScore(score);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz terminé!'),
        content: Text('Votre score est $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/leaderboard');
            },
            child: Text('Voir le classement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<int>(_currentQuestionIndex),
                child: Column(
                  children: [
                    Text(
                      _questions[_currentQuestionIndex].question,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: _questions[_currentQuestionIndex].options.map((option) {
                        return ElevatedButton(
                          onPressed: () => _answerQuestion(option),
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ],
                ).animate().slide(duration: 500.ms, curve: Curves.easeInOut),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
