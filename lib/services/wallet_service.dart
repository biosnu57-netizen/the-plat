/// PINC Wallet Service
import 'package:uuid/uuid.dart';
import '../models/wallet_model.dart';
import 'fee_calculator.dart';

class WalletService {
  static const _uuid = Uuid();
  
  WalletModel? _currentWallet;
  final List<TransactionModel> _transactions = [];
  final List<EscrowModel> _escrows = [];
  
  /// Initialize wallet (create new or load existing)
  Future<WalletModel> initWallet(String userId) async {
    // In production, load from API/storage
    final now = DateTime.now();
    _currentWallet = WalletModel(
      id: _uuid.v4(),
      balance: 0.0,
      reservedBalance: 0.0,
      currency: 'USD',
      createdAt: now,
      updatedAt: now,
    );
    return _currentWallet!;
  }
  
  /// Get current wallet
  WalletModel? get currentWallet => _currentWallet;
  
  /// Get wallet balance
  double get balance => _currentWallet?.balance ?? 0.0;
  
  /// Get available balance (minus reserved)
  double get availableBalance => _currentWallet?.availableBalance ?? 0.0;
  
  /// Deposit funds to wallet
  Future<TransactionModel?> deposit({
    required double amount,
    required String method,
    String? description,
  }) async {
    if (!FeeCalculator.isValidAmount(amount)) return null;
    
    final fee = FeeCalculator.calculateDepositFee(amount);
    final netAmount = amount - fee;
    final now = DateTime.now();
    
    final transaction = TransactionModel(
      id: _uuid.v4(),
      walletId: _currentWallet!.id,
      type: TransactionType.deposit,
      amount: amount,
      fee: fee,
      netAmount: netAmount,
      description: description ?? 'Deposit via $method',
      status: TransactionStatus.completed,
      createdAt: now,
    );
    
    // Update wallet balance
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance + netAmount,
      updatedAt: now,
    );
    
