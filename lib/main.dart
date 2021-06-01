import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dinn/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        Widget home;

        // Check for errors
        if (snapshot.hasError) {
          home = SomethingWentWrong();
        } else if (snapshot.connectionState == ConnectionState.done) {
          home = Login();
        } else {
          // Otherwise, show something whilst waiting for initialization to complete
          home = Loading();
        }

        return MaterialApp(title: 'Dinn', theme: ThemeData.dark(), home: home);
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext build) {
    return Text('Something went wrong');
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext build) {
    return Text('Loading...');
  }
}
