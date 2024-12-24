import 'package:flutter/material.dart';
import '../menu/drawer.widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:porject_quiz/config/global.params.dart';
String mode = "Jour";
FirebaseDatabase fire = FirebaseDatabase.instance;
DatabaseReference ref = fire.ref() ;

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Page Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Jour'),
                  leading: Radio<String>(
                    value: "Jour",
                    groupValue: mode,
                    onChanged: (value) {
                      setState(() {
                        mode = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Nuit'),
                  leading: Radio<String>(
                    value: "Nuit",
                    groupValue: mode,
                    onChanged: (value) {
                      setState(() {
                        mode = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  padding: EdgeInsets.all(15),
                ),
                onPressed: _onSaveMode,
                child: Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveMode() async {
    GlobalParams.themeActuel.setMode(mode) ;
    await ref.set({"mode": mode});
    print("Mode changé");
    Navigator.pop(context);
  }
}
