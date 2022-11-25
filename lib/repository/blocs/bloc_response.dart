class BlocResponse<T> {
  BlocResponseStatus status = BlocResponseStatus.unknown;
  String? error;
  T? data;

  BlocResponse.loading() {
    status = BlocResponseStatus.loading;
  }

  BlocResponse.success(this.data) {
    status = BlocResponseStatus.success;
  }

  BlocResponse.error(this.error) {
    status = BlocResponseStatus.error;
  }
}

enum BlocResponseStatus {
  unknown,
  loading,
  error,
  success,
}
