import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';

abstract interface class WalletRepository {

  Future<Result<Wallet, Failure>> getWallet();

  Future<Result<Wallet, Failure>> claimDailyReward();

  Future<Result<Wallet, Failure>> addCoins({
    required int amount,
    required String title,
  });
}
