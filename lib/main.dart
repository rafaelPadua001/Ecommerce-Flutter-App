import 'package:ecommerce_clone_app/Services/subcategory_service.dart';
import 'package:ecommerce_clone_app/Widgets/Subcategories/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Widgets/SearchBarTextField.dart';
import 'Widgets/Products/Products.dart';
import 'Widgets/Profile.dart';
import 'Services/category_service.dart';
import 'Services/subcategory_service.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ecommerce Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Widget _currentPage = SearchBarTextField();
  Category category = Category();
  Subcategory subCategory = Subcategory();
  late Future<List<Map<String, dynamic>>> categoriesFuture;
  final baseUrl = 'http://192.168.122.1:8000/storage/Categories/Thumbnails/';

  @override
  void initState() {
    super.initState();
    categoriesFuture = category.fetchCategories();
  }

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCategoriesWidget(List<Map<String, dynamic>> categories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Define o número de colunas na grade
        crossAxisSpacing: 10, // Espaçamento entre as colunas
        mainAxisSpacing: 8, // Espaçamento entre as linhas
        childAspectRatio:
            1, // Define a proporção entre a largura e a altura dos itens
      ),
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final categoryData = categories[index];
        final imageName = categoryData['thumbnail'];
        final imageUrl = baseUrl + imageName;
        return InkWell(
          onTap: () {
            print('categoria clicada: ${categoryData['id']}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubcategoryWidget(
                    categoryId: categoryData['id'].toString()),
              ),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 175, // Altura da imagem
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    categoryData['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Products();
      case 1:
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: category.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return _buildCategoriesWidget(snapshot
                  .data!); // Chamando a função para construir as categorias
            } else {
              return Center(
                child: Text('Nenhum dado de categoria disponível.'),
              );
            }
          },
        );
      case 3:
        return Profile();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBarTextField(),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildPage(_selectedIndex),
          ),
         
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_sharp),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
