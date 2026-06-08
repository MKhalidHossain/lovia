import 'package:get/get.dart';
import 'package:lovia/core/result/result.dart';
import 'package:lovia/core/state/view_state.dart';
import 'package:lovia/core/usecase/usecase.dart';
import 'package:lovia/features/wallet/domain/entities/wallet.dart';
import 'package:lovia/features/wallet/domain/usecases/add_coins.dart';
import 'package:lovia/features/wallet/domain/usecases/claim_daily_reward.dart';
import 'package:lovia/features/wallet/domain/usecases/get_wallet.dart';

class WalletController extends GetxController {
  WalletController({
    required GetWallet getWallet,
    required ClaimDailyReward claimDailyReward,
    required AddCoins addCoins,
  })  : _getWallet = getWallet,
        _claimDailyReward = claimDailyReward,
        _addCoins = addCoins;

  final GetWallet _getWallet;
  final ClaimDailyReward _claimDailyReward;
  final AddCoins _addCoins;

  final Rx<ViewState<Wallet>> state = const ViewState<Wallet>.initial().obs;
  final RxBool isClaiming = false.obs;

  int get balance => switch (state.value) {
        ViewLoaded<Wallet>(:final data) => data.coins,
        _ => 0,
      };

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = const ViewState<Wallet>.loading();
    final result = await _getWallet(const NoParams());
    state.value = switch (result) {
      Success(:final value) => ViewState<Wallet>.loaded(value),
      Failed(:final failure) => ViewState<Wallet>.error(failure.message),
    };
  }

  Future<bool> buyGems(int amount, String title) async {
    final result = await _addCoins(AddCoinsParams(amount: amount, title: title));
    if (result case Success(:final value)) {
      state.value = ViewState<Wallet>.loaded(value);
      return true;
    }
    return false;
  }

  Future<void> claimDaily() async {
    isClaiming.value = true;
    final result = await _claimDailyReward(const NoParams());
    isClaiming.value = false;
    switch (result) {
      case Success(:final value):
        state.value = ViewState<Wallet>.loaded(value);
        Get.snackbar('Reward claimed', '+50 coins added to your wallet.');
      case Failed(:final failure):
        Get.snackbar('Check-in', failure.message);
    }
  }
}
