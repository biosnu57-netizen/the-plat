import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wallet_model.dart';
import '../services/fee_calculator.dart';

class EscrowScreen extends StatefulWidget {
  final double availableBalance;
  final List<EscrowModel> escrows;
  final Function(String jobId, String freelancerId, double amount) onCreateEscrow;
  final Function(String escrowId) onFund;
  final Function(String escrowId) onRelease;
  final Function(String escrowId) onRefund;

  const EscrowScreen({
    super.key,
    this.availableBalance,
    this.escrows,
    this.onCreateEscrow,
    this.onFund,
    this.onRelease,
    this.onRefund,
  });

  @override
  State<EscrowScreen> createState() => _EscrowScreenState();
}

class _EscrowScreenState extends State<EscrowScreen> {
  final _jobIdController = TextEditingController();
  final _freelancerIdController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isCreatingNew = false;

  double get _amount => double.tryParse(_amountController.text) ?? 0;
  bool get _canCreate => FeeCalculator.hasSufficientEscrowBalance(widget.availableBalance, _amount);

  @override
  void dispose() {
    _jobIdController.dispose();
    _freelancerIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _createEscrow() {
    if (_jobIdController.text.isEmpty || _freelancerIdController.text.isEmpty || _amount <= 0) return;
    if (!_canCreate) return;

    widget.onCreateEscrow(
      _jobIdController.text,
      _freelancerIdController.text,
      _amount,
    );
    setState(() => _isCreatingNew = false);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final activeEscrows = widget.escrows.where((e) => 
      e.status == EscrowStatus.pending || e.status == EscrowStatus.funded
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Escrow'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _isCreatingNew = !_isCreatingNew),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Funds are held securely until job is completed. Employer pays the platform fee.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Available Balance
            Text(
              'Available: ${currencyFormat.format(widget.availableBalance)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Create New Escrow Form
            if (_isCreatingNew) ...[
              const Text(
                'Create New Escrow',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jobIdController,
                decoration: InputDecoration(
                  labelText: 'Job ID',
                  prefixIcon: const Icon(Icons.work),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _freelancerIdController,
                decoration: InputDecoration(
                  labelText: 'Freelancer ID',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Job Amount',
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: '\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              if (_amount > 0) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('Job Amount: ${currencyFormat.format(_amount)}'),
                      Text('Platform Fee: +${currencyFormat.format(FeeCalculator.calculateEscrowFee(_amount))}'),
                      Text(
                        'Total Required: ${currencyFormat.format(FeeCalculator.calculateTotalEscrowAmount(_amount))}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (!_canCreate)
                  const Text(
                    'Insufficient balance for this escrow',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreate ? _createEscrow : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Create Escrow'),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Active Escrows
            const Text(
              'Active Escrows',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (activeEscrows.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No active escrows',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...activeEscrows.map((escrow) => _EscrowCard(
                escrow: escrow,
                onFund: () => widget.onFund(escrow.id),
                onRelease: () => widget.onRelease(escrow.id),
                onRefund: () => widget.onRefund(escrow.id),
              )),
          ],
        ),
      ),
    );
  }
}

class _EscrowCard extends StatelessWidget {
  final EscrowModel escrow;
  final VoidCallback onFund;
  final VoidCallback onRelease;
  final VoidCallback onRefund;

  const _EscrowCard({
    this.escrow,
    this.onFund,
    this.onRelease,
    this.onRefund,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final isPending = escrow.status == EscrowStatus.pending;
    final isFunded = escrow.status == EscrowStatus.funded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Job: ${escrow.jobId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isFunded ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isFunded ? 'Funded' : 'Pending',
                  style: TextStyle(
                    color: isFunded ? Colors.green : Colors.orange,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Amount: ${currencyFormat.format(escrow.amount)}'),
          Text(
            'Platform Fee: ${currencyFormat.format(escrow.platformFee)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isPending)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onFund,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Fund'),
                  ),
                ),
              if (isFunded) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRelease,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Release'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRefund,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Refund'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}