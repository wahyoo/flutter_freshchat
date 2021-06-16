import 'package:flutter/material.dart';
import 'package:flutter_freshchat/flutter_freshchat.dart';
import 'package:localstorage/localstorage.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateUserInfoState();
  }
}

class UpdateUserInfoState extends State<UpdateUserInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('example_storage');

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _countryCode = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Update User Info'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: 500.0,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'xyz',
                  labelText: 'Enter Firstname',
                ),
                onSaved: (String? value) {
                  _firstName = value ?? '';
                },
                validator: (String? value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'xyz',
                  labelText: 'Enter Lastname',
                ),
                onSaved: (String? value) {
                  _lastName = value ?? '';
                },
                validator: (String? value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'xyz@test.com',
                  labelText: 'Enter Email address',
                ),
                onSaved: (String? value) {
                  print(value);
                  _email = value ?? '';
                },
                validator: (String? value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: '+91',
                        labelText: 'Country Code',
                      ),
                      onSaved: (String? value) {
                        _countryCode = value ?? '';
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value != null && value.length < 2) {
                          return 'Please enter 3 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: '0123456789',
                        labelText: 'Phone Number',
                      ),
                      onSaved: (String? value) {
                        _phone = value ?? '';
                      },
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();

                    await storage.setItem('uid', _email);

                    final FreshchatUser user = FreshchatUser.initial();
                    user.email = _email;
                    user.firstName = _firstName;
                    user.lastName = _lastName;
                    user.phoneCountryCode = _countryCode;
                    user.phone = _phone;

                    await FlutterFreshchat.updateUserInfo(user: user);

                    scaffoldKey.currentState?.showSnackBar(
                        const SnackBar(content: Text('Clicked')));
                  }
                },
                child: const Text('submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
