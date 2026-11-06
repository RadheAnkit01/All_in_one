import 'package:all_in_one/core/errors/app_failures.dart';

Duration? networkRetryPolicy(int retryCount, Object error) {
  // Retry only network errors.
  if (error is! NetworkFailure) {
    return null;
  }

  // 1 initial request + 4 retries = 5 requests.
  if (retryCount >= 4) {
    return null;
  }

  return Duration(milliseconds: 200 * (1 << retryCount));
}
