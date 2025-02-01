import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => NotesProvider(),
    child: NotesApp(),
  ));
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesHome(),
    );
  }
}

class NotesProvider extends ChangeNotifier {
  List<String> _notes = [];

  List<String> get notes => _notes;

  void addNote(String note) {
    _notes.add(note);
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void editNote(int index, String note) {
    _notes[index];
    notifyListeners();
  }

//provider
}

class NotesHome extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  NotesHome({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter a note",
                    border: OutlineInputBorder(),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    String note = _controller.text.trim();

                    if (note.isNotEmpty) {
                      notesProvider.addNote(note);
                      _controller.clear();
                      //
                    }
                  },
                  child: Text('Add'),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  notesProvider.notes[index],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _controller.text = notesProvider.notes[index];
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Edit Note"),
                              content: TextField(
                                controller: _controller,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    String updateNote = _controller.text.trim();
                                    if (updateNote.isNotEmpty) {
                                      notesProvider.editNote(index, updateNote);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save'),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        notesProvider.deleteNote(index);
                      },
                    )
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
