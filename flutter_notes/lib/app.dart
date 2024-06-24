import 'package:flutter/material.dart';
import 'package:flutter_notes/settings_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final Box _noteBox = Hive.box('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(55, 144, 177, 192),
      appBar: AppBar(
        title: const Text('Note App'),
        backgroundColor: const Color.fromARGB(90, 144, 177, 192),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNoteModal,
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _settingsPage,
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _noteBox.length,
        itemBuilder: (context, index) {
          var note = _noteBox.getAt(index) as Map<dynamic, dynamic>;
          return Column(
            children: [
              ListTile(
                title: Text(
                  note['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['content'],
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created: ${_formatDateTime(note['createdAt'])}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Last Edited: ${_formatDateTime(note['updatedAt'])}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNoteAt(index),
                ),
                onTap: () => _editNoteModal(index, note),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }

  void _settingsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _addNoteModal() {
    _titleController.clear();
    _contentController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 380,
            height: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: [
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        expands: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          alignLabelWithHint: true,
                          labelText: 'Your Text...',
                          labelStyle: TextStyle(fontSize: 16.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
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
                        Navigator.of(context).pop();
                      },
                    ),
                    FilledButton(
                      onPressed: () {
                        _saveNote();
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editNoteModal(int index, Map note) {
    _titleController.text = note['title'];
    _contentController.text = note['content'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 380,
            height: 500,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: [
                    Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        expands: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          alignLabelWithHint: true,
                          labelText: 'Your Text...',
                          labelStyle: TextStyle(fontSize: 16.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FilledButton(
                      onPressed: () {
                        _editNoteAt(index);
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveNote() {
    final newNote = {
      'title': _titleController.text,
      'content': _contentController.text,
      'createdAt': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'updatedAt': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    };
    _noteBox.add(newNote);
    setState(() {});
  }

  void _editNoteAt(int index) {
    final note = _noteBox.getAt(index) as Map;
    final updatedNote = {
      'title': _titleController.text,
      'content': _contentController.text,
      'createdAt': note['createdAt'],
      'updatedAt': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    };
    _noteBox.putAt(index, updatedNote);
    setState(() {});
  }

  void _deleteNoteAt(int index) {
    _noteBox.deleteAt(index);
    setState(() {});
  }

  String _formatDateTime(String dateTime) {
    final dateTimeParsed = DateFormat('dd/MM/yyyy HH:mm').parse(dateTime);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTimeParsed);
  }
}
