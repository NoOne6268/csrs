import 'package:csrs/pages/otpVerification.dart';
import 'package:csrs/pages/sos.dart';
import 'package:csrs/pages/welcome.dart';
import 'package:home_widget/home_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:csrs/pages/signup.dart';
import 'package:csrs/pages/login.dart';
import 'package:csrs/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:csrs/pages/countdown_timer.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),
        GoRoute(
          path: 'cnt',
          builder: (BuildContext context, GoRouterState state) {
            return const CountdownScreen();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'sos',
          builder: (BuildContext context, GoRouterState state) {
            return const SosScreen();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(path: 'verifyotp',
            name: 'verifyotp',
            builder: (BuildContext context, GoRouterState state){
              return  OtpVerificationScreen(
                loginOrRegister : state.uri.queryParameters['loginOrRegister'],
                nextRoute : state.uri.queryParameters['nextRoute'],

              );
            }),
      ],
    ),
  ],
);

@pragma("vm:entry-point")
Future<void> interactiveCallback(Uri? data) async {
  if (data == Uri.parse('sosWidget://message?message=clicked')) {
    await HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const CountdownScreen()));
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBHi2AzFaj6hYRytGV8Mf9faBzY4oQ2Njo',
      appId: '1:797247438844:android:3e60af2a46960574c03c79',
      messagingSenderId: '797247438844',
      projectId: 'login-example-15cb0',
      authDomain: 'login-example-15cb0.firebaseapp.com',
    ),
  );
  initPlatform();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp()
    // MaterialApp(
    //   initialRoute: '/login',
    //   navigatorKey: navigatorKey,
    //   routes: {
    //     '/signup': (context) => const SignupScreen(),
    //     '/login': (context) => const LoginScreen(),
    //     '/home': (context) => const HomeScreen(),
    //     '/sos': (context) => const sosScreen(),
    //   },
    // ),
    ,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  //Home widget Plugin start
  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget()
        .then(_launchedFromWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri == Uri.parse('sosWidget://message?message=clicked')) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CountdownScreen()));
    }
  }
  //end

  @override
  void initState() {
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerInteractivityCallback(interactiveCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Rokkitt',
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}


Future<void> initPlatform() async {
  // OneSignal.initialize('845c208f-f5ea-410a-abc5-92bfe17326fe');
  // OneSignal.Notifications.requestPermission(true);
  // OneSignal.Notifications.addClickListener((event) {
  //    print('clicked');
  //    print('event is ${event.notification.additionalData}');
  //    print('event is ${event.notification.body}');
  // });
  //   print('onesignal userId is : ${OneSignal.Debug.setLogLevel()} ' );
  // }
  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  OneSignal.shared.setAppId('845c208f-f5ea-410a-abc5-92bfe17326fe');
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print('Accepted permission: $accepted');
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
    print('notification will show in foreground');
  });

  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    print('notification received and clicked  ${openedResult.notification}');
    print('event is ${openedResult.notification.additionalData}');
    print('event is ${openedResult.notification.body}');
  });
  OneSignal.shared.getDeviceState().then((value) => {
        print(
            'user id is : ${value!.userId} , and device state is ${value.jsonRepresentation()}')
      });
  // print('something is happening');
}
