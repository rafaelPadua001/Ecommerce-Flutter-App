import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Services/auth_service.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key});

  @override
  State<EditForm> createState() => _EditState();
}

class _EditState extends State<EditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService authService = AuthService();
  String _email = '';
  String _name = '';
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void _saveChanges() {
    String updatedName = _nameController.text;
    String updatedEmail = _emailController.text;

    Navigator.pop(context, {'name': updatedName, 'email': updatedEmail});
  }

  Future<void> _getUser() async {
    User? user = authService.getCurrentUser();
    if (user != null) {
      _email = user.email ?? '';
      _emailController = TextEditingController(text: _email);
      _name = user.displayName ?? '';
      _nameController = TextEditingController(text: _name);
    }
  }

  Future<void> _updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await authService.updateUser(
            _emailController.text, _nameController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('dados atualizados com sucesso!')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao atualizar os dados: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: SizedBox(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'E-mail:',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter some text';
                              }
                              return null;
                            })),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _updateUserData();
                            _saveChanges();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
