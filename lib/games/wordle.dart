import 'package:flutter/material.dart';
import 'dart:math';

class WordleScreen extends StatefulWidget {
  const WordleScreen({super.key});

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  final List<String> _words = ['FLUTTER', 'DART', 'MOBILE', 'CODING', 'APPLE', 'GAMES', 'PINC', 'NETWORK'];
  late String _targetWord;
  final List<String> _guesses = [];
  String _currentGuess = '';
  String _message = '';
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    Random random = Random();
    _targetWord = _words[random.nextInt(_words.length)];
  }

  void _onKey(String key) {
    if (_gameOver) return;
    if (key == 'ENTER') {
      _submitGuess();
    } else if (key == 'BACK') {
      if (_currentGuess.isNotEmpty) {
        setState(() => _currentGuess = _currentGuess.substring(0, _currentGuess.length - 1));
      }
    } else if (_currentGuess.length < 5) {
      setState(() => _currentGuess += key);
    }
  }

  void _submitGuess() {
    if (_currentGuess.length != 5) {
      setState(() => _message = 'Enter 5 letters');
      return;
    }
    setState(() {
      _guesses.add(_currentGuess);
      if (_currentGuess == _targetWord) {
        _message = 'You Win!';
        _gameOver = true;
      } else if (_guesses.length >= 6) {
        _message = 'Game Over! Word: $_targetWord';
        _gameOver = true;
      } else {
        _message = '';
      }
      _currentGuess = '';
    });
  }

  List<Color> _getColors(String guess) {
    List<Color> colors = [];
    for (int i = 0; i < guess.length; i++) {
      if (guess[i] == _targetWord[i]) {
        colors.add(Colors.green);
      } else if (_targetWord.contains(guess[i])) {
        colors.add(Colors.orange);
      } else {
        colors.add(Colors.grey);
      }
    }
    return colors;
  }

  void _reset() {
    setState(() {
      Random random = Random();
      _targetWord = _words[random.nextInt(_words.length)];
      _guesses.clear();
      _currentGuess = '';
      _message = '';
      _gameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wordle')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_message, style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 20),
          ...List.generate(6, (row) {
            final guess = row < _guesses.length ? _guesses[row] : (row == _guesses.length ? _currentGuess : '');
            final colors = row < _guesses.length ? _getColors(guess) : List.filled(5, Colors.grey[800]!);
            return Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (col) => Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: col < guess.length ? colors[col] : Colors.grey[800],
                  child: Center(
                    child: Text(
                      col < guess.length ? guess[col] : '',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )),
              ),
            );
          }),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: [
              ...'QWERTYUIOPASDFGHJKLZXCVBNM'.split('').map((key) => ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(36, 36)),
                onPressed: () => _onKey(key),
                child: Text(key),
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(60, 36)),
                onPressed: () => _onKey('BACK'),
                child: const Text('⌫'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(60, 36)),
                onPressed: () => _onKey('ENTER'),
                child: const Text('Enter'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _reset, child: const Text('Reset Game')),
        ],
      ),
    );
  }
}