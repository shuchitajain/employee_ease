import '../../utils/app_strings.dart';

class ApiException implements Exception {
  final dynamic message;
  final dynamic prefix;

  ApiException([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, AppStrings.errorDuringCommunication);
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, AppStrings.invalidRequest);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, AppStrings.unauthorised);
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message])
      : super(message, AppStrings.invalidInput);
}

class NotFoundException extends ApiException {
  NotFoundException([message]) : super(message, AppStrings.notFound);
}

class RequestTimeoutException extends ApiException {
  RequestTimeoutException([message]) : super(message, AppStrings.requestTimeout);
}