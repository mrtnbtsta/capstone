import 'package:capstone_project/view/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic currentUserName;
dynamic currentAdminUsername;
dynamic currentGuardUsername;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  currentUserName = pref.getString("name");
  currentAdminUsername = pref.getString("username");
  currentGuardUsername = pref.getString("guardUser");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: "/loading",
      initialRoute: currentUserName != null
          ? RouteName.home
          : currentAdminUsername != null
              ? RouteName.dashboardEmergency
              : currentGuardUsername != null
                  ? RouteName.guardHome
                  : RouteName.loading,
      // initialRoute: currentUserName != null &&
      //         currentAdminUsername == null &&
      //         currentGuardUsername
      //     ? RouteName.home
      //     : currentAdminUsername != null &&
      //             currentUserName == null &&
      //             currentGuardUsername
      //         ? RouteName.dashboardEmergency
      //         : currentGuardUsername != null &&
      //                 currentAdminUsername == null &&
      //                 currentUserName == null
      //             ? RouteName.guardHome
      //             : RouteName.loading,
      onGenerateRoute: Routes.generateRoute,
      // routes: {
      //   'loading': (context) => const Loading(),
      //   'emergency': (context) => const EmergencyReport(),
      //   'hazard': (context) => const HazardReport(),
      //   'crime': (context) => const CrimeReport(),
      //   'profile': (context) => const Profile(),
      //   'settings': (context) => const Settings(),
      //   'bulletin-board': (context) => const BulletinEvents(),
      //   'discussion': (context) => const Discussion(),
      //   'lost-found-news': (context) => const LostFoundNewsFeed(),
      //   'lost-found-claim': (context) => const LostFoundClaim(),
      //   'lost-found-post': (context) => const LostFoundPost(),
      //   'help-faq': (context) => const HelpFaq(),
      //   'login': (context) => const Login(),
      //   'register': (context) => const Register(),
      //   'on-board': (context) => const Onboard(),
      //   'home': (context) => const Home(),
      //   'home-screen': (context) => const HomeScreen(),
      //   'dashboard-emergency': (context) => const DashboardEmergency(),
      //   'dashboard-hazard': (context) => const DashboardHazard(),
      //   'dashboard-crime': (context) => const DashboardCrime(),
      //   'post': (context) => const Post(),
      //   'dashboard-bulletin': (context) => const DashboardBulletin(),
      //   'dashboard-lostfound': (context) => const DashboardLostFound(),
      //   'add-discussion': (context) => const AddDiscussion(),
      //   'user': (context) => const Users(),
      //   'user-admin': (context) => const UserAdmin(),
      //   'add-post': (context) => const AddPost(),
      //   'Discussion-admin': (context) => const DiscussionAdmin(),
      //   'Guard-home': (context) => const GuardHome(),
      //   'Actioned': (context) => const Actioned()
      // }
    );
  }
}
