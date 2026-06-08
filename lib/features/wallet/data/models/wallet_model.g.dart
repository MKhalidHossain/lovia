// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => WalletModel(
  coins: (json['coins'] as num).toInt(),
  diamonds: (json['diamonds'] as num).toInt(),
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  lastCheckInMs: (json['lastCheckInMs'] as num?)?.toInt(),
);

Map<String, dynamic> _$WalletModelToJson(WalletModel instance) =>
    <String, dynamic>{
      'coins': instance.coins,
      'diamonds': instance.diamonds,
      'transactions': instance.transactions.map((e) => e.toJson()).toList(),
      'lastCheckInMs': instance.lastCheckInMs,
    };
