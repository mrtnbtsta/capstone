import 'package:capstone_project/admin/account_pending.dart';
import 'package:capstone_project/admin/add_discussion.dart';
import 'package:capstone_project/admin/add_faq.dart';
import 'package:capstone_project/admin/add_post.dart';
import 'package:capstone_project/admin/bulletin_events.dart';
import 'package:capstone_project/admin/crime_report.dart';
import 'package:capstone_project/admin/discussion_admin.dart';
import 'package:capstone_project/admin/emergency_report.dart';
import 'package:capstone_project/admin/faq.dart';
import 'package:capstone_project/admin/hazard_report.dart';
import 'package:capstone_project/admin/lost_found_claim.dart';
import 'package:capstone_project/admin/monthly_report.dart';
import 'package:capstone_project/admin/post.dart';
import 'package:capstone_project/admin/summary_report.dart';
import 'package:capstone_project/admin/user_admin.dart';
import 'package:capstone_project/guard/actioned.dart';
import 'package:capstone_project/guard/guard_home.dart';
import 'package:capstone_project/guard/summary_report.dart';
import 'package:capstone_project/view/actioned_user.dart';
import 'package:capstone_project/view/bulletin_events.dart';
import 'package:capstone_project/view/crime_report.dart';
import 'package:capstone_project/view/discussion.dart';
import 'package:capstone_project/view/emergency_contact.dart';
import 'package:capstone_project/view/emergency_report.dart';
import 'package:capstone_project/view/hazard_report.dart';
import 'package:capstone_project/view/help_faq.dart';
import 'package:capstone_project/view/home.dart';
import 'package:capstone_project/view/loading.dart';
import 'package:capstone_project/view/login.dart';
import 'package:capstone_project/view/lost_found_post.dart';
import 'package:capstone_project/view/lostfound_newsfeed.dart';
import 'package:capstone_project/view/onboard.dart';
import 'package:capstone_project/view/profile.dart';
import 'package:capstone_project/view/register.dart';
import 'package:capstone_project/view/settings.dart';
import 'package:capstone_project/view/summary_report.dart';
import 'package:capstone_project/view/users.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const loading = "loading";
  static const addFaq = "add-faq";
  static const faq = "faq";
  static const emergency = "emergency";
  static const hazard = "hazard";
  static const crime = "crime";
  static const profile = "profile";
  static const settings = "settings";
  static const bulletinBoard = "bulletin-board";
  static const discussion = "discussion";
  static const lostFoundNews = "lost-found-news";
  static const lostFoundClaim = "lost-found-claim";
  static const lostFoundPost = "lost-found-post";
  static const helpFaq = "help-faq";
  static const login = "login";
  static const register = "register";
  static const onBoard = "on-board";
  static const home = "home";
  static const dashboardEmergency = "dashboard-emergency";
  static const dashboardHazard = "dashboard-hazard";
  static const dashboardCrime = "dashboard-crime";
  static const post = "post";
  static const dashboardBulletin = "dashboard-bulletin";
  static const dashboardLostfound = "dashboard-lostfound";
  static const addDicussion = "add-dicussion";
  static const user = "user";
  static const userAdmin = "user-admin";
  static const addPost = "add-post";
  static const discussionAdmin = "Discussion-admin";
  static const guardHome = "Guard-home";
  static const actioned = "Actioned";
  static const actionedUser = "Actioned-user";
  static const emergencyContact = "Emergency-contact";
  static const accountPending = "Account-pending";
  static const summaryAdminReport = "Summary-report";
  static const summaryGuardReport = "Summary-guard-report";
  static const summaryUserReport = "Summary-user-report";
  static const monthlyReport = "Monthly-report";
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteName.loading:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Loading(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.emergency:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const EmergencyReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.hazard:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HazardReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.crime:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CrimeReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.accountPending:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AccountPending(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.profile:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Profile(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.summaryAdminReport:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SummaryReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.settings:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Settings(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.summaryUserReport:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SummaryUserReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.summaryGuardReport:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SummaryGuardReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.bulletinBoard:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const BulletinEvents(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.discussion:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Discussion(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.lostFoundNews:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LostFoundNewsFeed(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.lostFoundPost:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LostFoundPost(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.helpFaq:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HelpFaq(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.login:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Login(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.register:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Register(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.onBoard:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Onboard(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.home:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Home(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.dashboardEmergency:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardEmergency(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.dashboardHazard:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardHazard(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.monthlyReport:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MonthlyReport(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.dashboardCrime:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardCrime(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.post:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Post(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.addFaq:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddFaq(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.dashboardBulletin:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardBulletin(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.dashboardLostfound:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardLostFound(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.addDicussion:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddDiscussion(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.user:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Users(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.userAdmin:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const UserAdmin(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.faq:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Faq(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.addPost:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AddPost(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.discussionAdmin:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DiscussionAdmin(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.guardHome:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GuardHome(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.actioned:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Actioned(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.actionedUser:
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ActionedUser(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case RouteName.emergencyContact:
        return PageRouteBuilder(pageBuilder:(context, animation, secondaryAnimation) => 
          const EmergencyContact(), 
          transitionDuration: Duration.zero, 
          reverseTransitionDuration: Duration.zero);
    }
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: SafeArea(child: Center(child: Text("No route defined"))),
            ));
  }
}
