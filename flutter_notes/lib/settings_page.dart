import 'package:flutter/material.dart';
import 'package:flutter_notes/app.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();

  bool errorMsg = false;

  @override
  void initState() {
    super.initState();
    _openPinBox();
  }

  Future<void> _openPinBox() async {
    var pinBox = Hive.box('pin');
    String? storedPin = pinBox.get('pin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Change PIN',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: TextField(
                  controller: _oldPinController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Enter Old PIN',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: TextField(
                  controller: _newPinController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Enter New PIN',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.teal),
                  ),
                  onPressed: () {
                    _backToNotes();
                  },
                ),
                FilledButton(
                  onPressed: () {
                    _validateAndSave();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _backToNotes() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NoteApp()),
    );
  }

  void _validateAndSave() {
    String oldPinInput = _oldPinController.text;
    String newPin = _newPinController.text;

    var pinBox = Hive.box('pin');
    String? storedPin = pinBox.get('pin');
    print('Stored PIN: $storedPin');

    if (oldPinInput != storedPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old PIN does not match.')),
      );
      return;
    }

    if (oldPinInput.isEmpty || newPin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    pinBox.put('pin', newPin);
    storedPin = newPin;
    print('NewStored PIN: $storedPin');

    _oldPinController.clear();
    _newPinController.clear();
    _backToNotes();
  }
}
