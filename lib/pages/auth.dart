import 'dart:core';
import 'package:baby/models/auth.dart';
import 'package:baby/widgets/ui_elements/login_interface.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          CircleAvatar(
            child: Image.asset('assets/origami.png'),
            maxRadius: 50,
            backgroundColor: Colors.transparent,
          ),
          _buildLoginForm(),
          new Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              child: new Text(
                'thanks to choose us',
                style: new TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: 16.0,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmailTextField() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 90.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Email address",
                  hintStyle: TextStyle(color: Colors.blue.shade200),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.email,
                    color: Colors.blue,
                  )),
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value.isEmpty ||
                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
              },
              onSaved: (String value) {
                _formData['email'] = value;
              },
            ),
          ),
        ]);
  }
  Widget _buildPasswordTextField() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "password",
                  hintStyle: TextStyle(color: Colors.blue.shade200),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  )),
              obscureText: true,
              controller: _passwordTextController,
              validator: (String value) {
                if (value.isEmpty || value.length < 6) {
                  return 'Password invalid';
                }
              },
              onSaved: (String value) {
                _formData['password'] = value;
              },
            ),
          ),
        ]);
  }
  Widget _buildPasswordConfirmTextField() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
                decoration: InputDecoration(
                    hintText: "Confirm password",
                    hintStyle: TextStyle(color: Colors.blue.shade200),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    )),
                obscureText: true,
                validator: (String value) {
                  if (_passwordTextController.text != value) {
                    return 'Passwords do not match.';
                  }
                }),
          ),
          Container(
            child: Divider(
              color: Colors.blue.shade400,
            ),
            padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
          ),
        ]);
  }
  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }




  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()|| !_formData['acceptTerms']){
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/Nurseries');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Container _buildLoginForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Stack(children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 460,
              padding: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildEmailTextField(),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  _buildPasswordTextField(),
                  Container(
                    child: Divider(
                      color: Colors.blue.shade400,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  _authMode == AuthMode.Signup
                      ? _buildPasswordConfirmTextField()
                      : Container(),
                  _buildAcceptSwitch(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                            'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.Login
                                ? AuthMode.Signup
                                : AuthMode.Login;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 480,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return model.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          child: Text(
                              _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
                              style: TextStyle(color: Colors.white70)),
                          color: Colors.blue,
                          onPressed: () => _submitForm(model.authenticate),
                        );
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}
