import 'package:csrs/pages/contacts.dart';
import 'package:csrs/pages/otpVerification.dart';
import 'package:csrs/pages/add_image.dart';
import 'package:csrs/pages/edit_profile.dart';
import 'package:csrs/pages/signup2.dart';
import 'package:csrs/pages/sos.dart';
import 'package:csrs/firebase_options.dart';
import 'package:csrs/pages/welcome.dart';
import 'package:csrs/services/local_notification_service.dart';
import 'package:csrs/services/location.dart';
import 'package:csrs/services/receive_notification.dart';
import 'package:csrs/utils/user.dart';
import 'package:home_widget/home_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:csrs/pages/signup.dart';
import 'package:csrs/pages/login.dart';
import 'package:csrs/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:csrs/pages/countdown_timer.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          path: 'signup/email',
          name: 'signup/email',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),
        GoRoute(
          path: 'signup/phone',
          name: 'signup/phone',
          builder: (BuildContext context, GoRouterState state) {
            return SignupScreen2(
              email: state.uri.queryParameters['email'],
              rollNo: state.uri.queryParameters['rollNo'],
            );
          },
        ),
        GoRoute(
          path: 'cnt',
          name: '/cnt',
          builder: (BuildContext context, GoRouterState state) {
            return  CountdownScreen(
              email: state.uri.queryParameters['email'],
              name : state.uri.queryParameters['name'],
            );
          },
        ),
        GoRoute(
          path: 'home',
          name: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'sos',
          name: '/sos',
          builder: (BuildContext context, GoRouterState state) {
            return  SosScreen(
              email: state.uri.queryParameters['email'],
              name : state.uri.queryParameters['name'],
            );
          },
        ),
        GoRoute(
          path: 'login',
          name: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen();
          },
        ),
        GoRoute(
            path: 'verifyotp',
            name: 'verifyotp',
            builder: (BuildContext context, GoRouterState state) {
              return OtpVerificationScreen(
                loginOrRegister: state.uri.queryParameters['loginOrRegister'],
                nextRoute: state.uri.queryParameters['nextRoute'],
                isEmail: state.uri.queryParameters['isEmail'],
                email: state.uri.queryParameters['email'],
                rollNo: state.uri.queryParameters['rollNo'],
                phone: state.uri.queryParameters['phone'],
                isSignup: state.uri.queryParameters['isSignup'],
              );
            }),
        GoRoute(
          path: 'profile/create',
          name: 'profile/create',
          builder: (BuildContext context, GoRouterState state) {
            return  ProfileImage(
              email: state.uri.queryParameters['email'],
              rollNo: state.uri.queryParameters['rollNo'],
            );
          },
        ),

        GoRoute(
          path: 'profile/edit',
          name: 'profile/edit',
          builder: (BuildContext context, GoRouterState state) {
            return  EditProfile(
              email : state.uri.queryParameters['email'],
              name : state.uri.queryParameters['name'],
              rollNo : state.uri.queryParameters['rollNo'],
              imageUrl : state.uri.queryParameters['imageUrl'],
            );
          },
        ),
        GoRoute(
          path: 'contacts',
          name: 'contacts',
          builder: (BuildContext context, GoRouterState state) {
            return  ContactScreen(
              email: state.uri.queryParameters['email'],
            );
          },
        ),
      ],
    ),
  ],
);

@pragma("vm:entry-point")
Future<void> interactiveCallback(Uri? data) async {
  if (data == Uri.parse('sosWidget://message?message=clicked')) {
    await HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => const CountdownScreen(
      email:' User.email',
      name: 'User.name',
    )));
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('message is ${message.data}');
  _handleMessage();
  // NotificationServices().setUpInteractMessage(c);
  // _handleMessage(navigatorKey.currentContext!);
}

// main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // _handleMessage(context);
  // clear all saved shared prefs
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  LocalNotificationService.setup();

  Location().askPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationServices().isTokenRefreshed();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Home widget Plugin start
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri == Uri.parse('sosWidget://message?message=clicked')) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const CountdownScreen(
        email:' User.email',
        name: 'User.name',
      )));
    }
  }

  //end

  @override
  void initState() {
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerInteractivityCallback(interactiveCallback);
    _handleMessage();
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

void _handleMessage() {
  NotificationServices _notificationServices = NotificationServices();
  _notificationServices.requestNotificationPermission();
  _notificationServices.firebaseInit();
  _notificationServices.getToken();
  _notificationServices.setUpInteractMessage();
}
