import 'package:flutter/material.dart';
import 'games/connect4.dart';
import 'games/tictactoe.dart';
import 'games/snake.dart';
import 'games/tetris.dart';
import 'games/chess.dart';
import 'games/wordle.dart';
import 'screens/league_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/external_links_screen.dart';

void main() {
  runApp(const PincGamesApp());
}

class PincGamesApp extends StatelessWidget {
  const PincGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PINC Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A2E),
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const GamesListScreen(),
    const LeagueScreen(),
    const ChallengeScreen(),
    const ExternalLinksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'League',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_score),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: 'External',
          ),
        ],
      ),
    );
  }
}

class GamesListScreen extends StatelessWidget {
  const GamesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {'name': 'Connect 4', 'icon': Icons.grid_4x4, 'color': Colors.blue},
      {'name': 'Tic Tac Toe', 'icon': Icons.apps, 'color': Colors.green},
      {'name': 'Snake', 'icon': Icons.restaurant, 'color': Colors.orange},
      {'name': 'Tetris', 'icon': Icons.view_comfy, 'color': Colors.purple},
      {'name': 'Chess', 'icon': Icons.extension, 'color': Colors.brown},
      {'name': 'Wordle', 'icon': Icons.text_fields, 'color': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PINC Games', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
            onTap: () => _navigateToGame(context, index),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (game['color'] as Color).withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: (game['color'] as Color).withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(game['icon'] as IconData, size: 48, color: game['color'] as Color),
                  const SizedBox(height: 8),
                  Text(
                    game['name'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToGame(BuildContext context, int index) {
    Widget? gameScreen;
    switch (index) {
      case 0:
        gameScreen = const Connect4Screen();
        break;
      case 1:
        gameScreen = const TicTacToeScreen();
        break;
      case 2:
        gameScreen = const SnakeScreen();
        break;
      case 3:
        gameScreen = const TetrisScreen();
        break;
      case 4:
        gameScreen = const ChessScreen();
        break;
      case 5:
        gameScreen = const WordleScreen();
        break;
    }
    if (gameScreen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
    }
  }
}