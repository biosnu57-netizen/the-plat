import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeScreen extends StatefulWidget {
  const SnakeScreen({super.key});

  @override
  State<SnakeScreen> createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  static const int gridSize = 20;
  List<Point<int>> _snake = [const Point(10, 10)];
  Point<int> _food = const Point(5, 5);
  Point<int> _direction = const Point(0, -1);
  bool _gameOver = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (_) => _update());
  }

  void _update() {
    if (_gameOver) return;
    
    final newHead = Point(_snake.first.x + _direction.x, _snake.first.y + _direction.y);
    
    if (newHead.x < 0 || newHead.x >= gridSize || newHead.y < 0 || newHead.y >= gridSize ||
        _snake.contains(newHead)) {
      setState(() => _gameOver = true);
      _timer?.cancel();
      return;
    }

    setState(() {
      _snake.insert(0, newHead);
      if (newHead == _food) {
        _generateFood();
      } else {
        _snake.removeLast();
      }
    });
  }

  void _generateFood() {
    Random random = Random();
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (_snake.contains(newFood));
    _food = newFood;
  }

  void _reset() {
    setState(() {
      _snake = [const Point(10, 10)];
      _food = const Point(5, 5);
      _direction = const Point(0, -1);
      _gameOver = false;
    });
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
      appBar: AppBar(title: const Text('Snake')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _gameOver ? 'Game Over! Score: ${_snake.length - 1}' : 'Score: ${_snake.length - 1}',
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final x = index % gridSize;
                final y = index ~/ gridSize;
                final point = Point(x, y);
                final isSnake = _snake.contains(point);
                final isFood = point == _food;
                return Container(
                  color: isSnake ? Colors.green : isFood ? Colors.red : Colors.black,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward, size: 40),
                onPressed: () => setState(() => _direction = const Point(0, -1)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 40),
                onPressed: () => setState(() => _direction = const Point(-1, 0)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, size: 40),
                onPressed: () => setState(() => _direction = const Point(0, 1)),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 40),
                onPressed: () => setState(() => _direction = const Point(1, 0)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _reset,
            child: const Text('Reset Game'),
          ),
        ],
      ),
    );
  }
}