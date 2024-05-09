import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_clone_app/main.dart';
import 'package:ecommerce_clone_app/Services/cart_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../../Services/cart_service.dart';

class ProductDialog extends StatefulWidget {
  final CartService _cartService = CartService();
  final String productId;
  final imageUrl = 'http://192.168.122.1:8000/storage/products/';
 

  ProductDialog({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  late Color chipColor;
  List<String> selectedColors = [];
  List<String> selectedSizes = [];
  Map<String, dynamic>? product;

  @override
  void initState() {
    super.initState();
    chipColor = Colors.white; // Cor padrão dos chips
    product = null; 
  }

  void handleColorSelection(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
  }

  void handleSizeSelection(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
  }

  void _sendDataToService(Map<String, dynamic>? product) {
    if (selectedColors.length >= 1 || selectedSizes.length >= 1) {
      product!['sizes'] = selectedSizes;
      product['colors'] = selectedColors;
      // print(
      //     'cores e tamanhos selecionados ${selectedColors} / ${selectedSizes}');
      //  print(product['colors']);
      //  print(product['size']);
      widget._cartService.store(product);
      setState(() {
          ScaffoldMessenger
          .of(context)
          .showSnackBar(
            SnackBar(
              content: Text('Um novo item foi adicionado ao carrinho'),
              backgroundColor: Colors.green,
              ));
      });
          
    } else {
      print('nada selecionado');
    }
  }

  Widget _buildDeliveryButton(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoButton(
          child: Text('Delivery calculate'),
          onPressed: (){
            _buildDeliveryDialog(context);
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Click no frete !')));
          })
      ],
    );
  }

  void _buildDeliveryDialog(BuildContext context){
    showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('Delivery calculate'),
        content: _buildDeliveryDialogContent(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      );
    }
  );
  }

  Widget _buildDeliveryDialogContent(){
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('This is a fullscreen dialog'),
      SizedBox(height: 8,),
      _buildTextFieldZipCode(),
    ],
  );
}

Widget _buildTextFieldZipCode(){
  return TextField(
    decoration: InputDecoration(
      labelText: 'Zip-Code',
      hintText: 'Insert zip code',
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
    maxLength: 8,
    onChanged: (value) {
      print(value);
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto Selecionado'),
      ),
      body: FutureBuilder(
        future: widget._cartService
            .fetchProductDialog(productId: widget.productId),
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
           if (productData.isNotEmpty) { // Verifique se há dados na lista
              product = productData.first; // Atribua o primeiro item à variável product
              final List<String> cleanColors = _parseStringList(product!['colors']);
              final List<String> cleanSizes = _parseStringList(product!['size']);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageCarousel(product!['images']),
                    _buildProductDetails(product!),
                    if (cleanColors.isNotEmpty) _buildColorSection(cleanColors),
                    if (cleanSizes.isNotEmpty) _buildSizeSection(cleanSizes),
                    _buildDeliveryButton(),
                    _buildDescriptionSection(product!),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Nenhum produto carregado...'),
              );
            }
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
                _sendDataToService(product);
              },
              child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                print('Comprar produto...');
                _sendDataToService(product);
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
            for (var color in cleanColors) _buildColorChip(color),
          ],
        ),
      ],
    );
  }

  Widget _buildColorChip(String color) {
    String selectedColor = '';
    Color chipColor =
        Color(int.parse(color.substring(1), radix: 16) + 0xFF000000);
    Color pressedColor = Colors.black.withOpacity(0.8);
    Color boxDecoration = chipColor;

    return InkWell(
      onTapDown: (_) {
        boxDecoration = pressedColor;
      },
      onTapUp: (_) {
        boxDecoration = chipColor;
      },
      splashColor: pressedColor,
      child: ChoiceChip(
        backgroundColor: boxDecoration,
        label: Text(color),
        selected:
            selectedColor == color, // Verifica se este chip está selecionado
        onSelected: (isSelected) {
          selectedColor = isSelected ? color : '';
          print('Tamanho selecionado ${color}');
          handleColorSelection(color);
          // setState(() {
          //  // selectedSize = isSelected ? size : ''; // Atualiza o tamanho selecionado com base na seleção do chip
          //   print('Tamanho selecionado ${size}');
          // });
          boxDecoration = pressedColor;
        },
      ),
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
            for (var size in cleanSizes) _buildSelectedSize(size),
            //     Chip(label: Text(size)),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedSize(String size) {
    Color chipColor = Colors.white;
    Color pressedColor = Colors.red;
    Color boxDecoration = chipColor;
    String selectedSize = '';
    if(size == 'null'){
      size = 'unique';
    }
    return InkWell(
      splashColor: pressedColor,
      child: ChoiceChip(
        label: Text(size),
        selected: selectedSize == size,
        onSelected: (isSelected) {
          selectedSize = isSelected ? size : '';
          print('Tamanho selecionado ${size}');
          handleSizeSelection(size);

          boxDecoration = pressedColor;
        },
        backgroundColor: boxDecoration,
        selectedColor: pressedColor,
      ),
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
