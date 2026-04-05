import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final List<Map<String, dynamic>> _challenges = [
    {'id': 1, 'from': 'Player2', 'game': 'Chess', 'wager': 100, 'status': 'pending'},
    {'id': 2, 'from': 'Player5', 'game': 'Tetris', 'wager': 50, 'status': 'pending'},
    {'id': 3, 'from': 'Player8', 'game': 'Connect 4', 'wager': 75, 'status': 'accepted'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent),
            ),
            child: Column(
              children: [
                const Text(
                  'Create Challenge',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF16213E),
                        decoration: const InputDecoration(
                          labelText: 'Select Game',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Chess', child: Text('Chess', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Tetris', child: Text('Tetris', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Snake', child: Text('Snake', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Tic Tac Toe', child: Text('Tic Tac Toe', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Connect 4', child: Text('Connect 4', style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(value: 'Wordle', child: Text('Wordle', style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Wager',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {},
                  child: const Text('Send Challenge'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Incoming Challenges',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                final challenge = _challenges[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.sports_score, color: Colors.purple),
                    title: Text(
                      '${challenge['game']} vs ${challenge['from']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Wager: ${challenge['wager']} PINC',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: challenge['status'] == 'pending'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          )
                        : const Text('Active', style: TextStyle(color: Colors.green)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}