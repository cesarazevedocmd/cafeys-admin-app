class ApiResponse<T> {
  bool success = false;
  String? error;
  T? data;

  ApiResponse.success(this.data) {
    success = true;
  }

  ApiResponse.error(this.error) {
    success = false;
  }
}
