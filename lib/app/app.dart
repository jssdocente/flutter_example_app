import 'dart:async';

import 'package:apnapp/app/common/utils/life_cycle_manager.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart' as transitions;

import 'app_state.dart';
import 'common/logger.dart';
import 'data/repository/_repositorys.dart';
import 'domain/bloc/_blocs.dart';
import 'locator.dart';
import 'routes/app_pages.dart';
import 'ui/pages/_pages.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _AENAppState createState() => _AENAppState();
}

class _AENAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return BlocProviders(
      child: LifeCycleManager(
        child: ScreenUtilInit(
            designSize: Size(421, 693),
            builder: () => GetMaterialApp(
              title: widget.title,
              debugShowCheckedModeBanner: false,
              //theme: MyTheme.buildTheme(null), //No se pasa context, porque no lleva info sobre size/dpi
              theme: FlexColorScheme.light(
                  appBarStyle: FlexAppBarStyle.surface,
                  scheme: FlexScheme.mango,
                  fontFamily: "Roboto"
              ).toTheme,
              darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mango,fontFamily: "Roboto").toTheme,
              builder: BotToastInit(),
              navigatorObservers: [
                //TODO: Firebase Enabled
                //FirebaseAnalyticsObserver(analytics: analytics),
                BotToastNavigatorObserver(),
              ],
              //Getx-config
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              enableLog: true,
              defaultTransition: transitions.Transition.fade,
              opaqueRoute: Get.isOpaqueRouteDefault,
              popGesture: Get.isPopGestureEnable,
              transitionDuration: Get.defaultTransitionDuration,
              defaultGlobalState: true,
              logWriterCallback: localLogWriter,
              themeMode: ThemeMode.system,
              //home: RequetErrorPage(),
              home: LandingPage(),
              //home: LoginPageOnlyPass(authRepository: locator<AuthRepository>()),
            ),
        ),
      ),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {
    if (isError) {
      logger.e(text);
      return;
    }
    logger.i(text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BlocProviders extends StatelessWidget {
  const BlocProviders({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) {
            var authbloc =AuthenticationBloc(authRepository: locator<AuthRepository>(),appState:locator<AppState>() );
            Timer(Duration(seconds: 1), () => authbloc.add(AppStarted()));
            return authbloc;
          },
        ),
      ],
      child: child,
    );
  }

}

