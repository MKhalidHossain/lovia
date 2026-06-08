import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/domain/repositories/wallet_repository.dart';

class AddCoinsParams {
  const AddCoinsParams({required this.amount, required this.title});
  final int amount;
  final String title;
}

class AddCoins implements UseCase<Wallet, AddCoinsParams> {
  const AddCoins(this._repository);
  final WalletRepository _repository;

  @override
  Future<Result<Wallet, Failure>> call(AddCoinsParams params) {
    return _repository.addCoins(amount: params.amount, title: params.title);
  }
}
