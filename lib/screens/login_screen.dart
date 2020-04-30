import 'package:flutter/material.dart';
import 'package:login/blocs/login_bloc.dart';
import 'package:login/screens/user_screen.dart';
import 'package:login/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outLoginState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserScreen(_loginBloc.outUser)));
          break;
          case LoginState.FAIL:
          case LoginState.IDLE:
          case LoginState.LOADING:
          case LoginState.LOADING_CODE:
          case LoginState.LOADING_TOKEN:
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outLoginState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.help,
                            color: Colors.black,
                            size: 160,
                          ),
                          InputField(
                            stream: _loginBloc.outMobileNumber,
                            onChanged: _loginBloc.changeMobileNumber,
                            hint: 'Celular',
                            icon: Icons.phone,
                            obscure: false,
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                          InputField(
                            stream: _loginBloc.outCountryCode,
                            onChanged: _loginBloc.changeCountryCode,
                            hint: 'Código Páis',
                            icon: Icons.info_outline,
                            obscure: false,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.black,
                                    child: Text('Entrar'),
                                    onPressed: snapshot.hasData
                                        ? _loginBloc.submit
                                        : null,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey.withAlpha(140),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              );
            case LoginState.LOADING_TOKEN:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Verificando token...',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            case LoginState.LOADING_CODE:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Verificando passcode...',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            default:
              return Center(
                child: Text('Erro'),
              );
          }
        },
      ),
    );
  }
}
