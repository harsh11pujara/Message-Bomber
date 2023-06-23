import 'package:explodemessage/app_provider.dart';
import 'package:explodemessage/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageBombProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                centerTitle: true, foregroundColor: Colors.teal, elevation: 1.0),
            primarySwatch: Colors.teal,
            useMaterial3: true,
            brightness: Brightness.dark),
        home: Home(),
      ),
    );
  }
}
