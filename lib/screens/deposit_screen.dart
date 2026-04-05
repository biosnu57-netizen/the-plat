import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/fee_calculator.dart';

class DepositScreen extends StatefulWidget {
  final Function(double amount, String method) onDeposit;

  const DepositScreen({super.key, this.onDeposit});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'bank';
  bool _isLoading = false;

  double get _amount => double.tryParse(_amountController.text) ?? 0;
  double get _fee => FeeCalculator.calculateDepositFee(_amount);
  double get _netAmount => _amount - _fee;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _deposit() {
    if (_amount <= 0) return;

    setState(() => _isLoading = true);
    widget.onDeposit(_amount, _selectedMethod);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Funds'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _MethodCard(
              icon: Icons.account_balance,
              title: 'Bank Transfer',
              subtitle: 'Instant deposit via bank account',
              isSelected: _selectedMethod == 'bank',
              onTap: () => setState(() => _selectedMethod = 'bank'),
            ),
            const SizedBox(height: 12),
            _MethodCard(
              icon: Icons.credit_card,
              title: 'Debit/Credit Card',
              subtitle: 'Visa, Mastercard, AMEX',
              isSelected: _selectedMethod == 'card',
              onTap: () => setState(() => _selectedMethod = 'card'),
            ),
            const SizedBox(height: 12),
            _MethodCard(
              icon: Icons.phone_android,
              title: 'Mobile Money',
              subtitle: 'M-Pesa, Airtel Money',
              isSelected: _selectedMethod == 'mobile',
              onTap: () => setState(() => _selectedMethod = 'mobile'),
            ),
            const SizedBox(height: 24),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Fee Breakdown
            if (_amount > 0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _BreakdownRow(
                      label: 'You pay',
                      value: currencyFormat.format(_amount),
                    ),
                    _BreakdownRow(
                      label: 'Fee (1.5% + \$0.25)',
                      value: '-${currencyFormat.format(_fee)}',
                    ),
                    const Divider(),
                    _BreakdownRow(
                      label: 'Net deposit',
                      value: currencyFormat.format(_netAmount),
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _amount <= 0 ? null : _deposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Continue', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    this.icon,
    this.title,
    this.subtitle,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF6366F1)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF6366F1)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _BreakdownRow({this.label, this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}