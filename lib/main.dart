import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kikira/core/api/apiservicetoken.dart';
import 'package:kikira/core/notification/local_notifications.dart';
import 'package:kikira/core/notification/pollingservice.dart';
import 'package:kikira/core/streams/general_stream.dart';
import 'package:kikira/core/theming/colors.dart';
import 'package:kikira/features/ui/screens/loginpage.dart';
import 'package:kikira/generated/l10n.dart';
import 'package:kikira/kiki_app.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // Import Awesome Notifications
import 'package:kikira/core/classes/getallcritical.dart'; // Import the class to handle critical data
import 'package:firebase_core/firebase_core.dart';
import 'package:kikira/l10n/l10n.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications
  await LocalNotifications.init();

  // Initialize time zones
  tz.initializeTimeZones();



  runApp(MyApp());
}

class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService apiService = ApiService();
  late PollingService pollingService;

  @override
  void initState() {

    super.initState();
    // Initialize PollingService
    pollingService = PollingService(apiService);

    // Start polling for updates
    pollingService.startPolling(context);
   /* // Initialize the locale from the initialLocale passed from main()
    _locale = Locale(widget.initialLocale);*/
    GeneralStreams.languageStream.add(const Locale('en'));

  }


  @override
  void dispose() {
    // Stop polling when the app is disposed
    pollingService.stopPolling();
    GeneralStreams.languageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
        stream: GeneralStreams.languageStream.stream,
        builder: (context, snapshot) {
      return MaterialApp(
        locale:snapshot.data,
        supportedLocales:L10n.Locals,
        localizationsDelegates: [
          S.delegate , // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],

        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          splash: "assets/splash/splashscreenblack.gif",
          splashIconSize: 3000,
          centered: true,
          backgroundColor: colorManager.kikiBlack,
          duration: 5000,
          nextScreen: LoginPage( selectedLocal: snapshot.data?? const Locale('en') ,),
        ),
      );
  }
    );
}
bool isArabic(){
  return Intl.getCurrentLocale() =='ar' ;
}
}