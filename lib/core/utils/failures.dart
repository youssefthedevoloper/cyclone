import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error. Please try again.', super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error. Please try again.', super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error.', super.code});
}
