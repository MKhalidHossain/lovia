import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/domain/repositories/wallet_repository.dart';

class ClaimDailyReward implements UseCase<Wallet, NoParams> {
  const ClaimDailyReward(this._repository);
  final WalletRepository _repository;

  @override
  Future<Result<Wallet, Failure>> call(NoParams params) {
    return _repository.claimDailyReward();
  }
}
