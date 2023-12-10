import 'package:flutter/material.dart';
import 'product.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loaded = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _loaded = true; // show product list
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first tome.
    getProducts(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
          IconButton(onPressed: !_loaded ? null : () {
            setState(() {
              _loaded = false; // show progress bar
              getProducts(update); // update data asynchronously
            });
          }, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {
            setState(() { // open the search product page
               Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) => const Search())
               );
            });
          }, icon: const Icon(Icons.search))
        ],
          title: const Text('Available Products'),
          centerTitle: true,
        ),
        // load products or progress bar
        body: _loaded ? const ShowProducts() : const Center(
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator())
        )
    );
  }
}

class ShowProducts extends StatelessWidget {
  const ShowProducts({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Column(children: [
            Container(
              color: index%2 == 0? Colors.blue[50]:Colors.blue[100],
              padding: EdgeInsets.all(5.0),
              width: width*0.9,
              child: Row(children: [
                SizedBox(width: width * 0.15,),
                Text(products[index].toString(), style: TextStyle(fontSize: width * 0.045)),
              ]),
            ),
            const SizedBox(height: 10.0)
          ]);
        });
  }
}

