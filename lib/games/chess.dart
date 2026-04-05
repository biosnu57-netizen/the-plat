import 'package:flutter/material.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({super.key});

  @override
  State<ChessScreen> createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  late List<List<String>> _board;
  String _currentPlayer = 'white';
  Point<int>? _selected;

  @override
  void initState() {
    super.initState();
    _board = List.generate(8, (row) => List.filled(8, ''));
    _setupBoard();
  }

  void _setupBoard() {
    final backRow = ['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'];
    for (int i = 0; i < 8; i++) {
      _board[0][i] = backRow[i];
      _board[1][i] = '♟';
      _board[6][i] = '♙';
      _board[7][i] = backRow[i].toUpperCase();
    }
  }

  void _onTap(int row, int col) {
    if (_selected == null) {
      setState(() => _selected = Point(row, col));
    } else {
      setState(() {
        _board[row][col] = _board[_selected!.y][_selected!.x];
        _board[_selected!.y][_selected!.x] = '';
        _selected = null;
        _currentPlayer = _currentPlayer == 'white' ? 'black' : 'white';
      });
    }
  }

  void _reset() {
    setState(() {
      _board = List.generate(8, (row) => List.filled(8, ''));
      _setupBoard();
      _currentPlayer = 'white';
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_currentPlayer.toUpperCase()}\'s Turn',
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: 320,
            height: 320,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemCount: 64,
              itemBuilder: (context, index) {
                final row = index ~/ 8;
                final col = index % 8;
                final isSelected = _selected?.x == col && _selected?.y == row;
                final isWhite = (row + col) % 2 == 0;
                return GestureDetector(
                  onTap: () => _onTap(row, col),
                  child: Container(
                    color: isSelected ? Colors.yellow : isWhite ? Colors.white : Colors.brown,
                    child: Center(
                      child: Text(
                        _board[row][col],
                        fontSize: 32,
                        color: _board[row][col].isNotEmpty && _board[row][col] == _board[row][col].toUpperCase() 
                            ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _reset, child: const Text('Reset Game')),
        ],
      ),
    );
  }
}