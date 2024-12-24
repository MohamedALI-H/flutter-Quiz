import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateScore(String userId, int score, String category, String difficulty) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final userSnapshot = await userDoc.get();

  if (userSnapshot.exists) {
    int bestScore = userSnapshot['bestScore'];
    if (score > bestScore) {
      userDoc.update({'bestScore': score});
    }

    // Update score history
    List<Map<String, dynamic>> scoreHistory = List<Map<String, dynamic>>.from(userSnapshot['scoreHistory']);
    scoreHistory.add({
      'score': score,
      'category': category,
      'date': Timestamp.now(),
      'difficulty': difficulty,
    });

    userDoc.update({'scoreHistory': scoreHistory});
  }
}

Future<Map<String, dynamic>> fetchScores(String userId) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final userSnapshot = await userDoc.get();

  if (userSnapshot.exists) {
    return {
      'bestScore': userSnapshot['bestScore'],
      'scoreHistory': List<Map<String, dynamic>>.from(userSnapshot['scoreHistory']),
    };
  } else {
    return {'bestScore': 0, 'scoreHistory': []};
  }
}

Future<List<Map<String, dynamic>>> fetchAllUserScores() async {
  final userDocs = await FirebaseFirestore.instance.collection('users').get();
  List<Map<String, dynamic>> userScores = userDocs.docs.map((doc) {
    final data = doc.data();
    return {
      'userId': doc.id,
      'name': data['name'],  
      'bestScore': data['bestScore'],
      'scoreHistory': List<Map<String, dynamic>>.from(data['scoreHistory']),
    };
  }).toList();

  userScores.sort((a, b) => b['bestScore'].compareTo(a['bestScore']));

  return userScores;
}
