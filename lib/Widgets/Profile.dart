import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Services/auth_service.dart';
import 'package:flutter/material.dart';
import './LoginForm.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
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
  XFile? _imageFile;
  String? _profileImageUrl;
 
  Future<String?> getProfileImageUrl() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$userId');
    String downloadURL = await storageReference.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Erro ao obter a URL da imagem do perfil: $e');
    return null;
  }
}
  @override 
  void initState() {
  super.initState();
  getProfileImageUrl().then((imageUrl) {
    setState(() {
      _profileImageUrl = imageUrl;
    });
  });
}
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    Future<void> logout(BuildContext context) async {
      try {
        await _authService.logout();
        setState(() {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sua seção foi encerrada, Até breve  ...')));
      } catch (e) {
        print('Erro ao fazer logout: $e');
      }
      return;
    }

    Future<void> uploadImage() async {
      if (_imageFile == null || user == null) {
        print('Imagem ou usuário é nulo.');
        return;
      }

      File file = File(_imageFile!.path);

      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/${user!.uid}');
      try {
        UploadTask uploadTask = storageReference.putFile(file);
        await uploadTask.whenComplete(() async {
          String _imageUrl = await storageReference.getDownloadURL();

          setState(() {
            print('upload com sucesso');
          });
        });
      } catch (e) {
        print('Erro durante o upload da imagem');
      }
    }

    Future<void> getImage() async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageFile = image;
        uploadImage();
      });
    }

    Future<String?> getProfileImageUrl() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$userId');
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Erro ao obter a URL da imagem do perfil: $e');
      return null;
    }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                        backgroundImage: _profileImageUrl != null
    ? NetworkImage(_profileImageUrl!)
    : (_imageFile != null
        ? FileImage(File(_imageFile!.path)) as ImageProvider<Object>?
        : NetworkImage(
            'https://previews.123rf.com/images/triken/triken1608/triken160800029/61320775-male-avatar-profile-picture-default-user-avatar-guest-avatar-simply-human-head-vector-illustration.jpg')),

                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  enableFeedback: true,
                                  onTap: () {
                                    getImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.cloud_upload,
                                      color: Colors.white,
                                      size: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${user!.email ?? 'Não definido'}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
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
