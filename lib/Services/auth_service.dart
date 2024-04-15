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
      
     throw Exception('Erro ao registrar: $e');
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

  User? getCurrentUser(){
    return _auth.currentUser;
  }
  Future<void> updateUser(String email, String name) async {
    User? user = _auth.currentUser;
    if(user != null){
      try{
        await user.verifyBeforeUpdateEmail(email);
        await user.updateDisplayName(name);
      }
      catch(e){
        throw Exception('Usuario não encontrado: $e');
      }
    }
  }
  Future<void> logout() async  {
    try{
      await _auth.signOut();
    }
    catch(e){
      throw 'Erro ao fazer logout: $e';
    }
  }

  
}
