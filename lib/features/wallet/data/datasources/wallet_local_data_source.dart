import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:lovia/core/constants/app_durations.dart';
import 'package:lovia/core/constants/storage_keys.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/features/wallet/data/models/wallet_model.dart';
import 'package:lovia/features/wallet/data/models/wallet_transaction_model.dart';

abstract interface class WalletLocalDataSource {
  Future<WalletModel> fetch();

  Future<WalletModel> claimDaily();

  Future<WalletModel> addCoins(int amount, String title);
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  WalletLocalDataSourceImpl(this._box);
  final GetStorage _box;

  static const int _dailyReward = 50;
  static const int _startingCoins = 200;
  static const int _startingDiamonds = 5;

  @override
  Future<WalletModel> fetch() async {
    await Future<void>.delayed(AppDurations.mockLatency);
    return _read();
  }

  @override
  Future<WalletModel> claimDaily() async {
    await Future<void>.delayed(AppDurations.fast);
    final current = _read();
    if (!_canCheckIn(current.lastCheckInMs)) {
      throw const CacheException('Daily reward already claimed today.');
    }
    final now = DateTime.now();
    final reward = WalletTransactionModel(
      id: 'tx-${now.microsecondsSinceEpoch}',
      title: 'Daily check-in reward',
      amount: _dailyReward,
      isDiamond: false,
      atMs: now.millisecondsSinceEpoch,
    );
    final updated = WalletModel(
      coins: current.coins + _dailyReward,
      diamonds: current.diamonds,
      transactions: [reward, ...current.transactions],
      lastCheckInMs: now.millisecondsSinceEpoch,
    );
    _write(updated);
    return updated;
  }

  @override
  Future<WalletModel> addCoins(int amount, String title) async {
    await Future<void>.delayed(AppDurations.fast);
    final current = _read();
    final now = DateTime.now();
    final tx = WalletTransactionModel(
      id: 'tx-${now.microsecondsSinceEpoch}',
      title: title,
      amount: amount,
      isDiamond: false,
      atMs: now.millisecondsSinceEpoch,
    );
    final updated = WalletModel(
      coins: current.coins + amount,
      diamonds: current.diamonds,
      transactions: [tx, ...current.transactions],
      lastCheckInMs: current.lastCheckInMs,
    );
    _write(updated);
    return updated;
  }

  bool _canCheckIn(int? lastMs) {
    if (lastMs == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    final now = DateTime.now();
    return last.year != now.year ||
        last.month != now.month ||
        last.day != now.day;
  }

  WalletModel _read() {
    final raw = _box.read<String>(StorageKeys.walletState);
    if (raw == null || raw.isEmpty) {
      return const WalletModel(
        coins: _startingCoins,
        diamonds: _startingDiamonds,
        transactions: [
          WalletTransactionModel(
            id: 'tx-welcome',
            title: 'Welcome bonus',
            amount: _startingCoins,
            isDiamond: false,
            atMs: 0,
          ),
        ],
      );
    }
    try {
      return WalletModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return const WalletModel(
        coins: _startingCoins,
        diamonds: _startingDiamonds,
        transactions: [],
      );
    }
  }

  void _write(WalletModel wallet) {
    try {
      _box.write(StorageKeys.walletState, jsonEncode(wallet.toJson()));
    } on Object catch (e) {
      throw CacheException('Failed to persist wallet: $e');
    }
  }
}
