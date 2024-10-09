import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:market/domain/member_form.dart';
import '../ValidationResult.dart';
import '../domain/member.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  List<FieldErrorDetail> _errors = [];
  Gender? _gender;
  String? _nameErr;
  String? _usernameErr;
  String? _passwordErr;
  String? _passwordConfirmErr;
  String? _genderErr;
  String? _emailErr;
  String? _addressErr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
              RegisterInputBox(
                controller: _name,
                errorText: _nameErr,
                labelText: '이름',
                hintText: '이름을 입력해주세요.',
              ),
              RegisterInputBox(
                controller: _username,
                errorText: _usernameErr,
                labelText: '아이디',
                hintText: '영문, 숫자 포함 5~20자',
              ),
              RegisterInputBox(
                controller: _password,
                errorText: _passwordErr,
                obscureText: true,
                labelText: '비밀번호',
                hintText: '영문, 숫자, 특수기호 포함 8~16자',
              ),
              RegisterInputBox(
                controller: _passwordConfirm,
                errorText: _passwordConfirmErr,
                obscureText: true,
                labelText: '비밀번호 확인',
                hintText: '비밀번호 확인',
              ),
              RegisterInputBox(
                controller: _email,
                errorText: _emailErr,
                labelText: '이메일',
                hintText: '이메일을 입력해주세요.',
              ),
              RegisterInputBox(
                controller: _address,
                errorText: _addressErr,
                labelText: '주소',
                hintText: '주소를 입력해주세요.',
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: _genderErr == null
                            ? Colors.black54
                            : Color(0xffC65B56),
                        width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 25, 0),
                      child: Text('성별',
                          style: TextStyle(
                              color: _genderErr == null
                                  ? Colors.black54
                                  : Color(0xffC65B56),
                              fontSize: 17)),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('남성'),
                        leading: Radio<Gender>(
                          value: Gender.Male,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              _genderErr = null;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('여성'),
                        leading: Radio<Gender>(
                          value: Gender.Female,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              _genderErr = null;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (_genderErr != null)
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 10),
                      child: Text(
                        _genderErr!,
                        style:
                        TextStyle(fontSize: 12, color: Color(0xffC65B56)),
                      ),
                    )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        var uri = Uri.http("10.0.2.2:5012", '/register');
                        var response = await http.post(uri,
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(MemberForm(_username.text, _password.text, _passwordConfirm.text, _email.text, _name.text, _gender, _address.text)
                                .toJson()));
                        print(jsonEncode(MemberForm(_username.text, _password.text, _passwordConfirm.text, _email.text, _name.text, _gender, _address.text)
                            .toJson()));
                        if (response.statusCode == HttpStatus.ok) {
                          setState(() {
                            _errors.clear();
                            _nameErr = null;
                            _usernameErr = null;
                            _passwordErr = null;
                            _emailErr = null;
                            _passwordConfirmErr = null;
                            _addressErr = null;
                          });
                          Navigator.pushNamed(context, '/login');
                        } else if (response.statusCode == HttpStatus.badRequest) {
                          var validationResult = ValidationResult.fromJson(
                              jsonDecode(response.body));
                          print(validationResult);
                          setState(() {
                            _errors = validationResult.fieldErrors;
                            _nameErr =
                                FieldErrorDetail.errValidate(_errors, "name");
                            _usernameErr = FieldErrorDetail.errValidate(
                                _errors, "username");
                            _passwordErr = FieldErrorDetail.errValidate(
                                _errors, "password");
                            _passwordConfirmErr =
                                FieldErrorDetail.errValidate(
                                    _errors, "passwordConfirm");
                            _emailErr =
                                FieldErrorDetail.errValidate(_errors, "email");
                            _addressErr =
                                FieldErrorDetail.errValidate(_errors, "address");
                            _genderErr =
                                FieldErrorDetail.errValidate(_errors, "gender");
                          });
                        }
                      },
                      child: Text("회원가입")),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text("뒤로가기"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterInputBox extends StatelessWidget {
  const RegisterInputBox(
      {super.key,
        required this.controller,
        this.errorText,
        required this.labelText,
        required this.hintText,
        this.obscureText = false});

  final TextEditingController controller;
  final String? errorText;
  final String labelText;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            errorMaxLines: 3,
            labelText: labelText,
            errorText: errorText,
            hintText: hintText,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
