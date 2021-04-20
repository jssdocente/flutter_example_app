import 'package:apnapp/app/domain/bloc/_blocs.dart';
import 'package:apnapp/app/ui/widgets/_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_pages.dart';
import 'splash_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with AutomaticKeepAliveClientMixin<LandingPage>  {

  @override
  Widget build(BuildContext context) {

    //super.build(context);

    return BlocBuilder<AuthenticationBloc,AuthenticationState>(
      builder: (context,state) {
        if (state is AuthenticationUninitialized) {
          return SplashPage();
        }
        if (state is AuthenticationAuthenticated) {
          return HomePage();
        }
        if (state is AuthenticationUnauthenticated) {
          return WelcomePage();
          //return LoginPage(authRepository: locator<AuthRepository>());
        }

        return LoadingIndicator();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    print("LandingPage -> disposed");
  }
}
