import 'package:church/factories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AuthScreen extends StatelessWidget {
  final Factories _factories;
  final format = DateFormat("MM-dd-yyyy");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final List<String> fieldValues = new List(9);

  AuthScreen({Key key, Factories factories})
      : _factories = factories ?? Factories(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Cornerstone",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: <Widget>[
              Text(
                "Sign In",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Sign Up",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            signIn(),
            signUp(),
          ],
        ),
      ),
    );
  }

  Widget signUp() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "First Name "),
              controller: _firstName,
              onChanged: (text) {
                fieldValues[0] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Last Name "),
              controller: _lastName,
              onChanged: (text) {
                fieldValues[1] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            Container(
              height: 5,
            ),
            DateTimeField(
              decoration: InputDecoration(labelText: "DOB"),
              format: format,
              controller: _dob,
              onChanged: (text) {
                fieldValues[2] = text.toString();
                _factories.authBloc.validate(fieldValues);
              },
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Address Line 1 "),
              controller: _address,
              onChanged: (text) {
                fieldValues[3] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
                decoration:
                    InputDecoration(labelText: "Adress Line 2 (Optional)"),
                controller: _address1),
            Container(
              height: 5,
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "City "),
              controller: _city,
              onChanged: (text) {
                fieldValues[4] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "State"),
              controller: _state,
              onChanged: (text) {
                fieldValues[5] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Zip "),
              controller: _zip,
              onChanged: (text) {
                fieldValues[6] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email "),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (text) {
                fieldValues[7] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              controller: _passwordController,
              obscureText: true,
              onChanged: (text) {
                fieldValues[8] = text;
                _factories.authBloc.validate(fieldValues);
              },
            ),
            Container(
              height: 5,
            ),
            StreamBuilder<bool>(
                stream: _factories.authBloc.onBlockingChange,
                builder: (context, block) {
                  if (block.hasData && block.data == true) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder<bool>(
                      stream: _factories.authBloc.enableSubmit,
                      builder: (context, snapshot) {
                        Function fn;
                        if (snapshot.hasData && snapshot.data == true) {
                          fn = () => _factories.authBloc.onSignUp(
                              _emailController.text,
                              _passwordController.text,
                              firstName:_firstName.text,
                              lastName:_lastName.text,
                              address:_address.text,
                              address1:_address1.text,
                              city:_city.text,
                              state:_state.text,
                              zip:_zip.text,
                              dob:_dob.text);
                        }
                        return RaisedButton(
                            child: Text("Sign In"), onPressed: fn);
                      });
                }),
            Container(
              height: 20,
            ),
            StreamBuilder<bool>(
              stream: _factories.authBloc.emailReset,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Text("Password Reset Email Sent");
                }
                return Container();
              },
            ),
            StreamBuilder<dynamic>(
              stream: _factories.authBloc.error,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Container();
                }
                if (snap.data == "wrong password") {
                  return StreamBuilder<bool>(
                      stream: _factories.authBloc.emailReset,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return Container();
                        }
                        return Column(
                          children: <Widget>[
                            Text(snap.data.toString()),
                            RaisedButton(
                              onPressed: () => _factories.authBloc
                                  .resetPassword(_emailController.text),
                              child: Text("Reset Password"),
                            )
                          ],
                        );
                      });
                }
                return Center(
                  child: Text(snap.data.toString() ?? ""),
                );
              },
            ),
          ],
        ));
  }

  Widget signIn() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 20,
            ),
            TextField(
                decoration: InputDecoration(labelText: "Email "),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress),
            Container(
              height: 20,
            ),
            TextField(
                decoration: InputDecoration(labelText: "Password"),
                controller: _passwordController,
                obscureText: true),
            Container(
              height: 20,
            ),
            StreamBuilder<bool>(
                stream: _factories.authBloc.onBlockingChange,
                builder: (context, block) {
                  if (block.hasData && block.data == true) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return RaisedButton(
                      child: Text("Sign In"),
                      onPressed: () => _factories.authBloc.onSignIn(
                          _emailController.text, _passwordController.text));
                }),
            Container(
              height: 20,
            ),
            StreamBuilder<bool>(
              stream: _factories.authBloc.emailReset,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Text("Password Reset Email Sent");
                }
                return Container();
              },
            ),
            StreamBuilder<dynamic>(
              stream: _factories.authBloc.error,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Container();
                }
                if (snap.data == "wrong password") {
                  return StreamBuilder<bool>(
                      stream: _factories.authBloc.emailReset,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return Container();
                        }
                        return Column(
                          children: <Widget>[
                            Text(snap.data.toString()),
                            RaisedButton(
                              onPressed: () => _factories.authBloc
                                  .resetPassword(_emailController.text),
                              child: Text("Reset Password"),
                            )
                          ],
                        );
                      });
                }
                return Center(
                  child: Text(snap.data.toString() ?? ""),
                );
              },
            ),
          ],
        ));
  }
}
