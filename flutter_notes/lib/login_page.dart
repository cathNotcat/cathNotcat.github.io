import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'app.dart';

class LoginPin extends StatefulWidget {
  const LoginPin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPinState createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
  final _pinController = TextEditingController();
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  void checkFirstTime() async {
    var pinBox = Hive.box('pin');
    if (pinBox.isEmpty) {
      setState(() {
        isFirstTime = true;
      });
    }
  }

  void _submitPin() async {
    var pinBox = Hive.box('pin');
    if (isFirstTime) {
      pinBox.put('pin', _pinController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NoteApp()),
      );
    } else {
      String? storedPin = pinBox.get('pin');
      if (storedPin == _pinController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NoteApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect PIN')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                isFirstTime ? 'Create PIN' : 'Enter PIN',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: TextField(
                  controller: _pinController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: isFirstTime ? 'Create PIN' : 'Enter PIN',
                    hintStyle: const TextStyle(fontSize: 16.0),
                    prefixIcon: const Icon(Icons.password),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitPin,
                style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
