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
            icon: Icon(Icons.bolt),
            label: 'Game Intel',
          ),
        ],
      ),
    );
  }
}

// ===== GAMES LIST SCREEN WITH FULL UI =====
class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final Set<int> _favorites = {};
  final List<int> _recentGames = [0, 4, 2]; // Indices of recent games

  final List<Map<String, dynamic>> _allGames = [
    {'name': 'Connect 4', 'icon': Icons.grid_4x4, 'color': Colors.blue, 'category': 'Classic', 'players': '2 Player', 'rating': 4.5},
    {'name': 'Tic Tac Toe', 'icon': Icons.apps, 'color': Colors.green, 'category': 'Classic', 'players': '2 Player', 'rating': 4.2},
    {'name': 'Snake', 'icon': Icons.restaurant, 'color': Colors.orange, 'category': 'Arcade', 'players': '1 Player', 'rating': 4.3},
    {'name': 'Tetris', 'icon': Icons.view_comfy, 'color': Colors.purple, 'category': 'Puzzle', 'players': '1 Player', 'rating': 4.8},
    {'name': 'Chess', 'icon': Icons.extension, 'color': Colors.brown, 'category': 'Strategy', 'players': '2 Player', 'rating': 4.9},
    {'name': 'Wordle', 'icon': Icons.text_fields, 'color': Colors.teal, 'category': 'Word', 'players': '1 Player', 'rating': 4.6},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredGames {
    if (_searchQuery.isEmpty) return _allGames;
    return _allGames.where((g) => g['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PINC Games', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => _showSearchDialog()),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Recent'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGameGrid(_allGames),
          _buildGameGrid(_allGames.where((g) => _favorites.contains(_allGames.indexOf(g))).toList()),
          _buildGameGrid(_recentGames.map((i) => _allGames[i]).toList()),
          _buildCategoriesView(),
        ],
      ),
    );
  }

  Widget _buildGameGrid(List<Map<String, dynamic>> games) {
    if (games.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.games, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text('No games found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        final isFav = _favorites.contains(index);
        return _buildGameCard(game, index, isFav);
      },
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game, int index, bool isFav) {
    return GestureDetector(
      onTap: () => _navigateToGame(context, _allGames.indexOf(game)),
      onLongPress: () {
        setState(() {
          if (isFav) {
            _favorites.remove(index);
          } else {
            _favorites.add(index);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isFav ? 'Removed from favorites' : 'Added to favorites')),
          duration: const Duration(seconds: 1),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF16213E),
              (game['color'] as Color).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (game['color'] as Color).withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: (game['color'] as Color).withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(game['icon'] as IconData, size: 56, color: game['color'] as Color),
                Positioned(
                  right: -8,
                  top: -8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isFav) {
                          _favorites.remove(index);
                        } else {
                          _favorites.add(index);
                        }
                      });
                    },
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              game['name'] as String,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (game['color'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                game['category'] as String,
                style: TextStyle(color: game['color'] as Color, fontSize: 12),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  game['players'] as String,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(width: 8),
                Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  '${game['rating']}',
                  style: TextStyle(color: Colors.amber, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesView() {
    final categories = {
      'Classic': ['Connect 4', 'Tic Tac Toe'],
      'Arcade': ['Snake'],
      'Puzzle': ['Tetris'],
      'Strategy': ['Chess'],
      'Word': ['Wordle'],
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: categories.entries.map((cat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            title: Text(cat.key, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            iconColor: Colors.purple,
            children: cat.value.map((gameName) {
              final gameIndex = _allGames.indexWhere((g) => g['name'] == gameName);
              return ListTile(
                leading: Icon(_allGames[gameIndex]['icon'] as IconData, color: _allGames[gameIndex]['color'] as Color),
                title: Text(gameName, style: const TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.play_arrow, color: Colors.purple),
                onTap: () => _navigateToGame(context, gameIndex),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Search Games', style: TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Type game name...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.purple),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
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
      // Add to recent games
      if (!_recentGames.contains(index)) {
        _recentGames.insert(0, index);
        if (_recentGames.length > 5) _recentGames.removeLast();
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => gameScreen));
    }
  }
}