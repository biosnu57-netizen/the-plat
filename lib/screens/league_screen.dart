import 'package:flutter/material.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  final List<Map<String, dynamic>> _players = [
    {'name': 'Player1', 'points': 1500, 'rank': 1},
    {'name': 'Player2', 'points': 1450, 'rank': 2},
    {'name': 'Player3', 'points': 1400, 'rank': 3},
    {'name': 'Player4', 'points': 1350, 'rank': 4},
    {'name': 'Player5', 'points': 1300, 'rank': 5},
    {'name': 'Player6', 'points': 1250, 'rank': 6},
    {'name': 'Player7', 'points': 1200, 'rank': 7},
    {'name': 'Player8', 'points': 1150, 'rank': 8},
    {'name': 'Player9', 'points': 1100, 'rank': 9},
    {'name': 'Player10', 'points': 1050, 'rank': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('League', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Your Rank', '#5', Colors.gold),
                _buildStat('Points', '1300', Colors.purple),
                _buildStat('Wins', '12', Colors.green),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Season Leaderboard (Up to 50 players)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                    border: index < 3 ? Border.all(color: Colors.amber, width: 2) : null,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index == 0 ? Colors.amber : index == 1 ? Colors.grey : Colors.brown,
                      child: Text(
                        '${player['rank']}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      player['name'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${player['points']} pts',
                      style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}