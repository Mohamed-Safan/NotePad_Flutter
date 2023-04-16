import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDarkMode = false;
  TextEditingController _textEditingController = TextEditingController();
  List<String> history = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _saveNote() {
    String note = _textEditingController.text;
    setState(() {
      history.add(note);
      _textEditingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NotePad',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  kBottomNavigationBarHeight -
                  32.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: isDarkMode ? Colors.black : Colors.white,
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                  ),
                  maxLines: null,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: _toggleDarkMode,
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    primary: isDarkMode ? Colors.white : Colors.black,
                    onPrimary: isDarkMode ? Colors.black : Colors.white,
                  ),
                  child: Text('Save'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryPage(
                                  history: history,
                                  isDarkMode: isDarkMode,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isDarkMode ? Colors.white : Colors.black,
                    onPrimary: isDarkMode ? Colors.black : Colors.white,
                  ),
                  child: Text('History'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;
  final bool isDarkMode;

  HistoryPage({required this.history, required this.isDarkMode});

  void _deleteHistory(int index) {
    history.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(history[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotePage(
                    note: history[index],
                    index: index,
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteHistory(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class EditNotePage extends StatefulWidget {
  final String note;
  final int index;
  final bool isDarkMode;

  EditNotePage(
      {required this.note, required this.index, required this.isDarkMode});

  @override
  _EditNotePageState createState() =>
      _EditNotePageState(note: note, index: index, isDarkMode: isDarkMode);
}

class _EditNotePageState extends State<EditNotePage> {
  String note;
  int index;
  bool isDarkMode;

  _EditNotePageState(
      {required this.note, required this.index, required this.isDarkMode});

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = note;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _saveNote() {
    String newNote = _textEditingController.text;
    setState(() {
      note = newNote;
    });
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Write your note here',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 0, 0, 0),
                ),
                maxLines: null,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                primary: isDarkMode ? Colors.white : Colors.black,
                onPrimary: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
