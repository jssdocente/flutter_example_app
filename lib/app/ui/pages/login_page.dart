import 'package:apnapp/app/data/repository/_repositorys.dart';
import 'package:apnapp/app/domain/bloc/_blocs.dart';
import 'package:apnapp/app/locator.dart';
import 'package:apnapp/app/ui/widgets/_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key key}):
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  AuthRepository _authRepository;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _userFocus = FocusNode(), _passFocus = FocusNode();

  void _submit() {
    if (_validate()) {
      print("submit pressed");
      _loginBloc.add(LoginButtonPressedEvt(username: _userController.text, password: _passController.text));
    } else {
      print("submit pressed: Error validacion");
    }
  }

  void _updateStated() {
    //_loginBloc.add();
    setState(() {});
  }

  bool _validate() {
    return !(_userController.text.isEmpty || _passController.text.isEmpty);
  }

  @override
  void initState() {
    _authRepository = locator<AuthRepository>();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _authRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buidBackground(context),
    );
  }

  Widget _buidBackground(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        color: theme.splashColor,
        // image: DecorationImage(
        //   image: AssetImage('assets/images/foto_aceituna_manos.png'),
        //   fit: BoxFit.cover,
        //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
        // ),
//      backgroundBlendMode: BlendMode.difference,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Positioned(
////            bottom: size.height * 0.25 * -1,
//            child: Opacity(
//              opacity: 0.2,
//              child: Image(
////                color: Colors.grey,
////                colorBlendMode: BlendMode.saturation,
//                image:  AssetImage('assets/images/foto_aceituna_manos.png'),
//                fit: BoxFit.none,
//              ),
//            ),
//          ),

          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var th = Theme.of(context);

    bool submitEnabled = _userController.text.isNotEmpty && _passController.text.isNotEmpty;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (context, state) {
          if (state is LoginFailureSt) {
            FlushbarHelper.createError(message: state.error).show(context);
            _passController.clear();
            _updateStated();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Image.asset("assets/images/logo_coop.png",height: 60,),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          "Apolo Emergencias",
                          style: th.textTheme.headline3.copyWith(fontWeight: FontWeight.bold),
                          minFontSize: 24,
                          maxFontSize: 36,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: AutoSizeText(
                            "Navega",
                            style: th.textTheme.headline5,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // SvgPicture.asset(
              //   "assets/icons/logo-rojo.svg",
              //   width: size.width * 0.70,
              // ),
              SizedBox(height: 15),
//              Text(
//                "INICIO DE SESIÓN",
//                style: MyTheme.text.headline5.merge(TextStyle(fontWeight: FontWeight.w800)),
//              ),
              SizedBox(height: size.height * 0.05),
              RoundedInputField(
                hintText: "Usuario",
                controller: _userController,
                focusNode: _userFocus,
                passFocus: () => FocusScope.of(context).requestFocus(_passFocus),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  _updateStated();
                },
              ),
              RoundedPasswordField(
                controller: _passController,
                focusNode: _passFocus,
                keyboardType: TextInputType.text,
                passFocus: () => _submit(),
                onChanged: (value) {
                  _updateStated();
                },
              ),
              SizedBox(height: size.height * 0.03),
              BlocBuilder<LoginBloc, LoginState>(
                bloc: _loginBloc,
                builder: (context, state) {
                  if (state is LoginLoadingSt) {
                    return Container(
                      height: size.height * 0.11,
                      child: LoadingIndicator(),
                    );
                  }
                  return RoundedButton(
                    text: "INCIAR SESIÓN",
                    press: submitEnabled
                        ? () {
                            FocusScope.of(context).unfocus();
                            _submit();
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
