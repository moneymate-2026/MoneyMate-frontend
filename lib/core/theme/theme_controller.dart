import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';

//to change the whole app theme using riverpode



final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);