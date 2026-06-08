import 'package:flutter_test/flutter_test.dart';
import 'package:lovia/core/error/exceptions.dart';
import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/wallet/data/datasources/wallet_local_data_source.dart';
import 'package:lovia/features/wallet/data/models/wallet_model.dart';
import 'package:lovia/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/domain/usecases/claim_daily_reward.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletLocal extends Mock implements WalletLocalDataSource {}

void main() {
  late MockWalletLocal local;
  late WalletRepositoryImpl repo;

  const model = WalletModel(coins: 200, diamonds: 5, transactions: []);

  setUp(() {
    local = MockWalletLocal();
    repo = WalletRepositoryImpl(local);
  });

  test('getWallet maps the DTO to an entity', () async {
    when(() => local.fetch()).thenAnswer((_) async => model);
    final result = await repo.getWallet();
    final wallet = (result as Success<Wallet, Failure>).value;
    expect(wallet.coins, 200);
    expect(wallet.diamonds, 5);
  });

  test('claimDailyReward returns the updated wallet', () async {
    when(() => local.claimDaily()).thenAnswer(
      (_) async => const WalletModel(coins: 250, diamonds: 5, transactions: []),
    );
    final result = await ClaimDailyReward(repo)(const NoParams());
    expect((result as Success<Wallet, Failure>).value.coins, 250);
  });

  test('claimDailyReward maps an already-claimed CacheException to ValidationFailure',
      () async {
    when(() => local.claimDaily())
        .thenThrow(const CacheException('Daily reward already claimed today.'));
    final result = await repo.claimDailyReward();
    expect((result as Failed).failure, isA<ValidationFailure>());
  });
}
