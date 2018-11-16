import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.onSingedIn});

  final BaseAuth auth;
  final VoidCallback onSingedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  FormType _formType = FormType.login;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldstate,
      appBar: new AppBar(
        title: new Text("Flutter login demo"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        controller: emailController,
        decoration: new InputDecoration( labelText: "Email"),
        validator: (value) => value.isEmpty ? "Email can\'t be empty" : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        controller: passwordController,
        decoration: new InputDecoration( labelText: "Password",),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password can\'t be empty" : null,
        onSaved: (value) => _password = value,
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text("Login", style: new TextStyle(fontSize: 20.0),),
        ),
        new FlatButton(
            onPressed: moveToRegister,
            child: new Text("Create an Account", style: new TextStyle(fontSize: 20.0),)
        ),
      ];
    } else {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text("Register", style: new TextStyle(fontSize: 20.0),),
        ),
        new FlatButton(
            onPressed: moveToLogin,
            child: new Text("Already have an account? Login", style: new TextStyle(fontSize: 20.0),)
        ),
      ];
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          _scaffoldstate.currentState.showSnackBar(new SnackBar(content: new Text("Successfully logged in.")));
          print("Signed in: $userId");
          emailController.clear();
          passwordController.clear();
        } else {
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          _scaffoldstate.currentState.showSnackBar(new SnackBar(content: new Text("Successfully registered.")));
          print("Registered: $userId");
          emailController.clear();
          passwordController.clear();
        }
        widget.onSingedIn();
      } catch (error) {
        _scaffoldstate.currentState.showSnackBar(new SnackBar(content: new Text("$error")));
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }
}