import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';
import 'package:flutter/material.dart';
import './LoginForm.dart';

class Profile extends StatefulWidget{
  @override
  _ProfileState createState() => _ProfileState();
} 

class _ProfileState extends State<Profile> {
  //  final String userId;
  //  final String email;

  // const Profile({Key? key, required this.userId, required this.email})
  //     : super(key: key);
  // const Profile({Key? key}) : super(key: key);
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    Future<void> logout(BuildContext context) async {
      try {
        await _authService.logout();
        setState(() {
           Navigator.of(context).popUntil((route) => route.isFirst);
        });
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sua seção foi encerrada, Até breve  ...' )));
      } catch (e) {
        print('Erro ao fazer logout: $e');
      }
      return;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null)
                    Text(
                      '${user!.email ?? 'Não definido'}',
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            if (user != null)
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                onPressed: () => logout(context),
                child: const Text('Logout'),
              ),
            if (user == null)
             
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm()),
                ),
                child: const Text('Login'),
              ),
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
