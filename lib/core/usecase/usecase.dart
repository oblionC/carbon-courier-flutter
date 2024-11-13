import 'package:fpdart/fpdart.dart';
import 'package:go_green/core/errors/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
