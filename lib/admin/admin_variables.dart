import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

//bottomNavBar
var currentAdminScreen = AdminScreenNames.home;

enum AdminScreenNames { home, post, bulletin, lostfound }



int currentIndex = 0;

final iconList = <IconData>[
  EvaIcons.home,
  FontAwesome.file,
  FontAwesome.book_atlas_solid,
  FontAwesome.searchengin_brand
];

final iconNames = ["Home", "Post", "Bulletin Board", "Lost & Found"];
