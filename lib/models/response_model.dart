

class ResponseModel<T>{
  T? data;
  bool isSuccess;
  String? errorMessage;

  ResponseModel.succes(T this.data, bool this.isSuccess);

  ResponseModel.error(bool this.isSuccess, String this.errorMessage);
}