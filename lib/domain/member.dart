class Member {
  final int _memberId;
  final String _username;
  final String _password;
  final String _email;
  final String _name;
  final Gender _gender;
  final String _address;

  Member(this._memberId, this._username, this._password, this._email,
      this._name, this._gender, this._address);

  String get address => _address;

  Gender get gender => _gender;

  String get name => _name;

  String get email => _email;

  String get password => _password;

  String get username => _username;

  int get memberId => _memberId;

  factory Member.fromJson(Map<String, dynamic> json) =>
      Member(
        json["memberId"],
        json["username"],
        json["password"],
        json["email"],
        json["name"],
          GenderExtension.fromValue(json["gender"]),
        json["address"]
      );

  Map<String, dynamic> toJson() =>
      {"memberId": _memberId,
        "username": _username,
        "password": _password,
        "email": _email,
        "name": _name,
        "gender": _gender.value,
        "address": _address};
}

enum Gender {
  Male,
  Female
}
extension GenderExtension on Gender? {
  String? get value {
    if (this == Gender.Male) {
      return "Male";
    } else if (this == Gender.Female) {
      return "Female";
    }
    return null;
  }

  static Gender fromValue(String value) {
    switch (value) {
      case "Male":
        return Gender.Male;
      case "Female":
        return Gender.Female;
      default:
        throw ArgumentError("Unknown enum value: $value");
    }
  }
}