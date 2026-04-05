/// PINC Wallet Model
import 'package:flutter/foundation.dart';

enum TransactionType { send, receive, escrowDeposit, escrowRelease, escrowRefund, fee, deposit, withdrawal }
enum TransactionStatus { pending, completed, failed, cancelled }
enum EscrowStatus { pending, funded, released, refunded, cancelled }

@immutable
class WalletModel {
  final String id;
  final double balance;
  final double reservedBalance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WalletModel({
    required this.id,
    required this.balance,
    required this.reservedBalance,
    this.currency = 'USD',
    required this.createdAt,
    required this.updatedAt,
  });

  double get availableBalance => balance - reservedBalance;

  WalletModel copyWith({
    String? id,
    double? balance,
    double? reservedBalance,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      reservedBalance: reservedBalance ?? this.reservedBalance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'balance': balance,
    'reservedBalance': reservedBalance,
    'currency': currency,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    id: json['id'],
    balance: json['balance'].toDouble(),
    reservedBalance: json['reservedBalance'].toDouble(),
    currency: json['currency'] ?? 'USD',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

@immutable
class TransactionModel {
  final String id;
  final String walletId;
  final TransactionType type;
  final double amount;
  final double fee;
  final double netAmount;
  final String? recipientId;
  final String? senderId;
  final String? description;
  final TransactionStatus status;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.fee,
    required this.netAmount,
    this.recipientId,
    this.senderId,
    this.description,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'walletId': walletId,
    'type': type.name,
    'amount': amount,
    'fee': fee,
    'netAmount': netAmount,
    'recipientId': recipientId,
    'senderId': senderId,
    'description': description,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json['id'],
    walletId: json['walletId'],
    type: TransactionType.values.byName(json['type']),
    amount: json['amount'].toDouble(),
    fee: json['fee'].toDouble(),
    netAmount: json['netAmount'].toDouble(),
    recipientId: json['recipientId'],
    senderId: json['senderId'],
    description: json['description'],
    status: TransactionStatus.values.byName(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

@immutable
class EscrowModel {
  final String id;
  final String jobId;
  final String employerId;
  final String freelancerId;
  final double amount;
  final double platformFee;
  final double netAmount;
  final EscrowStatus status;
  final DateTime createdAt;
  final DateTime? fundedAt;
  final DateTime? releasedAt;

  const EscrowModel({
    required this.id,
    required this.jobId,
    required this.employerId,
    required this.freelancerId,
    required this.amount,
    required this.platformFee,
    required this.netAmount,
    required this.status,
    required this.createdAt,
    this.fundedAt,
    this.releasedAt,
  });

  EscrowModel copyWith({
    String? id,
    String? jobId,
    String? employerId,
    String? freelancerId,
    double? amount,
    double? platformFee,
    double? netAmount,
    EscrowStatus? status,
    DateTime? createdAt,
    DateTime? fundedAt,
    DateTime? releasedAt,
  }) {
    return EscrowModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      employerId: employerId ?? this.employerId,
      freelancerId: freelancerId ?? this.freelancerId,
      amount: amount ?? this.amount,
      platformFee: platformFee ?? this.platformFee,
      netAmount: netAmount ?? this.netAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      fundedAt: fundedAt ?? this.fundedAt,
      releasedAt: releasedAt ?? this.releasedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobId': jobId,
    'employerId': employerId,
    'freelancerId': freelancerId,
    'amount': amount,
    'platformFee': platformFee,
    'netAmount': netAmount,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'fundedAt': fundedAt?.toIso8601String(),
    'releasedAt': releasedAt?.toIso8601String(),
  };

  factory EscrowModel.fromJson(Map<String, dynamic> json) => EscrowModel(
    id: json['id'],
    jobId: json['jobId'],
    employerId: json['employerId'],
    freelancerId: json['freelancerId'],
    amount: json['amount'].toDouble(),
    platformFee: json['platformFee'].toDouble(),
    netAmount: json['netAmount'].toDouble(),
    status: EscrowStatus.values.byName(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
    fundedAt: json['fundedAt'] != null ? DateTime.parse(json['fundedAt']) : null,
    releasedAt: json['releasedAt'] != null ? DateTime.parse(json['releasedAt']) : null,
  );
}