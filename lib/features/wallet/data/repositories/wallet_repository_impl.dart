import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/features/wallet/data/datasources/wallet_local_data_source.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._local);
  final WalletLocalDataSource _local;

  @override
  Future<Result<Wallet, Failure>> getWallet() async {
    try {
      return Success((await _local.fetch()).toEntity());
    } on Object catch (e) {
      return Failed(UnknownFailure('Could not load wallet: $e'));
    }
  }

  @override
  Future<Result<Wallet, Failure>> addCoins({
    required int amount,
    required String title,
  }) async {
    try {
      return Success((await _local.addCoins(amount, title)).toEntity());
    } on Object catch (e) {
      return Failed(UnknownFailure('Could not add coins: $e'));
    }
  }

  @override
  Future<Result<Wallet, Failure>> claimDailyReward() async {
    try {
      return Success((await _local.claimDaily()).toEntity());
    } on CacheException catch (e) {

      return Failed(ValidationFailure(message: e.message));
    } on Object catch (e) {
      return Failed(UnknownFailure('Could not claim reward: $e'));
    }
  }
}
