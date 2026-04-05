import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletHomeScreen extends StatelessWidget {
  final double balance;
  final double availableBalance;
  final int transactionCount;
  final VoidCallback? onSendMoney;
  final VoidCallback? onReceiveMoney;
  final VoidCallback? onDeposit;
  final VoidCallback? onWithdraw;
  final VoidCallback? onViewHistory;

  const WalletHomeScreen({
    super.key,
    this.balance = 0.0,
    this.availableBalance = 0.0,
    this.transactionCount = 0,
    this.onSendMoney,
    this.onReceiveMoney,
    this.onDeposit,
    this.onWithdraw,
    this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🏦 PINC Wallet',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currencyFormat.format(balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Available: ${currencyFormat.format(availableBalance)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.send,
                label: 'Send',
                onTap: onSendMoney,
              ),
              _ActionButton(
                icon: Icons.receive,
                label: 'Receive',
                onTap: onReceiveMoney,
              ),
              _ActionButton(
                icon: Icons.add_circle,
                label: 'Deposit',
                onTap: onDeposit,
              ),
              _ActionButton(
                icon: Icons.remove_circle,
                label: 'Withdraw',
                onTap: onWithdraw,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Recent Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewHistory,
                child: const Text('See All'),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          if (transactionCount == 0)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No transactions yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            const _TransactionTile(
              icon: Icons.arrow_downward,
              title: 'Deposit',
              amount: 500.00,
              status: 'Completed',
              time: 'Today, 2:30 PM',
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF6366F1)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double amount;
  final String status;
  final String time;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.amount,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final isPositive = icon == Icons.arrow_downward;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isPositive ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$status • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${currencyFormat.format(amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}