import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; 

  Future<String?> RegisterWithEmailandPassword(
      String _emailController, String _passwordController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController, 
              password: _passwordController
          );
      print('Usuario registrado com sucesso: {$userCredential.user!.uid}');
      return null;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return e.toString();
    }
  }
}
