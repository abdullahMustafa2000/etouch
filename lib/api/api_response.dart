class APIResponse<T> {
  T? data;
  bool hasError;
  String? errorMessage;
  int statusCode;

  APIResponse({required this.statusCode, this.data, this.hasError = false, this.errorMessage,});
}