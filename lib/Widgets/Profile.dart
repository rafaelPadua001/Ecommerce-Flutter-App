
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './LoginForm.dart';
import 'package:ecommerce_clone_app/Widgets/LoginForm.dart';

class Profile extends StatelessWidget {
  // final String userId;
  // final String email;

  // const Profile({Key? key, required this.userId, required this.email})
  //     : super(key: key);

  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              children: [
                Column(
                  // children: [Text(style: TextStyle(fontSize: 12), '$email')],
                  children: [
                    if(user == null)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginForm()),
                        )
                       
                       
                      },
                      child: const Text('Login'),
                    ),
                    if(user != null)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () => {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginForm()),
                        // )
                       
                       
                      },
                      child: const Text('Logout'),
                    ),
                  ],
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
