import 'package:ecommerce_clone_app/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(Edit());

class Edit extends StatelessWidget{ 
  Edit({super.key});
  

@override
  Widget build(BuildContext context){
   return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Edit')),
      body: const EditForm(),
    ),
   );
 }
}

class EditForm extends StatefulWidget {
  const EditForm({super.key});

  @override
  State<EditForm> createState() => _EditState();
}

class _EditState extends State<EditForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    
  }
  
  Widget build(BuildContext context){
    return Scaffold (
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
          children: <Widget> [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'E-mail',
              ),
              validator: (String? value){
                if(value == null || value.isEmpty){
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                validator: (String? value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter some text';
                  }
                  return null;
                }
              )
            ),
            
            //Next Fields
            Padding(padding: const EdgeInsets.symmetric(vertical: 16.0 ),
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  //Process datas
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