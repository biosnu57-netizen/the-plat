/// PINC Fee Calculation Service
/// Exact fees as specified by the user

class FeeConfig {
  // Send money fees (percentage + fixed)
  static const double sendPercentFee = 2.5; // 2.5%
  static const double sendFixedFee = 0.10; // $0.10 flat
  
  // Receive money fees
  static const double receivePercentFee = 1.0; // 1.0%
  static const double receiveFixedFee = 0.05; // $0.05 flat
  
  // Deposit fees
  static const double depositPercentFee = 1.5; // 1.5%
  static const double depositFixedFee = 0.25; // $0.25
  
  // Withdrawal fees
  static const double withdrawalPercentFee = 2.0; // 2.0%
  static const double withdrawalFixedFee = 0.50; // $0.50
  
  // Escrow fees (platform fee for job escrow)
  static const double escrowPercentFee = 5.0; // 5%
  static const double escrowFixedFee = 0.25; // $0.25
  
  // Currency conversion fee
  static const double conversionPercentFee = 3.0; // 3.0%
  
  // Minimum fees
  static const double minSendFee = 0.50; // $0.50 minimum
  static const double minEscrowFee = 1.00; // $1.00 minimum
}

class FeeCalculator {
  /// Calculate fee for sending money
  static double calculateSendFee(double amount) {
    final percentFee = amount * (FeeConfig.sendPercentFee / 100);
    final totalFee = percentFee + FeeConfig.sendFixedFee;
    return totalFee < FeeConfig.minSendFee ? FeeConfig.minSendFee : totalFee;
  }
  
  /// Calculate net amount after fee (what recipient gets)
  static double calculateSendNetAmount(double amount) {
    final fee = calculateSendFee(amount);
    return amount - fee;
  }
  
  /// Calculate fee for receiving money
  static double calculateReceiveFee(double amount) {
    final percentFee = amount * (FeeConfig.receivePercentFee / 100);
    final totalFee = percentFee + FeeConfig.receiveFixedFee;
    return totalFee;
  }
  
  /// Calculate fee for deposits
  static double calculateDepositFee(double amount) {
    final percentFee = amount * (FeeConfig.depositPercentFee / 100);
    final totalFee = percentFee + FeeConfig.depositFixedFee;
    return totalFee;
  }
  
  /// Calculate net deposit amount
  static double calculateNetDeposit(double amount) {
    final fee = calculateDepositFee(amount);
    return amount - fee;
  }
  
  /// Calculate fee for withdrawals
  static double calculateWithdrawalFee(double amount) {
    final percentFee = amount * (FeeConfig.withdrawalPercentFee / 100);
    final totalFee = percentFee + FeeConfig.withdrawalFixedFee;
    return totalFee;
  }
  
  /// Calculate net withdrawal amount (what user gets after fee)
  static double calculateNetWithdrawal(double amount) {
    final fee = calculateWithdrawalFee(amount);
    return amount - fee;
  }
  
  /// Calculate escrow platform fee (employer pays this on top of job amount)
  static double calculateEscrowFee(double jobAmount) {
    final percentFee = jobAmount * (FeeConfig.escrowPercentFee / 100);
    final totalFee = percentFee + FeeConfig.escrowFixedFee;
    return totalFee < FeeConfig.minEscrowFee ? FeeConfig.minEscrowFee : totalFee;
  }
  
  /// Calculate total escrow amount (job amount + platform fee)
  static double calculateTotalEscrowAmount(double jobAmount) {
    return jobAmount + calculateEscrowFee(jobAmount);
  }
  
  /// Calculate net escrow for freelancer (what they receive when released)
  static double calculateEscrowNetAmount(double jobAmount) {
    // Freelancer receives the full job amount (employer paid fee)
    return jobAmount;
  }
  
  /// Calculate currency conversion fee
  static double calculateConversionFee(double amount) {
    return amount * (FeeConfig.conversionPercentFee / 100);
  }
  
  /// Get fee breakdown for a send transaction
  static Map<String, double> getSendFeeBreakdown(double amount) {
    final fee = calculateSendFee(amount);
    final netAmount = amount - fee;
    return {
      'grossAmount': amount,
      'percentFee': amount * (FeeConfig.sendPercentFee / 100),
      'fixedFee': FeeConfig.sendFixedFee,
      'totalFee': fee,
      'netAmount': netAmount,
    };
  }
  
  /// Get fee breakdown for escrow
  static Map<String, double> getEscrowFeeBreakdown(double jobAmount) {
    final platformFee = calculateEscrowFee(jobAmount);
    final totalAmount = jobAmount + platformFee;
    return {
      'jobAmount': jobAmount,
      'percentFee': jobAmount * (FeeConfig.escrowPercentFee / 100),
      'fixedFee': FeeConfig.escrowFixedFee,
      'platformFee': platformFee,
      'totalAmount': totalAmount,
      'freelancerNetAmount': jobAmount,
    };
  }
  
  /// Validate if amount is valid for transaction
  static bool isValidAmount(double amount) {
    return amount > 0 && amount.isFinite;
  }
  
  /// Validate if wallet has sufficient balance including fee
  static bool hasSufficientBalance(double balance, double amount) {
    final fee = calculateSendFee(amount);
    return balance >= (amount + fee);
  }
  
  /// Validate if wallet has sufficient balance for escrow
  static bool hasSufficientEscrowBalance(double balance, double jobAmount) {
    final totalAmount = calculateTotalEscrowAmount(jobAmount);
    return balance >= totalAmount;
  }
}