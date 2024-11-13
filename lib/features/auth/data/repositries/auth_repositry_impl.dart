import 'package:fpdart/src/either.dart';
import 'package:go_green/core/errors/exceptions.dart';
import 'package:go_green/core/errors/failures.dart';
import 'package:go_green/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:go_green/features/auth/domain/repository/auth_repository.dart';

class AuthRepositiryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositiryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
          name: name, email: email, password: password);
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
