import 'package:flutter/material.dart';
import 'package:ecommerce_clone_app/Widgets/Register.dart';

void main() => runApp(const LoginForm());

class LoginFormApp extends StatelessWidget {
  const LoginFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Form Sample')),
        body: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      prefixIcon: const Icon(Icons.mail),
                      hintText: 'Enter your e-mail',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a some valid e-mail';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      prefixIcon: const Icon(Icons.key),
                      hintText: 'Enter your new Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a some password max 8 characters';
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
                      child: TextButton(
                          onPressed: () {
                            print('Carregar esqeceu sua senha');
                          },
                          child: Text('forgot password ?')),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextButton(
                        
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text('Join us'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          //primary: Colors.white, // Cor do texto
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //Process datas
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child:  ElevatedButton(
                        style: TextButton.styleFrom(
                          //primary: Colors.white, // Cor do texto
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Return'),
                    )
                    ),
                   
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
