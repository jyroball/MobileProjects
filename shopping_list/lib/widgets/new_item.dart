import 'package:http/http.dart' as http;    //using "as" bundles package to object of "http"
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'dart:convert';  //converts objects to json dart package

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    //runs all validate functions in Forms
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final url = Uri.https('flutter-practice-58b62-default-rtdb.firebaseio.com', 'shopping-list.json');
      final response = await http.post(
        url, 
        headers: {
          'Content-Type' : 'application/json'
        }, 
        body: json.encode(
          {
            'name': _enteredName, 
            'quantity': _enteredQuantity, 
            'category': _selectedCategory.title,
          },
        ),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      //if context not part anumore
      if(!context.mounted) {
        return;
      }

      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName, 
        quantity: _enteredQuantity, 
        category: _selectedCategory
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length > 50) {
                    //error message
                    return 'Must be between 1 and 50 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if(value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                          //error message
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for(final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 6,),
                              Text(category.value.title)
                              ]
                            ),
                          )
                      ], 
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending ? null : () {
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem, 
                    child: _isSending ? const SizedBox(
                        height: 16, 
                        width: 16, 
                        child: CircularProgressIndicator()
                      ) : 
                      const Text('Add Item')
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}