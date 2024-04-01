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
      return null;
    } catch (e) {
      
      return e.toString();
    }
  }

  Future<String?> loginWithEmailAndPassword(String _emailController, String _passwordController) async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController, password: _passwordController);
        return userCredential.user!.uid;
    }
    catch(e){
      throw 'Erro ao fazer login: $e';
    }
  }

}
