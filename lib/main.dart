import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intern/login/login.dart';
import 'homescreen.dart';

// import 'src/my_app.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final storage = const FlutterSecureStorage();

  Future<bool> checkLoginStatus() async {
    String? value = await storage.read(key: "uid");
    if (value == null) {
      return false;
    }
    // print(value);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()));
          }
          return MaterialApp(
            title: 'Flutter Firebase EMail Password Auth',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            debugShowCheckedModeBanner: false,
            // home:const MainScreen()
            home: FutureBuilder(
                future: checkLoginStatus(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    return const LoginPhone();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        color: Colors.white,
                        child:
                        const Center(child: CircularProgressIndicator()));
                  }
                  return HomeScreen();
                }),
          );
        });
  }
}
