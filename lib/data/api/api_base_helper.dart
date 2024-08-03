import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../../presentation/widgets/app_widgets.dart';
import '../../utils/app_strings.dart';
import 'api_exceptions.dart';

class ApiBaseHelper extends GetConnect implements GetxService {
  late String token;
  late Map<String, String> _mainHeaders;

  ApiBaseHelper({String? baseUrlString, Map<String, String>? headers}) {
    httpClient.baseUrl = AppStrings.backendUrl;
    httpClient.defaultContentType = 'application/json; charset=UTF-8';
    httpClient.timeout = const Duration(seconds: 30);
    _mainHeaders = headers ??
        <String, String>{
          'projectId': '66ab320f00af110a2a57a54d',
          'environmentId': '66ab320f00af110a2a57a54e',
        };
  }

  //CREATE
  Future<dynamic> postData(String url, dynamic body) async {
    dynamic responseJson;
    try {
      final response = await post(
        url,
        body,
        headers: _mainHeaders,
      ).catchError(handleError);
      debugPrint('Response from post api: ${response.body}');
      responseJson = _returnResponse(response: response);
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(AppStrings.noInternetConnection);
    }
    return responseJson;
  }

  //READ
  Future<dynamic> getData(String url) async {
    dynamic responseJson;
    try {
      final dynamic response = await get(
        url,
        headers: _mainHeaders,
        query: <String, dynamic>{'limit': '100', 'offset': '0'},
      ).catchError(handleError);
      responseJson = _returnResponse(response: response);
    } on SocketException {
      debugPrint('No internet');
      throw FetchDataException(AppStrings.noInternetConnection);
    } on TimeoutException {
      throw RequestTimeoutException(AppStrings.requestTimeout);
    } on Error catch (e) {
      debugPrint('Error: $e');
    }
    return responseJson;
  }

  //UPDATE
  Future<dynamic> patchData(String url, dynamic body) async {
    dynamic responseJson;
    try {
      final response = await patch(
        url,
        body,
        headers: _mainHeaders,
      ).catchError(handleError);
      responseJson = _returnResponse(response: response);
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(AppStrings.noInternetConnection);
    }
    return responseJson;
  }

  //DELETE
  Future<dynamic> deleteData(String url) async {
    dynamic responseJson;
    try {
      final response =
          await request(
              url,
              'DELETE',
              body: {},
              headers: _mainHeaders,
          ).catchError(handleError);
      responseJson = _returnResponse(response: response);
    } on SocketException {
      debugPrint('No net');
      throw FetchDataException(AppStrings.noInternetConnection);
    }
    return responseJson;
  }
}

handleError(error) {
  debugPrint('ERROR $error');
  if (error is FetchDataException) {
    var message = error.message;
    debugPrint('MSG $message');
    AppWidgets.showSnackBar(
        title: 'Error during communication! Please try again later.');
  } else if (error is BadRequestException) {
    var message = error.message;
    AppWidgets.showErrorDialog(message: message);
  } else if (error is UnauthorisedException) {
    var message = error.message;
    AppWidgets.showErrorDialog(message: message);
  } else if (error is InvalidInputException) {
    var message = error.message;
    AppWidgets.showErrorDialog(message: message);
  } else if (error is NotFoundException) {
    var message = error.message;
    AppWidgets.showErrorDialog(message: message);
  } else if (error is RequestTimeoutException) {
    var message = error.message;
    debugPrint(message);
    AppWidgets.showErrorDialog(message: 'Oops! Request timed out.');
  }
}

dynamic _returnResponse({required Response response}) {
  switch (response.statusCode) {
    case 200:
      var responseJson = response.body;
      //debugPrint('responseJson: $responseJson');
      return responseJson;
    case 201:
      var responseJson = response.body;
      //debugPrint('responseJson: $responseJson');
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 404:
      throw NotFoundException(response.body.toString());
    case 408:
      throw RequestTimeoutException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
