import 'package:flutter/material.dart';
import 'product.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controllerValue = TextEditingController();
  String _text = ''; // displays product info or error message
  bool _searching = false;
  bool _searchByID = true;
  bool _resultsByID = false;
  bool _resultsByName = false;
  String _searchHint = "Enter ID";

  // update product info or display error message
  void updateSingleProduct(String text) {
    setState(() {
      _searching = false;
      _resultsByID = true;
      _resultsByName = false;
      _text = text;
    });
  }

  void updateListOfProduct(bool success) {
    setState(() {
      _searching = false; // show product list
      _resultsByID = false;
      _resultsByName = true;
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  // called when user clicks on the find button
  void searchProduct() {
    try {
      if(_searchByID)
        getProductById(updateSingleProduct, int.parse(_controllerValue.text)); // search asynchronously for product record
      else
        getProductsByName(updateListOfProduct, _controllerValue.text);

      setState(() {
        _searching = true;
      });
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('wrong arguments')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search products'),
        centerTitle: true,
      ),
      body: Center(child: Column(children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("By ID"),
          Radio(value: true, groupValue: _searchByID, onChanged: (bool? val){
              setState(() {
                _searchByID = val as bool;
                _searchHint = "Enter ID";
              });
          }),
          Text("By Name"),
          Radio(value: false, groupValue: _searchByID, onChanged: (bool? val){
            setState(() {
              _searchByID = val as bool;
              _searchHint = "Enter name";
            });
          }),
        ],),
        const SizedBox(height: 10),
        SizedBox(width: 200, child: TextField(controller: _controllerValue, keyboardType: TextInputType.number,
            decoration: InputDecoration(border: OutlineInputBorder(), hintText: _searchHint))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: searchProduct,
            child: const Text('Find', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 20),
        _searching ? Center(child:SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : _resultsByID ? Center(child:Text(_text, style: const TextStyle(fontSize: 20)))
            : _resultsByName ? const Expanded(child:const ShowFilteredProducts())
            : Text("") ,
      ],),
      ),
    );
  }
}


class ShowFilteredProducts extends StatelessWidget {
  const ShowFilteredProducts({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: products_filtered.length,
        itemBuilder: (context, index) {
          return Column(children: [
            Container(
              color: index%2 == 0? Colors.blue[50]:Colors.blue[100],
              padding: EdgeInsets.all(5.0),
              width: width*0.9,
              child: Row(children: [
                SizedBox(width: width * 0.15,),
                // If the Text widget doesn't fit within the available space, it will flexibly adjust its size.
                Flexible(child:Text(products_filtered[index].toString(), style: TextStyle(fontSize: width * 0.045))),
              ]),
            ),
            const SizedBox(height: 10.0)
          ]);
        });
  }
}
