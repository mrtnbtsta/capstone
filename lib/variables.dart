import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

int currentIndex = 0;
int reportIndex = 0;
int guardIndex = 0;

enum ScreenNames { home, report, bulletin, lostfound }

final iconList = <IconData>[
  EvaIcons.home,
  FontAwesome.file,
  FontAwesome.book_atlas_solid,
  FontAwesome.searchengin_brand
];

enum SidebarEnum {
  incidentReport,
  bulletinBoard,
  discussion,
  lostAndfound,
  profile,
  settings,
  faq,
  logout
}

var currentScreen = ScreenNames.home;
var currentEnum = SidebarEnum.incidentReport;

final iconNames = ["Home", "Report", "Bulletin Board", "Lost & Found"];

List<String> itemList = ["Report", "Actioned"];
