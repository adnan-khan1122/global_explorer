abstract class AppFailure {
  const AppFailure(this.message);
  final String message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network error.']);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Local cache error.']);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'An unknown error occurred.']);
}
