import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Register extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register user'),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: SizedBox(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
                        hintText: 'Email Here',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid E-mail';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        hintText: 'Password Here',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              //Process datas
<<<<<<< Updated upstream
                              print('Processar os dados e eviar para cloudflare');
=======
                              try{
                                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text
                                );
                                print('Usuario registrado com sucesso: {$userCredential.user!.uid}');
                              }
                              catch(e){
                                print('Erro ao registrar usuário: $e');

                              }
>>>>>>> Stashed changes
                              print(
                                  'Processar os dados e eviar para cloudflare');
                            }
                          },
                          child: Text('Register'),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Retorna para a página anterior
                            Navigator.pop(context);
                          },
                          child: Text('Return'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
