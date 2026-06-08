import 'package:lovia/core/error/failures.dart';
import 'package:lovia/core/result/result.dart';

// ignore: one_member_abstracts — intentional single-action contract.
abstract interface class UseCase<T, Params> {
  Future<Result<T, Failure>> call(Params params);
}

class NoParams {
  const NoParams();
}
