import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lovia/features/wallet/domain/entities/wallet_transaction.dart';

part 'wallet.freezed.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int coins,
    required int diamonds,
    required List<WalletTransaction> transactions,
    DateTime? lastCheckIn,
  }) = _Wallet;
  const Wallet._();

  bool get canCheckInToday {
    final last = lastCheckIn;
    if (last == null) return true;
    final now = DateTime.now();
    return last.year != now.year ||
        last.month != now.month ||
        last.day != now.day;
  }
}
