import 'failure.dart';

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Your session has expired.'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your internet connection.',
  });
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Something went wrong on the server.'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Invalid request.'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong.'});
}
