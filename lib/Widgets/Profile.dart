import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String userId;
  final String email;

  const Profile({Key? key, required this.userId, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [Text(style: TextStyle(fontSize: 12), '$email')],
                )
              ],
            ),
            // Row(
            //   children: [Text(style: TextStyle(fontSize: 12), '$userId')],
            // ),
          ],
        ),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Card(
                    child: Text('In your cart: 0'),
                  ),
                ],
              ),
              Column(
                children: [
                  Card(
                    child: Text('In your wishlist: 0'),
                  ),
                ],
              ),
              Column(
                children: [
                  Card(
                    child: Text('In your ordered: 0'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      )),
    );
  }
}
