import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  static const int rows = 20;
  static const int cols = 10;
  late List<List<int>> _board;
  List<Point<int>> _currentPiece = [];
  int _currentColor = 1;
  int _score = 0;
  bool _gameOver = false;
  Timer? _timer;

  final List<List<List<Point<int>>>> _pieces = [
    [[const Point(0,0), const Point(1,0), const Point(2,0), const Point(3,0)]], // I
    [[const Point(0,0), const Point(1,0), const Point(0,1), const Point(1,1)]], // O
    [[const Point(1,0), const Point(0,1), const Point(1,1), const Point(2,1)]], // T
    [[const Point(0,0), const Point(0,1), const Point(1,1), const Point(2,1)]], // L
    [[const Point(2,0), const Point(0,1), const Point(1,1), const Point(2,1)]], // J
    [[const Point(1,0), const Point(2,0), const Point(0,1), const Point(1,1)]], // S
    [[const Point(0,0), const Point(1,0), const Point(1,1), const Point(2,1)]], // Z
  ];

  @override
  void initState() {
    super.initState();
    _board = List.generate(rows, (_) => List.filled(cols, 0));
    _spawnPiece();
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => _update());
  }

  void _spawnPiece() {
    Random random = Random();
    final pieceIndex = random.nextInt(_pieces.length);
    _currentPiece = _pieces[pieceIndex].map((p) => Point(p.x + 4, p.y)).toList();
    _currentColor = random.nextInt(6) + 1;
    if (!_canMove(_currentPiece)) {
      setState(() => _gameOver = true);
      _timer?.cancel();
    }
  }

  bool _canMove(List<Point<int>> piece) {
    for (final p in piece) {
      if (p.x < 0 || p.x >= cols || p.y >= rows || (p.y >= 0 && _board[p.y][p.x] != 0)) {
        return false;
      }
    }
    return true;
  }

  void _update() {
    final newPiece = _currentPiece.map((p) => Point(p.x, p.y + 1)).toList();
    if (_canMove(newPiece)) {
      setState(() => _currentPiece = newPiece);
    } else {
      _lockPiece();
      _clearLines();
      _spawnPiece();
    }
  }

  void _lockPiece() {
    for (final p in _currentPiece) {
      if (p.y >= 0) _board[p.y][p.x] = _currentColor;
    }
    _score += 10;
  }

  void _clearLines() {
    for (int y = rows - 1; y >= 0; y--) {
      if (_board[y].every((cell) => cell != 0)) {
        setState(() {
          _board.removeAt(y);
          _board.insert(0, List.filled(cols, 0));
          _score += 100;
        });
      }
    }
  }

  void _moveLeft() {
    final newPiece = _currentPiece.map((p) => Point(p.x - 1, p.y)).toList();
    if (_canMove(newPiece)) setState(() => _currentPiece = newPiece);
  }

  void _moveRight() {
    final newPiece = _currentPiece.map((p) => Point(p.x + 1, p.y)).toList();
    if (_canMove(newPiece)) setState(() => _currentPiece = newPiece);
  }

  void _rotate() {
    if (_currentPiece.isEmpty) return;
    final center = _currentPiece[0];
    final newPiece = _currentPiece.map((p) {
      final dx = p.x - center.x;
      final dy = p.y - center.y;
      return Point(center.x - dy, center.y + dx);
    }).toList();
    if (_canMove(newPiece)) setState(() => _currentPiece = newPiece);
  }

  void _reset() {
    setState(() {
      _board = List.generate(rows, (_) => List.filled(cols, 0));
      _score = 0;
      _gameOver = false;
    });
    _spawnPiece();
    _timer?.cancel();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tetris')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score: $_score', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          if (_gameOver) const Text('Game Over!', style: TextStyle(fontSize: 24, color: Colors.red)),
          const SizedBox(height: 10),
          Container(
            width: 250,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                final x = index % cols;
                final y = index ~/ cols;
                final isPiece = _currentPiece.any((p) => p.x == x && p.y == y);
                final color = isPiece ? _currentColor : _board[y][x];
                return Container(color: color != 0 ? _getColor(color) : Colors.black);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back, size: 30), onPressed: _moveLeft),
              IconButton(icon: const Icon(Icons.arrow_upward, size: 30), onPressed: _rotate),
              IconButton(icon: const Icon(Icons.arrow_forward, size: 30), onPressed: _moveRight),
              IconButton(icon: const Icon(Icons.arrow_downward, size: 30), onPressed: _update),
            ],
          ),
          ElevatedButton(onPressed: _reset, child: const Text('Reset')),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    return [Colors.cyan, Colors.blue, Colors.orange, Colors.yellow, Colors.green, Colors.purple][index - 1];
  }
}