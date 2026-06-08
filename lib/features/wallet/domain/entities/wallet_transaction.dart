import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_transaction.freezed.dart';

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    required String title,
    required int amount,
    required bool isDiamond,
    required DateTime at,
  }) = _WalletTransaction;
}
