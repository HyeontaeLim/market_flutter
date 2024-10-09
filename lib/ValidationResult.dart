class ValidationResult {
  final List<FieldErrorDetail> fieldErrors;
  final List<ObjectErrorDetail> globalErrors;

  ValidationResult({required this.fieldErrors, required this.globalErrors});

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    var fieldErrorsJson = json['fieldErrors'] as List;
    var globalErrorsJson = json['globalErrors'] as List;
    List<FieldErrorDetail> fieldErrorsList = fieldErrorsJson
        .map((error) => FieldErrorDetail.fromJson(error))
        .toList();
    List<ObjectErrorDetail> globalErrorsList = globalErrorsJson
        .map((error) => ObjectErrorDetail.fromJson(error))
        .toList();

    return ValidationResult(
        fieldErrors: fieldErrorsList, globalErrors: globalErrorsList);
  }
}

class FieldErrorDetail {
  final String field;
  final Object? rejectedValue; // Object 타입이므로 nullable로 설정
  final List<String> message;

  FieldErrorDetail({
    required this.field,
    required this.rejectedValue,
    required this.message,
  });

  factory FieldErrorDetail.fromJson(Map<String, dynamic> json) {
    var messageJson = json['message'] as List;
    List<String> messageList = List<String>.from(messageJson);
    return FieldErrorDetail(
      field: json['field'],
      rejectedValue: json['rejectedValue'],
      message: messageList,
    );
  }

  static String? errValidate(List<FieldErrorDetail> errors, String errField) {
    if (errors.any((error) => error.field.toLowerCase() == errField.toLowerCase())) {
      if(errors.where((error) => error.field.toLowerCase() == errField.toLowerCase()).any((error) => error.message.any((m) => m.contains("입력해주세요")))){
        return errors.firstWhere((error) => error.field.toLowerCase() == errField.toLowerCase()).message.firstWhere((m) => m.contains("입력해주세요"));
      }else{
        return errors.firstWhere((error) => error.field.toLowerCase() == errField.toLowerCase()).message[0];
      }
    } else {
      return null;
    }
  }
}

class ObjectErrorDetail {
  final String objectName;
  final List<String> message;

  ObjectErrorDetail({
    required this.objectName,
    required this.message,
  });

  factory ObjectErrorDetail.fromJson(Map<String, dynamic> json) {
    var messageJson = json['message'] as List;
    List<String> messageList = List<String>.from(messageJson);

    return ObjectErrorDetail(
      objectName: json['objectName'],
      message: messageList,
    );
  }
}
