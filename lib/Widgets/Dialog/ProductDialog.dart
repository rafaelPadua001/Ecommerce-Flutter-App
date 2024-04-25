import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../Services/product_dialog_service.dart';

class ProductDialog extends StatefulWidget {
  final ProductDialogService _productDialogService = ProductDialogService();
  final String productId;
  final imageUrl = 'http://192.168.122.1:8000/storage/products/';

  ProductDialog({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = Colors.white; // Cor padrão dos chips
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto Selecionado'),
      ),
      body: FutureBuilder(
        future: widget._productDialogService.fetchProductDialog(productId: widget.productId),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Nenhum produto carregado... ${snapshot.error}'),
            );
          } else {
            final List<Map<String, dynamic>> productData = snapshot.data!;
            final product = productData.first;
            final List<String> cleanColors = _parseStringList(product['colors']);
            final List<String> cleanSizes = _parseStringList(product['size']);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImageCarousel(product['images']),
                  _buildProductDetails(product),
                  if (cleanColors.isNotEmpty) _buildColorSection(cleanColors),
                  if (cleanSizes.isNotEmpty) _buildSizeSection(cleanSizes),
                  _buildDescriptionSection(product),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                print('Adicionar ao carrinho...');
              },
              child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                print('Comprar produto...');
              },
              child: Text('Buy Product', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(String images) {
    List<Widget> imageWidgets = images.split(',').map<Widget>((image) {
      return Container(
        child: Image.network(
          widget.imageUrl + image.trim(),
          fit: BoxFit.cover,
        ),
      );
    }).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
      ),
      items: imageWidgets,
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> product) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${product['name']}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          _buildRatingStars(),
          SizedBox(height: 8.0),
          Text(
            'Preço: R\$ ${product['price']}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Qtd: ${product['stock_quantity']}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Height: ${product['height']} x Width: ${product['width']} x Length: ${product['length']}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.yellow),
        Icon(Icons.star, color: Colors.yellow),
        Icon(Icons.star, color: Colors.yellow),
        Icon(Icons.star, color: Colors.yellow),
        Icon(Icons.star_half, color: Colors.yellow),
      ],
    );
  }

  Widget _buildColorSection(List<String> cleanColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          'Cores disponíveis:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          children: [
            for (var color in cleanColors)
              _buildColorChip(color),
          ],
        ),
      ],
    );
  }

  Widget _buildColorChip(String color) {
  bool isHovering = false; // Variável para rastrear se o cursor está sobre o chip

  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        isHovering = true;
        // Adicione a lógica para lidar com o clique no chip aqui
        print('Maconha');
        
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
          shape: BoxShape.circle,
        ),
      ),
    ),
    onEnter: (_) {
      setState(() {
        isHovering = true; // O cursor está sobre o chip
        // Defina a cor do chip quando estiver em foco
        // Por exemplo, você pode definir a cor para uma cor mais escura ou diferente
        backgroundColor = Colors.white;
      });
    },
    onExit: (_) {
      setState(() {
        isHovering = false; // O cursor não está mais sobre o chip
        // Defina a cor do chip quando não estiver em foco
        backgroundColor = Colors.white;
      });
    },
  );
}



  Widget _buildSizeSection(List<String> cleanSizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text(
          'Tamanhos Disponíveis:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          children: [
            for (var size in cleanSizes) Chip(label: Text(size)),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Map<String, dynamic> product) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          Text('${product['description']}'),
          SizedBox(height: 8.0),
          ExpansionTile(
            title: Text('Comments'),
            children: [
              Text('${product['comments']}'),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _parseStringList(String? data) {
    if (data == null || data.isEmpty) return [];
    return data.replaceAll(RegExp(r'[^\w\s]+'), '').split(' ');
  }
}
