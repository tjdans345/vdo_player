import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/image/logo.png"),
            Row(
              children: [
                Text("VIDEO"),
                Text("PLAYER")
              ],
            )
          ],
        ),
      ),
    );
  }
}
