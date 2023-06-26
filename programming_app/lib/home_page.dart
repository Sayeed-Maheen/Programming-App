import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showText = true;
  bool isLoggedIn = false;
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  var time = DateTime.now();
  Timer? logoutTimer;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    logoutTimer
        ?.cancel(); // Cancel the logout timer when the widget is disposed
    super.dispose();
  }

  void startLogoutTimer() {
    logoutTimer?.cancel(); // Cancel the previous timer if it's running
    logoutTimer = Timer(Duration(seconds: 10), logout);
  }
  void resetLogoutTimer() {
    logoutTimer?.cancel(); // Cancel the previous timer if it's running
    startLogoutTimer(); // Start the logout timer again
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    if (loggedIn != null && loggedIn) {
      setState(() {
        isLoggedIn = true;
      });
      startLogoutTimer(); // Start the logout timer when the user is logged in
    }
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    setState(() {
      isLoggedIn = true;
      timestamp = DateTime.now().millisecondsSinceEpoch;
    });
    MyToast("Login");
    startLogoutTimer(); // Start the logout timer after logging in
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      isLoggedIn = false;
      timestamp = DateTime.now().millisecondsSinceEpoch;
    });
    MyToast("Logout");
    logoutTimer
        ?.cancel(); // Cancel the logout timer when the user manually logs out
  }

  void MyToast(String value) {
    if (isLoggedIn) return; // Check if already logged in
    Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    print(timestamp);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(showText ? "hello" : "maheen"),
            Text(isLoggedIn ? "Logged in" : "Logged out"),
            const SizedBox(height: 16),
            Text('Current time ${time.hour} : ${time.minute}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isLoggedIn ? null : login,
                  child: const Text("Login"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: isLoggedIn ? logout : null,
                  child: const Text("Logout"),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
