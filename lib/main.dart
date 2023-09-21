import 'package:aad_oauth/model/config.dart';
import 'package:advisorapp/forms/Login/login_screen.dart';
import 'package:advisorapp/providers/addother_provider.dart';
import 'package:advisorapp/providers/admin_provider.dart';
import 'package:advisorapp/providers/employer_provider.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/image_provider.dart';
import 'package:advisorapp/providers/launch_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/providers/microsoftAuth_Provider.dart';
import 'package:advisorapp/providers/partner_provider.dart';
import 'package:advisorapp/providers/paymentmethod_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:advisorapp/route/route_generator.dart';
import 'package:advisorapp/style/colors.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PartnerProvider()),
        ChangeNotifierProvider(
            create: (context) => LoginProvider(googleSignIn)),
        ChangeNotifierProvider(create: (context) => MasterProvider()),
        ChangeNotifierProvider(create: (context) => LaunchProvider()),
        ChangeNotifierProvider(create: (context) => EmployerProvider()),
        ChangeNotifierProvider(create: (context) => AddotherProvider()),
        ChangeNotifierProvider(create: (context) => RoomsProvider()),
        ChangeNotifierProvider(create: (context) => SidebarProvider()),
        ChangeNotifierProvider(create: (context) => EliteImageProvider()),
        ChangeNotifierProvider(create: (context) => IdeaProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => MicrosoftAuthProvider()),
        ChangeNotifierProvider(create: (context) => PaymentMethodProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isLoading = true; // Track the loading state

  @override
  void initState() {
    super.initState();

    loadData();
    final authProvider =
        Provider.of<MicrosoftAuthProvider>(context, listen: false);
    authProvider.config = Config(
        tenant: 'common',
        clientId: 'a5489f64-06e7-4dfa-920c-196436ea8c46',
        scope: 'User.Read',
        navigatorKey: navigatorKey,
        redirectUri: 'http://localhost:5000/',
        loader: const SizedBox());
  }

  Future<void> loadData() async {
    // Perform the asynchronous loading tasks
    await Future.wait([
      //Clear Cache from all the Provider

      Provider.of<LoginProvider>(context, listen: false).getNaicsCodes(),
      Provider.of<AdminProvider>(context, listen: false).loadStatusList(),
      Provider.of<PartnerProvider>(context, listen: false).getPartner(),
      Provider.of<LaunchProvider>(context, listen: false).getItemsStatus(),
      Provider.of<LaunchProvider>(context, listen: false)
          .getAttachmentTypeList(),
      Provider.of<EmployerProvider>(context, listen: false)
          .getAttachmentTypeList(),
      Provider.of<MasterProvider>(context, listen: false).getRoles(),
      Provider.of<MasterProvider>(context, listen: false)
          .getCompanyCategories(),
      Provider.of<MasterProvider>(context, listen: false)
          .getBaseCompanyCategories(),
      Provider.of<MasterProvider>(context, listen: false).getCompanyTypes(),
      Provider.of<MasterProvider>(context, listen: false).getPayments(),
      Provider.of<MasterProvider>(context, listen: false).getCompanies(),
      Provider.of<RoomsProvider>(context, listen: false).getLaunchStausList(),
      Provider.of<RoomsProvider>(context, listen: false)
          .loadVisibleStatusList(),
      Provider.of<RoomsProvider>(context, listen: false)
          .getAttachmentTypeList(),
      Provider.of<IdeaProvider>(context, listen: false).getIdeas(),
      Provider.of<IdeaProvider>(context, listen: false).getVotes(),
      Provider.of<AdminProvider>(context, listen: false).getsubscriptions(),
    ]);

    // Data loading completed, update the loading state
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      title: 'Advisor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: 'Poppins',
        tooltipTheme: TooltipThemeData(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      //home: const Home(),
      home: const LoginScreen(),
    );
  }
}
