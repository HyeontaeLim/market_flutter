import 'member.dart';

class MemberForm {
  final String _username;
  final String _password;
  final String _passwordConfirm;
  final String _email;
  final String _name;
  final Gender? _gender;
  final String _address;

  MemberForm(this._username, this._password, this._passwordConfirm,
      this._email, this._name, this._gender, this._address);

  String get address => _address;

  Gender? get gender => _gender;

  String get name => _name;

  String get email => _email;

  String get passwordForm => _passwordConfirm;

  String get password => _password;

  String get username => _username;

  factory MemberForm.fromJson(Map<String, dynamic> json) =>
      MemberForm(
          json["username"],
          json["password"],
          json["passwordConfirm"],
          json["email"],
          json["name"],
          GenderExtension.fromValue(json["gender"]),
          json["address"]
      );
  Map<String, dynamic> toJson() =>
      {
        "username": _username,
        "password": _password,
        "passwordConfirm": _passwordConfirm,
        "email": _email,
        "name": _name,
        "gender": _gender.value,
        "address": _address};
}
