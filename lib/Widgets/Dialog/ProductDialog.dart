import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_clone_app/main.dart';
import 'package:ecommerce_clone_app/Services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../Services/cart_service.dart';
import '../../Model/CartModel.dart';
import '../../Services/delivery_service.dart';
import '../../Services/api_service.dart';

class ProductDialog extends StatefulWidget {
  final CartService _cartService = CartService();
  final String productId;
  final imageUrl = '${ApiConfig.getApiBaseUrl()}/storage/products/';

  ProductDialog({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  late Color chipColor;
  List<String> selectedColors = [];
  List<String> selectedSizes = [];
  Map<String, dynamic>? product;
  final _zipCodeController = TextEditingController();
  final DeliveryService _deliveryService = DeliveryService();
  Map<String, dynamic>? _selectedDelivery;
  List<Map<String, dynamic>> quotations = [];
  double newPrice = 0.00;
  String _selectedCompany = '';
  String quotationName = '';
  double quotationPrice = 0.00;
  @override
  void initState() {
    super.initState();
    chipColor = Colors.white;
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

  void _sendDataToService(Map<String, dynamic>? product, quotationName, quotationPrice) {
    if (selectedColors.length >= 1 || selectedSizes.length >= 1) {
      product!['sizes'] = selectedSizes;
      product['colors'] = selectedColors;
      widget._cartService.store(product, quotationName, quotationPrice);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Um novo item foi adicionado ao carrinho'),
          backgroundColor: Colors.green,
        ));
      });
    } else {
      print('nada selecionado');
    }
  }

  Widget _buildDeliveryButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDeliveries(),
        CupertinoButton(
          child: Text('Delivery calculate'),
          onPressed: () {
            _buildDeliveryDialog(context);
          },
        )
      ],
    );
  }

  void _buildDeliveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: 400), // Defina a altura máxima desejada
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Delivery calculate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDeliveries(),
                  SizedBox(height: 10),
                  _buildTextFieldZipCode(),
                  ElevatedButton(
                    onPressed: () async {
                      final data = {
                        'postal_code': _zipCodeController.text,
                        'shippment': _selectedDelivery?['name'],
                        'height': double.parse(product!['height']),
                        'width': double.parse(product!['width']),
                        'length': double.parse(product!['length']),
                        'weight': double.parse(product!['weight']),
                        'price': double.parse(product!['price']),
                        'quantity': 1,
                      };

                      final response = await _deliveryService.calculate(data);
                      print(response);
                      response.forEach((Map<String, dynamic> quotation) {
                        if (quotation.containsKey('id')) {
                          quotations.add(quotation);
                        }
                      });
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Buscando opcoes de frete para ${_zipCodeController.text}'),
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Search deliveries'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFieldZipCode() {
    return TextField(
      controller: _zipCodeController,
      decoration: InputDecoration(
        labelText: 'Enter your zip code',
        hintText: '123456-78',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(9),
        FilteringTextInputFormatter.digitsOnly,
        _ZipCodeFormatter(),
      ],
      keyboardType: TextInputType.number,
    );
  }
 


  Widget _buildDeliveries() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _deliveryService.fetchDelivery(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final delivery = snapshot.data![index];
                  return RadioListTile<Map<String, dynamic>>(
                    title: Text(delivery['name']),
                    value: delivery,
                    groupValue: _selectedDelivery,
                    onChanged: (Map<String, dynamic>? value) {
                      setState(() {
                        _selectedDelivery = value as Map<String, dynamic>;
                        print(_selectedDelivery?['name']);
                      });
                    },
                  );
                },
              ),
            );
          } else {
            return Text('Nenhum metodo de entrega cadastrado');
          }
        });
  }
  

  Widget _buildQuotations(Function(double) onPriceUpdated) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: quotations.map((quotation) {
          final subtitle =
              quotation.containsKey('price') && quotation['price'] != null
                  ? 'Preço: ${quotation['price'].toString()}'
                  : 'Serviço econômico indisponível para o trecho.';

          final pictureUrl = quotation.containsKey('company') &&
                  quotation['company'].containsKey('picture')
              ? quotation['company']['picture']
              : null;

          return Column(
            children: [
              ListTile(
                leading: pictureUrl != null
                    ? Image.network(
                        pictureUrl,
                        width: 40,
                        height: 40,
                      )
                    : null,
              ),
              RadioListTile<String>(
                title: Text(quotation['name']),
                subtitle: Text(subtitle),
                value: quotation.toString(),
                groupValue: _selectedCompany,
                onChanged: (value) {
                  Provider.of<CartModel>(context, listen: false).addItem(product);
                  setState(() {
                    
                    _selectedCompany = value as String;
               
                    final double productPrice = double.parse(product!['price']);
                    final double companyPrice = double.parse(quotation['price']);
                     quotationName = quotation['name'];
                    quotationPrice = companyPrice;
                    newPrice = productPrice + companyPrice;
                   
                    product!['price'] = newPrice.toStringAsFixed(2);
                    
                    onPriceUpdated(newPrice);
                   
                  });
                  
                },
              ),
            ],
          );
        }).toList(),
      );
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto Selecionado'),
      ),
      body: FutureBuilder(
        future:
            widget._cartService.fetchProductDialog(productId: widget.productId),
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
            if (productData.isNotEmpty) {
              // Verifique se há dados na lista
              product = productData
                  .first; // Atribua o primeiro item à variável product
              final List<String> cleanColors =
                  _parseStringList(product!['colors']);
              final List<String> cleanSizes =
                  _parseStringList(product!['size']);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageCarousel(product!['images']),
                    _buildProductDetails(product!),
                    if (cleanColors.isNotEmpty) _buildColorSection(cleanColors),
                    if (cleanSizes.isNotEmpty) _buildSizeSection(cleanSizes),
                    _buildDeliveryButton(),
                     if (quotations.isNotEmpty) _buildQuotations((newPrice){
                     
                     }),
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
                setState(() {
                  _sendDataToService(product, quotationName, quotationPrice);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _sendDataToService(product, quotationName, quotationPrice);
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
            newPrice >= 1 ? 'Preço R\$ ${newPrice}' : 'Preço: R\$ ${product['price']}',
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
    if (size == 'null') {
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

class _ZipCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Adiciona o hífen após os primeiros 5 dígitos
    if (text.length >= 6) {
      return TextEditingValue(
        text: '${text.substring(0, 5)}-${text.substring(5)}',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }

    return newValue;
  }
}
