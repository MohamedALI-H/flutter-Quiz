import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/global.params.dart';
import '../menu/drawer.widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  int _numberOfQuestions = 10;
  int _selectedCategoryIndex = 0;
  String _selectedDifficulty = 'Any Difficulty';
  String _selectedType = 'multiple';

  final List<String> _difficulties = ['Any Difficulty', 'easy', 'medium', 'hard'];

  final Map<String, String> _types = {
    'Multiple Question': 'multiple',
    'True/False': 'boolean',
  };

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Your Choices',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          content: Text(
            'Number of Questions: $_numberOfQuestions\nCategory: ${GlobalParams.categories[_selectedCategoryIndex]['name']}\nDifficulty: $_selectedDifficulty\nType: ${_types.keys.firstWhere((key) => _types[key] == _selectedType)}',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Start Quiz',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  '/play',
                  arguments: {
                    'numberOfQuestions': _numberOfQuestions,
                    'category': _selectedCategoryIndex == 0 ? '' : GlobalParams.categories[_selectedCategoryIndex]['index'].toString(),
                    'difficulty': _selectedDifficulty == 'Any Difficulty' ? '' : _selectedDifficulty,
                    'type': _selectedType,
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return MyDrawer(user: snapshot.data); // Ensure MyDrawer widget is defined and imported
        },
      ),
      appBar: AppBar(
        title: Text(
          'Quiz Preferences',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5568FE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Number of Questions:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                initialValue: _numberOfQuestions.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Accept only digits
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number.';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number < 1 || number > 50) {
                    return 'Please enter a number between 1 and 50.';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _numberOfQuestions = int.parse(value!);
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Select Category:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryIndex,
                items: GlobalParams.categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: GlobalParams.categories.indexOf(category),
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryIndex = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Difficulty:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                items: _difficulties.map((difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Type:',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showConfirmDialog();
                  }
                },
                child: Text(
                  'Confirm & Start Quiz',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF5568FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
