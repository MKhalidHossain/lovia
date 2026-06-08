import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';

part 'wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletModel {
  const WalletModel({
    required this.coins,
    required this.diamonds,
    required this.transactions,
    this.lastCheckInMs,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  factory WalletModel.fromEntity(Wallet w) => WalletModel(
        coins: w.coins,
        diamonds: w.diamonds,
        transactions:
            w.transactions.map(WalletTransactionModel.fromEntity).toList(),
        lastCheckInMs: w.lastCheckIn?.millisecondsSinceEpoch,
      );

  final int coins;
  final int diamonds;
  final List<WalletTransactionModel> transactions;
  final int? lastCheckInMs;

  Map<String, dynamic> toJson() => _$WalletModelToJson(this);

  Wallet toEntity() => Wallet(
        coins: coins,
        diamonds: diamonds,
        transactions: transactions.map((t) => t.toEntity()).toList(),
        lastCheckIn: lastCheckInMs == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(lastCheckInMs!),
      );
}
