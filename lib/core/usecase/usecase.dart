import '../types/result.dart';

/// Base contract for every synchronous + async use case.
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Use-case parameter when no input is needed.
class NoParams {
  const NoParams();
}
