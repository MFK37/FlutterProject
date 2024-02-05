// Version 1.0

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Progress {
  static String userName = '';
  static int currentLevel = 1;
  static int score = 0;
  static bool isSoundOn = true;
  static List<bool> solvedLevels = List.generate(6, (index) => false);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // Use a modern font
      ),
      home: NameEntryPage(),
    );
  }
}

class NameEntryPage extends StatefulWidget {
  @override
  _NameEntryPageState createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String enteredName = nameController.text.trim();
                if (enteredName.isNotEmpty) {
                  Progress.userName = enteredName;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter your name.'),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void didUpdateWidget(covariant MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates when widget receives new data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, ${Progress.userName}!',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gamepad, size: 120, color: Colors.blue),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Start',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LevelPage extends StatefulWidget {
  final List<String> words = ['FLUTTER', 'DART', 'WIDGET', 'GITHUB', 'MOBILE', 'APP'];
  final List<String> hints = [
    'UI toolkit for building natively compiled applications.',
    'Programming language optimized for building mobile, desktop, server, and web applications.',
    'Reusable building blocks for constructing user interfaces.',
    'Web-based platform for version control and collaboration.',
    'Relating to handheld communication devices.',
    'Software application designed to run on a mobile device.',
  ];

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  void _showHintPopup(String hint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hint'),
          content: Text(hint),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Level', style: TextStyle(fontSize: 18, color: Colors.blue)),
            Text(
              'Player ${Progress.userName} Progress: Level ${Progress.currentLevel - 1} completed',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 6,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          bool isLocked = index >= Progress.currentLevel;
          bool isSolved = Progress.solvedLevels[index];
          bool isOpen = !isLocked && !isSolved;
          String hint = widget.hints[index]; // Use widget.hints here

          return ElevatedButton(
            onPressed: () {
              if (!isLocked) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage(level: index + 1, words: widget.words,       hints: widget.hints,)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Level ${index + 1} is locked. Complete previous levels to unlock.'),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              primary: isSolved ? Colors.green : (isOpen ? Colors.blue : Colors.grey),
              fixedSize: Size(100, 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSolved)
                  Icon(Icons.check_circle, color: Colors.white, size: 40)
                else if (isOpen)
                  Icon(Icons.lock_open, color: Colors.white, size: 40)
                else
                  Icon(Icons.lock, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  'Level ${index + 1}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                if (isOpen)
                  IconButton(
                    icon: Icon(Icons.lightbulb_outline, color: Colors.yellow),
                    onPressed: () {
                      _showHintPopup(hint);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class GamePage extends StatefulWidget {
  final int level;
  final List<String> words;
  final List<String> hints; // Add hints as a parameter

  GamePage({required this.level, required this.words, required this.hints});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late String currentWord;
  late String displayedWord;
  late TextEditingController userAnswerController;
  bool levelSolved = false;

  @override
  void initState() {
    super.initState();
    currentWord = widget.words[widget.level - 1];
    displayedWord = getDisplayedWord();
    userAnswerController = TextEditingController();
    levelSolved = Progress.solvedLevels[widget.level - 1];
  }

  void _showHintPopup(String hint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hint'),
          content: Text(hint),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Level ${widget.level} - ${Progress.userName}',
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          if (!levelSolved) // Show the hint icon only if the level is not solved
            IconButton(
              icon: Icon(Icons.lightbulb_outline),
              onPressed: () {
                _showHintPopup(widget.hints[widget.level - 1]);
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Guess the missing letter in:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              levelSolved ? currentWord : displayedWord,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (levelSolved)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 40),
                  SizedBox(width: 10),
                  Text(
                    'Level Solved!',
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                ],
              )
            else
              Column(
                children: [
                  TextField(
                    controller: userAnswerController,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    readOnly: levelSolved,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      validateAnswer();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Submit Answer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String getDisplayedWord() {
    return currentWord.replaceRange(0, 1, '_');
  }

  void validateAnswer() {
    String userAnswer = userAnswerController.text.toUpperCase();
    if (userAnswer == currentWord[0]) {
      if (!levelSolved) {
        showCongratulationsPopup(context);
        Progress.score++;
        Progress.solvedLevels[widget.level - 1] = true;
        levelSolved = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You already solved this level!'),
        ));
      }
      Progress.currentLevel = widget.level + 1;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect answer. Try again!'),
      ));
    }
  }

  void showCongratulationsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 10),
              Text('Great Job!', style: TextStyle(color: Colors.blue)),
            ],
          ),
          content: Text(
            'Congratulations! You solved Level ${widget.level}.\nYour score: ${Progress.score}',
            style: TextStyle(color: Colors.blue),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (Progress.currentLevel <= 6) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LevelPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    userAnswerController.dispose();
    super.dispose();
  }
}


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Edit Name'),
              subtitle: Text('Current Name: ${Progress.userName}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Name'),
                      content: TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'New Name'),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            String newName = nameController.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                Progress.userName = newName;
                              });
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter a valid name.'),
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SwitchListTile(
              title: Text('Sound'),
              subtitle: Text('Turn sound on/off'),
              value: Progress.isSoundOn,
              onChanged: (value) {
                setState(() {
                  Progress.isSoundOn = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
