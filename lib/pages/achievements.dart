import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_scores.dart';

class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  late Future<Map<String, dynamic>> _futureScores;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _futureScores = fetchScores(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFF5568FE),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureScores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load achievements'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> scores = snapshot.data!;
            List<dynamic> scoreHistory = scores['scoreHistory'];

            if (scoreHistory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No achievements available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      },
                      child: Text('Start Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Color(0xFF5568FE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: scoreHistory.length,
              itemBuilder: (context, index) {
                var score = scoreHistory[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: ListTile(
                    title: Text('Score: ${score['score']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Category: ${score['category']}, Difficulty: ${score['difficulty']}, Date: ${score['date'].toDate()}'),
                    leading: Icon(Icons.star, color: Colors.amber),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No achievements available'));
          }
        },
      ),
    );
  }
}
