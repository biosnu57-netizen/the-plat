import 'package:flutter/material.dart';

class Connect4Screen extends StatefulWidget {
  const Connect4Screen({super.key});

  @override
  State<Connect4Screen> createState() => _Connect4ScreenState();
}

class _Connect4ScreenState extends State<Connect4Screen> {
  late List<List<int>> _board;
  int _currentPlayer = 1;
  int? _winner;

  @override
  void initState() {
    super.initState();
    _board = List.generate(6, (_) => List.filled(7, 0));
  }

  void _dropPiece(int col) {
    if (_winner != null) return;
    for (int row = 5; row >= 0; row--) {
      if (_board[row][col] == 0) {
        setState(() {
          _board[row][col] = _currentPlayer;
          _checkWinner();
          _currentPlayer = _currentPlayer == 1 ? 2 : 1;
        });
        return;
      }
    }
  }

  void _checkWinner() {
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 7; col++) {
        if (_board[row][col] == 0) continue;
        if (col + 3 < 7 && _board[row][col] == _board[row][col + 1] &&
            _board[row][col] == _board[row][col + 2] && _board[row][col] == _board[row][col + 3]) {
          _winner = _board[row][col];
          return;
        }
        if (row + 3 < 6 && _board[row][col] == _board[row + 1][col] &&
            _board[row][col] == _board[row + 2][col] && _board[row][col] == _board[row + 3][col]) {
          _winner = _board[row][col];
          return;
        }
        if (row + 3 < 6 && col + 3 < 7 && _board[row][col] == _board[row + 1][col + 1] &&
            _board[row][col] == _board[row + 2][col + 2] && _board[row][col] == _board[row + 3][col + 3]) {
          _winner = _board[row][col];
          return;
        }
        if (row + 3 < 6 && col - 3 >= 0 && _board[row][col] == _board[row + 1][col - 1] &&
            _board[row][col] == _board[row + 2][col - 2] && _board[row][col] == _board[row + 3][col - 3]) {
          _winner = _board[row][col];
          return;
        }
      }
    }
  }

  void _reset() {
    setState(() {
      _board = List.generate(6, (_) => List.filled(7, 0));
      _currentPlayer = 1;
      _winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect 4')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner != null ? 'Player $_winner Wins!' : 'Player $_currentPlayer\'s Turn',
            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: List.generate(6, (row) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(7, (col) => GestureDetector(
                  onTap: () => _dropPiece(col),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _board[row][col] == 0
                          ? Colors.grey[800]
                          : _board[row][col] == 1 ? Colors.red : Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                )),
              )),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _reset,
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}