    _transactions.add(transaction);
    return transaction;
  }
  
  /// Withdraw funds from wallet
  Future<TransactionModel?> withdraw({
    required double amount,
    required String method,
    String? description,
  }) async {
    if (!FeeCalculator.isValidAmount(amount)) return null;
    
    final fee = FeeCalculator.calculateWithdrawalFee(amount);
    final totalAmount = amount + fee;
    
    if (totalAmount > availableBalance) return null;
    
    final now = DateTime.now();
    final netAmount = amount - fee;
    
    final transaction = TransactionModel(
      id: _uuid.v4(),
      walletId: _currentWallet!.id,
      type: TransactionType.withdrawal,
      amount: amount,
      fee: fee,
      netAmount: netAmount,
      description: description ?? 'Withdrawal via $method',
      status: TransactionStatus.completed,
      createdAt: now,
    );
    
    // Update wallet balance
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance - totalAmount,
      updatedAt: now,
    );
    
    _transactions.add(transaction);
    return transaction;
  }
  
  /// Send money to another user
  Future<TransactionModel?> sendMoney({
    required double amount,
    required String recipientId,
    String? description,
  }) async {
    if (!FeeCalculator.isValidAmount(amount)) return null;
    
    final fee = FeeCalculator.calculateSendFee(amount);
    final totalAmount = amount + fee;
    
    if (totalAmount > availableBalance) return null;
    
    final now = DateTime.now();
    
    final transaction = TransactionModel(
      id: _uuid.v4(),
      walletId: _currentWallet!.id,
      type: TransactionType.send,
      amount: amount,
      fee: fee,
      netAmount: amount - fee,
      recipientId: recipientId,
      description: description ?? 'Send to $recipientId',
      status: TransactionStatus.completed,
      createdAt: now,
    );
    
    // Update wallet balance
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance - totalAmount,
      updatedAt: now,
    );
    
    _transactions.add(transaction);
    return transaction;
  }
  
  /// Receive money from another user
  Future<TransactionModel?> receiveMoney({
    required double amount,
    required String senderId,
    String? description,
  }) async {
    if (!FeeCalculator.isValidAmount(amount)) return null;
    
    final fee = FeeCalculator.calculateReceiveFee(amount);
    final netAmount = amount - fee;
    
    final now = DateTime.now();
    
    final transaction = TransactionModel(
      id: _uuid.v4(),
      walletId: _currentWallet!.id,
      type: TransactionType.receive,
      amount: amount,
      fee: fee,
      netAmount: netAmount,
      senderId: senderId,
      description: description ?? 'Receive from $senderId',
      status: TransactionStatus.completed,
      createdAt: now,
    );
    
    // Update wallet balance
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance + netAmount,
      updatedAt: now,
    );
    
    _transactions.add(transaction);
    return transaction;
  }
  
  /// Get transaction history
  List<TransactionModel> getTransactions({int? limit}) {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return limit != null ? sorted.take(limit).toList() : sorted;
  }
  
  /// Create escrow for job
  Future<EscrowModel?> createEscrow({
    required String jobId,
    required String freelancerId,
    required double amount,
  }) async {
    if (!FeeCalculator.isValidAmount(amount)) return null;
    
    final fee = FeeCalculator.calculateEscrowFee(amount);
    final totalAmount = amount + fee;
    
    if (totalAmount > availableBalance) return null;
    
    final now = DateTime.now();
    
    final escrow = EscrowModel(
      id: _uuid.v4(),
      jobId: jobId,
      employerId: _currentWallet!.id,
      freelancerId: freelancerId,
      amount: amount,
      platformFee: fee,
      netAmount: amount,
      status: EscrowStatus.pending,
      createdAt: now,
    );
    
    // Reserve funds in wallet
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance - totalAmount,
      reservedBalance: _currentWallet!.reservedBalance + totalAmount,
      updatedAt: now,
    );
    
    _escrows.add(escrow);
    return escrow;
  }
  
  /// Fund escrow (employer deposits funds)
  Future<EscrowModel?> fundEscrow(String escrowId) async {
    final index = _escrows.indexWhere((e) => e.id == escrowId);
    if (index == -1) return null;
    
    final escrow = _escrows[index];
    if (escrow.status != EscrowStatus.pending) return null;
    
    final now = DateTime.now();
    final fundedEscrow = escrow.copyWith(
      status: EscrowStatus.funded,
      fundedAt: now,
    );
    
    _escrows[index] = fundedEscrow;
    return fundedEscrow;
  }
  
  /// Release escrow to freelancer
  Future<EscrowModel?> releaseEscrow(String escrowId) async {
    final index = _escrows.indexWhere((e) => e.id == escrowId);
    if (index == -1) return null;
    
    final escrow = _escrows[index];
    if (escrow.status != EscrowStatus.funded) return null;
    
    final now = DateTime.now();
    final totalAmount = escrow.amount + escrow.platformFee;
    
    // Release from reserved
    _currentWallet = _currentWallet!.copyWith(
      reservedBalance: _currentWallet!.reservedBalance - totalAmount,
      updatedAt: now,
    );
    
    final releasedEscrow = escrow.copyWith(
      status: EscrowStatus.released,
      releasedAt: now,
    );
    
    _escrows[index] = releasedEscrow;
    return releasedEscrow;
  }
  
  /// Refund escrow to employer
  Future<EscrowModel?> refundEscrow(String escrowId) async {
    final index = _escrows.indexWhere((e) => e.id == escrowId);
    if (index == -1) return null;
    
    final escrow = _escrows[index];
    if (escrow.status != EscrowStatus.funded) return null;
    
    final now = DateTime.now();
    final totalAmount = escrow.amount + escrow.platformFee;
    
    // Release from reserved and return to balance
    _currentWallet = _currentWallet!.copyWith(
      balance: _currentWallet!.balance + totalAmount,
      reservedBalance: _currentWallet!.reservedBalance - totalAmount,
      updatedAt: now,
    );
    
    final refundedEscrow = escrow.copyWith(
      status: EscrowStatus.refunded,
    );
    
    _escrows[index] = refundedEscrow;
    return refundedEscrow;
  }
  
  /// Get all escrows
  List<EscrowModel> getEscrows({EscrowStatus? status}) {
    if (status != null) {
      return _escrows.where((e) => e.status == status).toList();
    }
    return List<EscrowModel>.from(_escrows);
  }
  
  /// Get active escrows
  List<EscrowModel> getActiveEscrows() {
    return _escrows.where((e) => 
      e.status == EscrowStatus.pending || 
      e.status == EscrowStatus.funded
    ).toList();
  }
}