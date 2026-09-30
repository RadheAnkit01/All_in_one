sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Unable to connect to the server.']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out.']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Authentication failed.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'The requested resource was not found.',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'The request contains invalid data.',
  ]);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'The server encountered an error.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
