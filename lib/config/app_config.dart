/// PINC Finance App Configuration

class AppConfig {
  static const appName = 'PINC Finance';
  static const appVersion = '1.0.0';
  
  static const defaultCurrency = 'USD';
  static const supportedCurrencies = ['USD', 'EUR', 'GBP', 'KES', 'NGN'];
  
  static const minDepositAmount = 1.0;
  static const maxDepositAmount = 100000.0;
  
  static const minWithdrawalAmount = 1.0;
  static const maxWithdrawalAmount = 50000.0;
  
  static const minSendAmount = 0.50;
  static const maxSendAmount = 25000.0;
  
  static const apiBaseUrl = 'https://api.pinc.finance';
  static const apiTimeout = 30;
}

class AppColors {
  static const primary = 0xFF6366F1;
  static const primaryLight = 0xFF8B5CF6;
  static const secondary = 0xFF10B981;
  static const error = 0xFFEF4444;
  static const warning = 0xFFF59E0B;
  static const background = 0xFFF9FAFB;
  static const surface = 0xFFFFFFFF;
  static const textPrimary = 0xFF1F2937;
  static const textSecondary = 0xFF6B7280;
}

class AppStrings {
  static const appName = 'PINC Finance';
  static const tagline = 'Secure Payments & Wallet';
  static const welcome = 'Welcome to PINC Finance';
  static const description = 'Send, receive, and manage your money with confidence.';
}