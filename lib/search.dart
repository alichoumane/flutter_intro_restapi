import 'package:flutter/material.dart';
import 'product.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controllerID = TextEditingController();
  String _text = ''; // displays product info or error message
  bool _searching = false;

  // update product info or display error message
  void update(String text) {
    setState(() {
      _searching = false;
      _text = text;
    });
  }

  // called when user clicks on the find button
  void searchProduct() {
    try {
      int pid = int.parse(_controllerID.text);
      getProductById(update, pid); // search asynchronously for product record
      setState(() {
        _searching = true;
      });
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('wrong ID arguments')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search product by ID'),
        centerTitle: true,
      ),
      body: Center(child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(width: 200, child: TextField(controller: _controllerID, keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter ID'))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: searchProduct,
            child: const Text('Find', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 20),
        Center(
            child:
            _searching ? SizedBox(width: 30, height: 30, child: CircularProgressIndicator())
            : Text(_text, style: const TextStyle(fontSize: 20))),
      ],),
      ),
    );
  }
}
