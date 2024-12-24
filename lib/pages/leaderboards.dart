import 'package:flutter/material.dart';
import 'user_scores.dart';
import '../config/global.params.dart'; // Import global parameters

class LeaderboardsPage extends StatefulWidget {
  @override
  _LeaderboardsPageState createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  late Future<List<Map<String, dynamic>>> _futureUserScores;

  @override
  void initState() {
    super.initState();
    _futureUserScores = fetchAllUserScores();
  }

  String getCategoryName(dynamic category) {
    int categoryIndex = category is int ? category : int.tryParse(category) ?? 0;
    final categoryObj = GlobalParams.categories.firstWhere((cat) => cat['index'] == categoryIndex, orElse: () => {'name': 'Any Category'});
    return categoryObj['name'];
  }

  String getDifficultyName(String difficulty) {
    return difficulty.isEmpty ? 'Any Difficulty' : difficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboards', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFF5568FE),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureUserScores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load leaderboards'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> userScores = snapshot.data!;

            return ListView.builder(
              itemCount: userScores.length,
              itemBuilder: (context, index) {
                var userScore = userScores[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: ExpansionTile(
                    title: Text('User: ${userScore['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Best Score: ${userScore['bestScore']}'),
                    leading: Icon(Icons.emoji_events, color: Colors.amber),
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchScores(userScore['userId']),
                        builder: (context, scoreSnapshot) {
                          if (scoreSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (scoreSnapshot.hasError) {
                            return Center(child: Text('Failed to load score history'));
                          } else if (scoreSnapshot.hasData) {
                            List<dynamic> scoreHistory = scoreSnapshot.data!['scoreHistory'];
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: scoreHistory.length,
                              itemBuilder: (context, scoreIndex) {
                                var score = scoreHistory[scoreIndex];
                                return ListTile(
                                  title: Text('Score: ${score['score']}'),
                                  subtitle: Text(
                                      'Category: ${getCategoryName(score['category'])}, Difficulty: ${getDifficultyName(score['difficulty'])}, Date: ${score['date'].toDate()}'
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(child: Text('No score history available'));
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No leaderboards available'));
          }
        },
      ),
    );
  }
}
