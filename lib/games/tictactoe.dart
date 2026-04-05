import 'package:flutter/material.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<String> _board;
  String _currentPlayer = 'X';
  String? _winner;

  @override
  void initState() {
    super.initState();
    _board = List.filled(9, '');
  }

  void _play(int index) {
    if (_board[index].isNotEmpty || _winner != null) return;
    setState(() {
      _board[index] = _currentPlayer;
      _checkWinner();
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
    });
  }

  void _checkWinner() {
    final lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (final line in lines) {
      if (_board[line[0]].isNotEmpty &&
          _board[line[0]] == _board[line[1]] &&
          _board[line[0]] == _board[line[2]]) {
        _winner = _board[line[0]];
        return;
      }
    }
  }

  void _reset() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'X';
      _winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner != null ? '$_winner Wins!' : '$_currentPlayer\'s Turn',
            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 9,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _play(index),
                child: Container(
                  color: const Color(0xFF16213E),
                  child: Center(
                    child: Text(
                      _board[index],
                      style: TextStyle(
                        fontSize: 48,
                        color: _board[index] == 'X' ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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