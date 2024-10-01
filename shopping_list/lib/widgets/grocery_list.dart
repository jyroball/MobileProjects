import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
//import 'package:shopping_list/data/dummy_items.dart';   Initial test
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  //initializes load items at the satrt
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  //when app loads for the first time
  void _loadItems() async {
    final url = Uri.https('flutter-practice-58b62-default-rtdb.firebaseio.com', 'shopping-list.json');

    //try catch for error handling
    try {
      final response = await http.get(url);

      if(response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please Try Again Later';
        });
      }

      //if no initial items on lkist have this checkl (firebase returns a string 'null' it is backend specific so look into it)
      if(response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadItems = [];

      for(final item in listData.entries) {
        //temp val for category in item
        final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
        loadItems.add(
          GroceryItem(
            id: item.key, 
            name: item.value['name'], 
            quantity: item.value['quantity'], 
            category: category
          )
        );
      }

      setState(() {
        _groceryItems = loadItems;
        _isLoading = false;
      });
    }
    catch (error) {
      setState(() {
        _error = 'Something went wrong! Please Try Again Later';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      )
    );

    if(newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-practice-58b62-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    //something wrong went with http delete so just bring back item for now
    if(response.statusCode >= 400) {
      //Optional show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet'),);

    if(_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if(_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,     //find out how many times list view needs to iterate builder
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    //error with http request
    if(_error != null) {
      content = Center(child: Text(_error!),);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem, 
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}


/*

CODE USING FUTURE BUILDER NOT IDEAL FOR THIS APP SO NOT AS GOOD

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
//import 'package:shopping_list/data/dummy_items.dart';   Initial test
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;  //late tells us no initial value but will be initialized to have one before used
  String? _error;

  //initializes load items at the satrt
  @override
  void initState() {
    _loadedItems = _loadItems();
    super.initState();
  }

  //when app loads for the first time
  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https('flutter-practice-58b62-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);

    if(response.statusCode >= 400) {
      throw Exception('Failed to fetch grocery Items! try again later');
    }

    //if no initial items on lkist have this checkl (firebase returns a string 'null' it is backend specific so look into it)
    if(response.body == 'null') {
      return [];
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadItems = [];

    for(final item in listData.entries) {
      //temp val for category in item
      final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
      loadItems.add(
        GroceryItem(
          id: item.key, 
          name: item.value['name'], 
          quantity: item.value['quantity'], 
          category: category
        )
      );
    }

    return loadItems;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      )
    );

    if(newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-practice-58b62-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    //something wrong went with http delete so just bring back item for now
    if(response.statusCode >= 400) {
      //Optional show error message
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet'),);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem, 
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadedItems, 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            return Center(child: Text(snapshot.hasError.toString()),);
          }

          if(snapshot.data!.isEmpty) {
            return const Center(child: Text('No items added yet'),);
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,     //find out how many times list view needs to iterate builder
            itemBuilder: (ctx, index) => Dismissible(
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              key: ValueKey(snapshot.data![index].id),
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![index].category.color,
                ),
                trailing: Text(snapshot.data![index].quantity.toString()),
              ),
            ),
          );
        }
      ),
    );
  }
}

*/