import 'package:church/factories.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AuthScreen extends StatelessWidget {
  final Factories _factories;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({Key key, Factories factories})
      : _factories = factories ?? Factories(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Object>(builder: (context, snapshot) {
      return FutureBuilder<bool>(builder: (context, snapshot) {
        return Container(
            color: Colors.white,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Text(
                  'Create An Account',
                  style: TextStyle(fontSize: 20),
                ),
                RaisedButton(
                  onPressed: () {
                    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {});
                  },
                  child: Text('Add Card'),
                ),
                Container(
                  height: 20,
                ),
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress),
                Container(
                  height: 20,
                ),
                TextField(controller: _passwordController, obscureText: true),
                Container(
                  height: 20,
                ),
                StreamBuilder<bool>(
                  stream: _factories.authBloc.enableSubmit,
                  builder: (context, snapshot) {
                    return StreamBuilder<bool>(
                        stream: _factories.authBloc.onBlockingChange,
                        builder: (context, block) {
                          if (block.hasData && block.data == true) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return RaisedButton(
                              child: Text("Sign Up | Sign In"),
                              onPressed: () => _factories.authBloc.onSubmit(
                                  _emailController.text,
                                  _passwordController.text));
                        });
                  },
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
      });
    }));
  }
}
