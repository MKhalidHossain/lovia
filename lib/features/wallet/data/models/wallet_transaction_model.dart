import 'package:json_annotation/json_annotation.dart';
import 'package:lovia/features/wallet/domain/entities/wallet_transaction.dart';

part 'wallet_transaction_model.g.dart';

@JsonSerializable()
class WalletTransactionModel {
  const WalletTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isDiamond,
    required this.atMs,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  factory WalletTransactionModel.fromEntity(WalletTransaction t) =>
      WalletTransactionModel(
        id: t.id,
        title: t.title,
        amount: t.amount,
        isDiamond: t.isDiamond,
        atMs: t.at.millisecondsSinceEpoch,
      );

  final String id;
  final String title;
  final int amount;
  final bool isDiamond;
  final int atMs;

  Map<String, dynamic> toJson() => _$WalletTransactionModelToJson(this);

  WalletTransaction toEntity() => WalletTransaction(
        id: id,
        title: title,
        amount: amount,
        isDiamond: isDiamond,
        at: DateTime.fromMillisecondsSinceEpoch(atMs),
      );
}
