import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/fee_calculator.dart';

class SendMoneyScreen extends StatefulWidget {
  final double availableBalance;
  final Function(double amount, String recipientId, String? note)? onSend;

  const SendMoneyScreen({
    super.key,
    this.availableBalance = 0.0,
    this.onSend,
  });

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  double get _amount => double.tryParse(_amountController.text) ?? 0;
  double get _fee => FeeCalculator.calculateSendFee(_amount);
  double get _total => _amount + _fee;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _send() {
    if (_recipientController.text.isEmpty) {
      setState(() => _error = 'Please enter recipient ID');
      return;
    }
    if (_amount <= 0) {
      setState(() => _error = 'Please enter valid amount');
      return;
    }
    if (_total > widget.availableBalance) {
      setState(() => _error = 'Insufficient balance');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    widget.onSend(_amount, _recipientController.text, _noteController.text);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(
                labelText: 'Recipient ID / Phone',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 24),

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
                      label: 'Amount',
                      value: currencyFormat.format(_amount),
                    ),
                    _BreakdownRow(
                      label: 'Fee (2.5% + \$0.10)',
                      value: '-${currencyFormat.format(_fee)}',
                    ),
                    const Divider(),
                    _BreakdownRow(
                      label: 'Total',
                      value: currencyFormat.format(_total),
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recipient receives: ${currencyFormat.format(_amount - _fee)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Note
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Add a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Available Balance
            Text(
              'Available: ${currencyFormat.format(widget.availableBalance)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Error
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _send,
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
                    : const Text(
                        'Send Money',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
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

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}