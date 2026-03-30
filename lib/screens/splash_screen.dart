// import 'package:flutter/material.dart';
// import 'home_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToHome();
//   }
//
//   _navigateToHome() async {
//     await Future.delayed(Duration(seconds: 2));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/logo.png', width: 150, height: 150),
//             SizedBox(height: 20),
//             Text(
//               'King Jamaica Caffe',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../utils/screen_util.dart'; // <-- import the utility

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return; // safety check
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Responsive logo size
            Image.asset(
              'assets/logo.png',
              width: context.responsive<double>(
                mobile: 220.0,
                tablet: 180.0,
                desktop: 240.0,
              ),
              height: context.responsive<double>(
                mobile: 220.0,
                tablet: 180.0,
                desktop: 240.0,
              ),
            ),
            // Responsive spacing
            SizedBox(height: context.responsive<double>(
              mobile: 20.0,
              tablet: 30.0,
              desktop: 40.0,
            )),
            // Responsive text
            Text(
              'King Jamaica Caffe',
              style: TextStyle(
                fontSize: context.responsive<double>(
                  mobile: 24.0,
                  tablet: 30.0,
                  desktop: 36.0,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.responsive<double>(
              mobile: 10.0,
              tablet: 15.0,
              desktop: 20.0,
            )),
            // The progress indicator scales automatically based on its container,
            // but you can also wrap it in a SizedBox if you want a different size.
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}