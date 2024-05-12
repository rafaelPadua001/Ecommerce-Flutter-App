import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'Widgets/SearchBarTextField.dart';
import 'Widgets/Products/Products.dart';
import 'Widgets/Subcategories/subcategories.dart';
import 'Widgets/Banner/Banner.dart';
import 'Widgets/Profile.dart';
import 'Widgets/Cart/Cart.dart';
import 'Services/category_service.dart';
import 'Services/subcategory_service.dart';
import 'Services/banner_service.dart';
import 'Services/cart_service.dart';
import 'Model/CartModel.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
   runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
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
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Widget _currentPage = SearchBarTextField();
  Category category = Category();
  Subcategory subCategory = Subcategory();
  BannerWidget banner = BannerWidget();
  CartService cart = CartService();
  CartService cartService = CartService();
  late Future<List<Map<String, dynamic>>> categoriesFuture;
  late Future<List<Map<String, dynamic>>> bannerFuture;
  final baseUrl = 'http://192.168.122.1:8000/storage/Categories/Thumbnails/';
  final bannerUrl = 'http://192.168.122.1:8000/storage/Banners/';
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    categoriesFuture = category.fetchCategories();
    _currentPage = SearchBarTextField();
    _onItemTapped(_selectedIndex);
    countProductCart();
  }

  @override
  void _onItemTapped(int index) async {
    await _itemCartCount();
    setState(() {
      _selectedIndex = index;
    });
  
  }

Future<void> _itemCartCount() async {
  await countProductCart();
}
  
  Future<void> countProductCart() async {
    try {
      int _ItemCount = await cartService.countProductCart();
      setState(() {
        _cartItemCount = _ItemCount++;
      }); 
     
    }
    catch(e){
      throw Exception('erro ao contar itens no carrinho $e');
    }
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

  Widget _buildBanner(List<Map<String, dynamic>> banner) {
    return SingleChildScrollView(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            // shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: banner.length,
            itemBuilder: (context, index) {
              final bannerData = banner[index];
              final imageName = bannerData['image'].replaceAll('"', '');
              final imageUrl = bannerUrl + imageName;

              return InkWell(
                onTap: () {
                  if (bannerData.containsKey('image')) {
                    print('banner clicado ${bannerData["image"].toString()}');
                  } else {
                    print('A chave "image" não está presente em bannerData');
                  }
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
                            bannerData['id'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ]),
                ),
              );
            }));
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
      case 2:
        return Cart(); //Text('Itens do carrinho aqui');
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
      body: _selectedIndex == 0
          ? ListView(
              children: <Widget>[
                Visibility(
                  visible: _selectedIndex == 0,
                  child: SizedBox(
                    height: 200,
                    child: BannerWidget(),
                  ),
                ),
                Expanded(
                  child: _buildPage(_selectedIndex),
                ),
              ],
            )
          : _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_sharp),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
              icon: Consumer<CartModel>(
                builder: (context, cart, child) {
                  final itemCount = cart.items.length;
                  return Stack(
                    children: [
                      Icon(Icons.shopping_cart),
                      if (itemCount > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$itemCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
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
