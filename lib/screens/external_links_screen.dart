import 'package:flutter/material.dart';

class ExternalLinksScreen extends StatefulWidget {
  const ExternalLinksScreen({super.key});

  @override
  State<ExternalLinksScreen> createState() => _ExternalLinksScreenState();
}

class _ExternalLinksScreenState extends State<ExternalLinksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Intelligence', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.visibility), text: 'Live View'),
            Tab(icon: Icon(Icons.people), text: 'Friends'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Global'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LiveGameViewer(),
          FriendsActivityScreen(),
          GlobalTournamentsScreen(),
        ],
      ),
    );
  }
}

// ===== LIVE GAME VIEWER =====
class LiveGameViewer extends StatefulWidget {
  const LiveGameViewer({super.key});

  @override
  State<LiveGameViewer> createState() => _LiveGameViewerState();
}

class _LiveGameViewerState extends State<LiveGameViewer> {
  final List<Map<String, dynamic>> _detectedGames = [
    {
      'game': 'PUBG Mobile',
      'icon': '🎯',
      'players': [
        {'name': 'DragonSlayer99', 'kills': 12, 'alive': true, 'rank': 3, 'squad': 'Alpha Team'},
        {'name': 'ShadowHunter', 'kills': 8, 'alive': true, 'rank': 7, 'squad': 'Alpha Team'},
        {'name': 'NightWolf', 'kills': 15, 'alive': false, 'rank': 1, 'squad': 'Beta Squad'},
      ],
      'matchId': 'PUBG-882734',
      'timeLeft': '12:34',
      'teamsAlive': 4,
    },
    {
      'game': 'PES 2024',
      'icon': '⚽',
      'players': [
        {'name': 'TeamAlpha_FC', 'score': '2-1', 'possession': '65%', 'shots': 8},
        {'name': 'RealMadrid_Fan', 'score': '1-2', 'possession': '35%', 'shots': 4},
      ],
      'matchId': 'PES-551289',
      'timeLeft': '67\'',
    },
    {
      'game': 'FIFA 24',
      'icon': '🏆',
      'players': [
        {'name': 'MessiLover', 'score': '3-0', 'possession': '70%', 'shots': 12},
        {'name': 'RonaldoStan', 'score': '0-3', 'possession': '30%', 'shots': 2},
      ],
      'matchId': 'FIFA-998211',
      'timeLeft': '78\'',
    },
    {
      'game': 'Mortal Kombat 11',
      'icon': '🥊',
      'players': [
        {'name': 'SubZero_King', 'rounds': 2, 'health': '45%'},
        {'name': 'Scorpion_Pro', 'rounds': 1, 'health': '20%'},
      ],
      'matchId': 'MK-334421',
      'round': 'Final Round',
    },
    {
      'game': 'Call of Duty',
      'icon': '🔫',
      'players': [
        {'name': 'SniperWolf', 'kills': 24, 'deaths': 3, 'score': 3200, 'team': 'Alpha'},
        {'name': 'TacticalGear', 'kills': 18, 'deaths': 5, 'score': 2800, 'team': 'Alpha'},
      ],
      'matchId': 'COD-776543',
      'mode': 'Team Deathmatch',
      'timeLeft': '8:45',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF1A1A2E),
          child: Row(
            children: [
              const Icon(Icons.radar, color: Colors.green, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '🔍 Scanning connected devices...',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('ACTIVE', style: TextStyle(color: Colors.green, fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _detectedGames.length,
            itemBuilder: (context, index) {
              final game = _detectedGames[index];
              return _buildGameCard(game);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Game Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(game['icon'], style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game['game'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Match: ${game['matchId']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    game['timeLeft'] ?? game['round'] ?? game['mode'],
                    style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Player Stats
          ...List.generate(game['players'].length, (i) {
            final player = game['players'][i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: i.isEven ? const Color(0xFF1A1A2E).withOpacity(0.5) : Colors.transparent,
                border: const Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  Icon(
                    player.containsKey('alive') 
                        ? (player['alive'] ? Icons.person : Icons.person_outline)
                        : player.containsKey('score') ? Icons.sports_soccer : Icons.sports_mma,
                    color: player.containsKey('alive') 
                        ? (player['alive'] ? Colors.green : Colors.red)
                        : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player['name'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        if (player.containsKey('squad')) 
                          Text('Squad: ${player['squad']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        if (player.containsKey('team')) 
                          Text('Team: ${player['team']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                  // Game-specific stats
                  if (player.containsKey('kills'))
                    _buildStatChip('${player['kills']} K', Colors.red),
                  if (player.containsKey('rank'))
                    _buildStatChip('#${player['rank']}', Colors.amber),
                  if (player.containsKey('score') && player['score'] is String)
                    _buildStatChip(player['score'], Colors.green),
                  if (player.containsKey('rounds'))
                    _buildStatChip('${player['rounds']}R', Colors.purple),
                  if (player.containsKey('deaths'))
                    _buildStatChip('${player['deaths']}D', Colors.orange),
                  if (player.containsKey('health'))
                    _buildStatChip(player['health'], Colors.red),
                  
                  IconButton(
                    icon: const Icon(Icons.sports_score, color: Colors.purple, size: 20),
                    onPressed: () => _showChallengeDialog(context, player['name'], game['game']),
                    tooltip: 'Challenge this player',
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _showChallengeDialog(BuildContext context, String opponent, String game) {
    final wagerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Challenge $opponent', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Game: $game', style: const TextStyle(color: Colors.purple)),
            const SizedBox(height: 16),
            TextField(
              controller: wagerController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Wager Amount (PINC)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Challenge sent to $opponent in $game!')),
              );
            },
            child: const Text('Send Challenge'),
          ),
        ],
      ),
    );
  }
}

// ===== FRIENDS ACTIVITY =====
class FriendsActivityScreen extends StatelessWidget {
  const FriendsActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friends = [
      {'name': 'GamerPro_2024', 'status': 'Playing PUBG', 'game': 'PUBG Mobile', 'kills': 8, 'alive': true, 'icon': '🎯'},
      {'name': 'FootballKing', 'status': 'In Match', 'game': 'FIFA 24', 'score': '1-0', 'minute': '34\'', 'icon': '🏆'},
      {'name': 'FightingChamp', 'status': 'In Fight', 'game': 'Mortal Kombat', 'round': 2, 'health': '65%', 'icon': '🥊'},
      {'name': 'COD_Sniper', 'status': 'In Game', 'game': 'Call of Duty', 'kills': 15, 'deaths': 2, 'icon': '🔫'},
      {'name': 'PES_Master', 'status': 'In Match', 'game': 'PES 2024', 'score': '0-0', 'minute': '12\'', 'icon': '⚽'},
      {'name': 'ChessGrandmaster', 'status': 'In Game', 'game': 'Chess', 'move': 'E4', 'icon': '♟️'},
      {'name': 'SnakeKing', 'status': 'Playing', 'game': 'Snake', 'score': 45, 'icon': '🐍'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.5)),
          ),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1A1A2E),
                  child: Text(friend['icon'], style: const TextStyle(fontSize: 24)),
                ),
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(Icons.circle, color: Colors.green, size: 12),
                ),
              ],
            ),
            title: Text(
              friend['name'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend['status'], style: const TextStyle(color: Colors.purple)),
                Text('${friend['game']} - ${friend.keys.contains('score') ? friend['score'] : friend.keys.contains('kills') ? '${friend['kills']} kills' : friend.keys.contains('move') ? 'Move: ${friend['move']}' : 'Score: ${friend['score']}'}', 
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (friend.keys.contains('alive'))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: friend['alive'] ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      friend['alive'] ? 'ALIVE' : 'ELIMINATED',
                      style: TextStyle(color: friend['alive'] ? Colors.green : Colors.red, fontSize: 10),
                    ),
                  ),
                const SizedBox(height: 4),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joining ${friend['name']} in ${friend['game']}...')),
                    );
                  },
                  child: const Text('Join', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===== GLOBAL TOURNAMENTS =====
class GlobalTournamentsScreen extends StatelessWidget {
  const GlobalTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tournaments = [
      {
        'name': 'PUBG World Cup 2024',
        'game': 'PUBG Mobile',
        'prize': '50,000 PINC',
        'teams': 32,
        'status': 'Live',
        'icon': '🎯',
      },
      {
        'name': 'FIFA Pro League',
        'game': 'FIFA 24',
        'prize': '25,000 PINC',
        'teams': 16,
        'status': 'Tomorrow',
        'icon': '🏆',
      },
      {
        'name': 'Street Fighter Championship',
        'game': 'Mortal Kombat',
        'prize': '15,000 PINC',
        'teams': 64,
        'status': 'Registration Open',
        'icon': '🥊',
      },
      {
        'name': 'PINC Chess Masters',
        'game': 'Chess',
        'prize': '10,000 PINC',
        'players': 128,
        'status': 'Live',
        'icon': '♟️',
      },
      {
        'name': 'Call of Duty: Warzone',
        'game': 'Call of Duty',
        'prize': '30,000 PINC',
        'teams': 50,
        'status': 'In 2 Hours',
        'icon': '🔫',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tournaments.length,
      itemBuilder: (context, index) {
        final tourney = tournaments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  children: [
                    Text(tourney['icon'], style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tourney['name'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            tourney['game'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tourney['status'] == 'Live' ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tourney['status'],
                        style: TextStyle(
                          color: tourney['status'] == 'Live' ? Colors.green : Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTourneyStat('Prize', tourney['prize'], Colors.amber),
                    _buildTourneyStat('Teams', '${tourney['teams'] ?? tourney['players']}', Colors.purple),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registered for ${tourney['name']}!')),
                        );
                      },
                      child: Text(tourney['status'] == 'Live' ? 'Watch' : 'Join'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTourneyStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}